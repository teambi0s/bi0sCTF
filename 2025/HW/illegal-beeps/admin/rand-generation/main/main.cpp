#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"
#include <stdio.h>

#define MESSAGE_LENGTH 36

volatile u_int8_t scramble_key = 0x69;
volatile u_int8_t ill_depth = 0;

void ill_rand () {
    scramble_key = rand() % 0xFF;
    if (ill_depth < 2) {
        ill_depth = ill_depth + 1;
        ill_rand();
        ill_depth  = ill_depth - 1;
    }    
}

static QueueHandle_t scramble_queue;

void scrambler_rand (void *pv) {
    char message[MESSAGE_LENGTH+1];
    while (1) {
        if (xQueueReceive(scramble_queue, message, portMAX_DELAY)) {
            for (int i = 0; i < MESSAGE_LENGTH; i++) {
                ill_rand();
                printf( "0x%X,", scramble_key);
                ill_rand();
            }
            printf("\n");
        }
    }
}

extern "C" void app_main(void) {
    scramble_queue = xQueueCreate(1, MESSAGE_LENGTH + 1);
    xTaskCreate(scrambler_rand, "scrambler_task", 2048, NULL, 5, NULL);
    char message[MESSAGE_LENGTH + 1] = {0};
    xQueueSend(scramble_queue, message, portMAX_DELAY);
    while(1) {}
}