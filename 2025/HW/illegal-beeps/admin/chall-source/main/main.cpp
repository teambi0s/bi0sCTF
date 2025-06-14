#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"
#include "driver/ledc.h"
#include "driver/gpio.h"
#include "driver/uart.h"
#include "esp_timer.h"
#include "xtensa/core-macros.h"
#include "esp_system.h"
#include "esp_attr.h"
#include <string.h>
#include <stdio.h>

#define BUZZER_PIN          23
#define UART_NUM            UART_NUM_0
#define UART_TX_PIN         1
#define UART_RX_PIN         3

#define BASE_FREQ           2000
#define FREQ_STEP           150
#define SYMBOLS             8
#define TONE_DURATION_MS    60
#define SYMBOL_GAP_MS       20

#define PREAMBLE_FREQ       2800
#define POSTAMBLE_FREQ      3200

#define MESSAGE_LENGTH      36

volatile uint8_t DRAM_ATTR ill_depth = 0;
volatile uint8_t DRAM_ATTR scramble_key = 0x00;

// -- Ill handler --
void IRAM_ATTR what_handler(XtExcFrame *frame) {
    scramble_key = rand() % 0xFF;
    if (ill_depth < 2) {
        ill_depth = ill_depth + 1;
        asm volatile ("ill");
        ill_depth = ill_depth - 1;
    }
    frame->pc += 3;
}

// --- Custom ELF section for checksum ---
__attribute__((section(".what_text")))
static int calculateCustomChecksum(const char* message)
{
    int checksum = 17;
    for (int i = 0; i < strlen(message); i++)
    {
        // Xtensa-specific: extui (extract unsigned bitfield)
        int t;
        asm volatile ("extui %0, %1, 2, 5" : "=r"(t) : "r"(message[i]));
        checksum = (checksum * (t + 7)) % 9973;
    }
    return checksum;
}

// --- Anti-debugging: timing-based ---
__attribute__((section(".what_text")))
static int simple_antidebug()
{
    uint64_t start = esp_timer_get_time();

    asm volatile ("ill");
    vTaskDelay(pdMS_TO_TICKS(10));
    uint64_t end = esp_timer_get_time();
    // timing based: prevent single stepping
    if ((end - start) > 50000) // >40ms
        return 1;
    return 0;
}

// --- Buzzer and UART initialization ---
void init_buzzer() {
    ledc_timer_config_t ledc_timer = {
        .speed_mode = LEDC_HIGH_SPEED_MODE,
        .duty_resolution = LEDC_TIMER_8_BIT,
        .timer_num = LEDC_TIMER_0,
        .freq_hz = BASE_FREQ,
        .clk_cfg = LEDC_AUTO_CLK
    };
    ledc_timer_config(&ledc_timer);

    ledc_channel_config_t ledc_channel = {
        .gpio_num = BUZZER_PIN,
        .speed_mode = LEDC_HIGH_SPEED_MODE,
        .channel = LEDC_CHANNEL_0,
        .intr_type = LEDC_INTR_DISABLE,
        .timer_sel = LEDC_TIMER_0,
        .duty = 0,
        .hpoint = 0,
        .flags = 0
    };
    ledc_channel_config(&ledc_channel);
}

void init_uart() {
    uart_config_t uart_config = {
        .baud_rate = 115200,
        .data_bits = UART_DATA_8_BITS,
        .parity = UART_PARITY_DISABLE,
        .stop_bits = UART_STOP_BITS_1,
        .flow_ctrl = UART_HW_FLOWCTRL_DISABLE,
        .rx_flow_ctrl_thresh = 0,  // Warning fix
        .source_clk = UART_SCLK_APB
    };
    uart_param_config(UART_NUM, &uart_config);
    uart_driver_install(UART_NUM, 1024, 1024, 0, NULL, 0);
}

// --- Tone/symbol helpers ---
static void generateCustomTone(int frequency, int duration_ms)
{
    ledc_set_freq(LEDC_HIGH_SPEED_MODE, LEDC_TIMER_0, frequency);
    ledc_set_duty(LEDC_HIGH_SPEED_MODE, LEDC_CHANNEL_0, 128);
    ledc_update_duty(LEDC_HIGH_SPEED_MODE, LEDC_CHANNEL_0);
    vTaskDelay(pdMS_TO_TICKS(duration_ms));
    ledc_set_duty(LEDC_HIGH_SPEED_MODE, LEDC_CHANNEL_0, 0);
    ledc_update_duty(LEDC_HIGH_SPEED_MODE, LEDC_CHANNEL_0);
}

static void sendCustomSymbol(uint8_t symbol)
{
    symbol = symbol % SYMBOLS;
    int frequency = BASE_FREQ + (symbol * FREQ_STEP);
    generateCustomTone(frequency, TONE_DURATION_MS);
    vTaskDelay(pdMS_TO_TICKS(SYMBOL_GAP_MS));
}

static void sendCustomByte(uint8_t data)
{
    sendCustomSymbol(data / 64);
    sendCustomSymbol((data / 8) % 8);
    sendCustomSymbol(data % 8);
}

static void sendCustomValue(int value)
{
    if (value > 262143)
        value = value % 262144;

    asm volatile ("ill");
    int divisor = 32768;
    while (divisor > 0)
    {
        sendCustomSymbol((value / divisor) % 8);
        divisor /= 8;
    }
}

static void sendCustomPreamble()
{
    for (int i = 0; i < 4; i++)
    {
        generateCustomTone(PREAMBLE_FREQ, 120);
        vTaskDelay(pdMS_TO_TICKS(20));
        generateCustomTone(PREAMBLE_FREQ - 500, 120);
        vTaskDelay(pdMS_TO_TICKS(20));
    }
    vTaskDelay(pdMS_TO_TICKS(200));
}

static void sendCustomPostamble()
{
    vTaskDelay(pdMS_TO_TICKS(200));
    for (int i = 0; i < 5; i++)
    {
        int freq = POSTAMBLE_FREQ - (i * 150);
        generateCustomTone(freq, 120);
        vTaskDelay(pdMS_TO_TICKS(20));
    }
}

// --- FreeRTOS Idle Hook ---
void vApplicationIdleHook(void)
{
    static int idle_counter = 0;
    idle_counter++;
    if (idle_counter % 2048 == 0) {
        // Short beep every so often (obfuscated)
        asm volatile("extui a2, a2, 3, 2");
        generateCustomTone(PREAMBLE_FREQ, 30);
    }
}

// --- Task and queue for obfuscation ---
static QueueHandle_t scramble_queue, send_queue;

// Obfuscated scrambling task (uses Xtensa instructions)
void scrambler_task(void *pv)
{
    char message[MESSAGE_LENGTH + 1];
    while (1) {
        if (xQueueReceive(scramble_queue, message, portMAX_DELAY)) {
            uint8_t key = 0x00;
            for (int i = 0; i < MESSAGE_LENGTH; i++) {
                asm volatile ("ill");
                key = scramble_key;
                message[i] = (message[i] ^ key) % 251;
                asm volatile ("ill");
                // printf("0x%X,", key );
                key = (key * 0x69 + message[i]) % 256; // gets overwritten so doesn't matter
            }
            // for (int i = 0; i < MESSAGE_LENGTH; i++) {
            //     printf("%x ", message[i]);
            // }
            printf("\n");
            xQueueSend(send_queue, message, portMAX_DELAY);
        }
    }
}

// Sending task (splits logic)
void sender_task(void *pv)
{
    char message[MESSAGE_LENGTH + 1];
    while (1) {
        if (xQueueReceive(send_queue, message, portMAX_DELAY)) {
            sendCustomPreamble();
            for (int i = 0; i < MESSAGE_LENGTH; i++) {
                sendCustomByte((uint8_t)message[i]);
            }
            int checksum = calculateCustomChecksum(message);
            sendCustomValue(checksum);
            sendCustomPostamble();
            printf("Done!\n");
        }
    }
}

// --- Main application ---
extern "C" void app_main(void)
{
    xt_set_exception_handler(0, what_handler);
    
    if (simple_antidebug()) {
        printf("eh? Debugger? Abort.\n");
        while (1) vTaskDelay(1000 / portTICK_PERIOD_MS);
    }

    init_uart();
    init_buzzer();

    scramble_queue = xQueueCreate(1, MESSAGE_LENGTH + 1);
    send_queue = xQueueCreate(1, MESSAGE_LENGTH + 1);

    xTaskCreate(scrambler_task, "scrambler_task", 2048, NULL, 5, NULL);
    xTaskCreate(sender_task, "sender_task", 2048, NULL, 4, NULL);

    char rx_buffer[128];

    printf("\n\n[*] Encoder Initialized!! \n\n");

    while (1)
    {

        int len = uart_read_bytes(UART_NUM, (uint8_t *)rx_buffer, sizeof(rx_buffer) - 1, pdMS_TO_TICKS(100));
        if (len > 0)
        {
            rx_buffer[len] = 0;
            char *newline = strchr(rx_buffer, '\n');
            if (newline) *newline = 0;

            char message[MESSAGE_LENGTH + 1] = {0};
            strncpy(message, rx_buffer, MESSAGE_LENGTH);

            int msg_len = strlen(message);
            while (msg_len < MESSAGE_LENGTH)
            {
                if (msg_len <= MESSAGE_LENGTH - 2)
                {
                    message[msg_len++] = ':';
                    message[msg_len++] = ')';
                }
                else
                {
                    message[msg_len++] = '=';
                }
            }
            message[MESSAGE_LENGTH] = 0;
            srand(message[0]);
            printf("Processed message: '%s'\n\n", message);

            xQueueSend(scramble_queue, message, portMAX_DELAY);
            vTaskDelay(pdMS_TO_TICKS(1000));
        }
    }
}

