/*
mov rax, 4675 //input
mov rbx, 12288 //username_output
mov rdx, 16384 //add_val
mov rdi, 13568 //mul_val
mov r9, 32
mov rcx, 0
1:
mov rsi, [rax]
mov r8, [rdx]
add rsi, r8
mov [rdx], rsi
add rax, 1
add rdx, 1
add rcx, 1
cmp rcx, r9
jz 2
jmp 1:
2:
ret
*/

#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>
#include <errno.h>
#include <string.h> 
#include <stdint.h>
#include <elf.h>
#include <signal.h>
#include <link.h>
#include <dlfcn.h>
#include <fcntl.h>
#include <stdlib.h>
#include <time.h>
#include <sys/ptrace.h>

// DEFINES
#define OBSCURE(x) ((x) ^ 0xDEADBEEF)
#define ROTL32(x, n) (((x) << (n)) | ((x) >> (32 - (n))))
#define QR(a, b, c, d) ( \
    a += b, d ^= a, d = ROTL32(d, 16), \
    c += d, b ^= c, b = ROTL32(b, 12), \
    a += b, d ^= a, d = ROTL32(d, 8), \
    c += d, b ^= c, b = ROTL32(b, 7))

// GLOBAL VALUES
unsigned char key[] = {0x69, 0x79, 0x34, 0x23, 0x56, 0x23, 0x56, 0x35,
    0x64, 0x45, 0x56, 0x34, 0x57, 0x73, 0x23, 0x23};
size_t keylen = 16;
uint8_t key_cha_cha[32] = {44,155,95,3,242,195,36,209,223,101,236,84,13,210,66,158,146,86,187,95,233,24,240,191,40,21,215,122,71,88,6,119};
uint8_t nonce[12] = {64,97,242,19,37,51,56,220,2,78,39,137};
uint64_t counter = 0;
uint8_t final_flag[] = {0x3e,0x02,0x68,0x20,0x25,0xa9,0x7e,0xf0,0xdb,0x4a,0x85,0xb5,0x1d,0xbf,0x1b,0x79,0xc2};
int final_username_part[] = {1048, 616, 714, 872, 630, 94, 455, 402, 1152, 560, 408, 798, 603, 1190};
unsigned char *username_ptr = NULL;
char *malloc_ptr_global = NULL;
char *malloc_reg;
unsigned int flag = 0;
unsigned int label_to_jump = 0;
unsigned int CODE[] ={1, 0, 4675, 1, 1, 12288, 1, 3, 16384, 1, 4, 13568, 1, 7, 14, 1, 2, 0, 21, 1, 0, 19, 5, 0, 19, 6, 3, 3, 5, 6, 18, 5, 3, 14, 0, 1, 14, 3, 1, 14, 2, 1, 22, 2, 7, 20, 2, 0, 24, 1, 0, 21, 2, 0, 1, 2, 0, 1, 3, 16384, 21, 3, 0, 19, 5, 3, 19, 6, 4, 5, 6, 5, 18, 6, 4, 14, 3, 1, 14, 4, 1, 14, 2, 1, 22, 2, 7, 20, 4, 0, 24, 3, 0, 21, 4, 0, 1, 0, 0, 1, 2, 0, 1, 4, 13568, 21, 5, 0, 19, 5, 4, 19, 6, 1, 27, 6, 5, 3, 0, 6, 14, 4, 1, 14, 1, 1, 14, 2, 1, 22, 2, 7, 20, 6, 0, 24, 5, 0, 21, 6, 0, 26, 0, 0};
int add_val[] = {23,28,12,8,11,10,13,26,20,25,25,24,16,9};
int mul_val[] = {8,8,6,8,5,1,7,3,9,5,3,6,9,10};
int label_map_size = 0;


// ChaCha20 constants
static const uint32_t chacha20_constants[4] = {OBSCURE(0x61707865), OBSCURE(0x3320646e), OBSCURE(0x79622d32), OBSCURE(0x6b206574)};

// STRUCTURES
struct chacha20_context {
    uint32_t state[16];
    uint32_t keystream32[16];
    uint8_t key[32];
    uint8_t nonce[12];
    uint64_t counter;
    size_t position;
};
struct instruction {
    unsigned int opcode;
    unsigned int operand1;
    unsigned int operand2;
};
struct memory {
    unsigned int memory[0x5000];
};
struct label_map_entry {
    char key;
    long long int value;
};

//STRUCUTE INITIALIZATION
struct memory memory = {0};
struct label_map_entry label_map[256];

// FUNCTION PROTOTYPES
void make_func_rwx();
void detected_fuck(int val1);
void cipher(unsigned char* data, size_t len, const unsigned char* key, size_t keylen);
uint32_t rotl32(uint32_t x, int n);
uint32_t pack4(const uint8_t *a);
void chacha20_init_block(struct chacha20_context *ctx, uint8_t key[], uint8_t nonce[]);
void chacha20_block_set_counter(struct chacha20_context *ctx, uint64_t counter);
void chacha20_block_next(struct chacha20_context *ctx);
void chacha20_init_context(struct chacha20_context *ctx, uint8_t key[], uint8_t nonce[], uint64_t counter);
void chacha20_xor(struct chacha20_context *ctx, uint8_t *bytes, size_t n_bytes);
void check(char* enc_inp);
void rest_of_input_check();
int vm();
void setup();
// FUNCTIONS

int main(int argc, char * argv[])
{



    
    // make_text_rwx();
    if (argc < 4) {
    exit(1);
    }
    srand(time(NULL));
    struct chacha20_context ctx;
    char * pid = argv[1]; //PID TO BE SET
    if (!argv[1])
    {
        exit(0);
    }
    // printf("PID      : %s\n", pid);
    int pid_val = atoi(pid);
    
    detected_fuck(pid_val);
    char *psswd = argv[2]; //ACTUAL PASSWORD OF THE ACCOUNT
    uint8_t *password = calloc(512, 1); 
    strcpy((char *)password, psswd); 
    // printf("Password : %s\n", password);

    size_t size_of_buffer = strlen((char *)password);

	username_ptr = argv[3]; // USERNAME FOR THE CHECK IN 2nd PART
    // printf("Username : %s\n", argv[3]);

    make_func_rwx(chacha20_init_context, 0x113);
    guard((unsigned char*) chacha20_init_context, 0x113);
    chacha20_init_context(&ctx, key_cha_cha, nonce, counter);
    guard((unsigned char*) chacha20_init_context, 0x113);

    make_func_rwx(chacha20_xor, 0x1ad);
    guard((unsigned char*) chacha20_xor, 0x1ad);
    chacha20_xor(&ctx, password, size_of_buffer);
    guard((unsigned char*) chacha20_xor, 0x1ad);

    // for(int i = 0; i < 17; i++)
    // {
    //     printf("0x%02x,",password[i]);
    // }


    

    make_func_rwx(check, 0x98);
    guard((unsigned char*) check, 0x98);
    check((char *)password);
    guard((unsigned char*) check, 0x98);

    return 0;
}

//=============== setup ===============
__attribute__((section(".text")))
void setup()
{
    sleep(1);
    for(int i = 0x1243; i < (0x1243+0xe); i++)
    {
        // //printf("Setting memory[%x] = %x\n", i, username_ptr[i-0x1243]);
        memory.memory[i] = username_ptr[i-0x1243];
    }
    for(int i = 0x3000; i < 0x300e; i++)
    {
        //printf("Setting memory[%x] = %x\n", i, final_username_part[i-0x3000]);
        memory.memory[i] = final_username_part[i-0x3000];
    }
    for(int i = 0x4000; i < 0x400e; i++)
    {
        //printf("Setting memory[%x] = %x\n", i, add_val[i-0x4000]);
        memory.memory[i] = add_val[i-0x4000];
    }
    for(int i = 0x3500; i < 0x350e; i++)
    {
        //printf("Setting memory[%x] = %x\n", i, mul_val[i-0x3500]);
        memory.memory[i] = mul_val[i-0x3500];
    }
    vm();
}

//=============== vm ===============
__attribute__((section(".text")))
int vm() {
    struct instruction instruction;
    while (1) {
        instruction.opcode = CODE[memory.memory[0x9]];
        instruction.operand1 = CODE[memory.memory[0x9] + 1];
        instruction.operand2 = CODE[memory.memory[0x9] + 2];
        
        //printf("PC: %x, Opcode: %x, Operand1: %x, Operand2: %x\n",
            //    memory.memory[0x9], instruction.opcode, instruction.operand1, instruction.operand2);
        
        if (flag == 1 && (instruction.opcode != 0x15 && instruction.opcode != 0x14)) {
            //printf("Flag set, exiting loop (not 0x15 or 0x14)\n");
            goto end;
        }

        switch (instruction.opcode) {
            case 0x01:
                //printf("MOV memory[%x] = %x\n", instruction.operand1, instruction.operand2);
                memory.memory[instruction.operand1] = (instruction.operand2 & 0xffffffff);
                //printf("After MOV: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x02:
                //printf("MOV memory[%x] = memory[%x] (%x)\n", instruction.operand1, instruction.operand2, memory.memory[instruction.operand2]);
                memory.memory[instruction.operand1] = (memory.memory[instruction.operand2]) & 0xffffffff;
                //printf("After MOV: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x12:
            {
                unsigned int val = memory.memory[instruction.operand2];
                //printf("MOV memory[memory[%x]] = memory[%x] (%x = %x)\n", instruction.operand2, instruction.operand1, val, memory.memory[instruction.operand1]);
                memory.memory[val] = memory.memory[instruction.operand1] & 0xffffffff;
                //printf("After MOV: memory[%x] = %x\n", val, memory.memory[val]);
                break;
            }
            case 0x13:
            {
                unsigned int val = memory.memory[instruction.operand2];
                //printf("MOV memory[%x] = memory[memory[%x]] (%x)\n", instruction.operand1, instruction.operand2, memory.memory[val]);
                memory.memory[instruction.operand1] = memory.memory[val] & 0xffffffff;
                //l4d1eS-m4n-2i6-fr("After MOV: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            }
            case 0x03:
                //printf("ADD memory[%x] += memory[%x] (%x += %x)\n", instruction.operand1, instruction.operand2, memory.memory[instruction.operand1], memory.memory[instruction.operand2]);
                memory.memory[instruction.operand1] += memory.memory[instruction.operand2] & 0xffffffff;
                //printf("After ADD: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x0e:
                //printf("ADD memory[%x] += %x\n", instruction.operand1, instruction.operand2);
                memory.memory[instruction.operand1] += instruction.operand2;
                //printf("After ADD: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x04:
                //printf("SUB memory[%x] -= memory[%x] (%x -= %x)\n", instruction.operand1, instruction.operand2, memory.memory[instruction.operand1], memory.memory[instruction.operand2]);
                memory.memory[instruction.operand1] -= memory.memory[instruction.operand2];
                //printf("After SUB: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x0f:
                //printf("SUB memory[%x] -= %x\n", instruction.operand1, instruction.operand2);
                memory.memory[instruction.operand1] -= instruction.operand2;
                //printf("After SUB: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x05:
                //printf("MUL memory[%x] *= memory[%x] (%x *= %x)\n", instruction.operand1, instruction.operand2, memory.memory[instruction.operand1], memory.memory[instruction.operand2]);
                memory.memory[instruction.operand1] *= memory.memory[instruction.operand2];
                //printf("After MUL: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x10:
                //printf("MUL memory[%x] *= %x\n", instruction.operand1, instruction.operand2);
                memory.memory[instruction.operand1] *= instruction.operand2;
                //printf("After MUL: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x06:
                //printf("DIV memory[%x] /= memory[%x] (%x /= %x)\n", instruction.operand1, instruction.operand2, memory.memory[instruction.operand1], memory.memory[instruction.operand2]);
                memory.memory[instruction.operand1] /= memory.memory[instruction.operand2];
                //printf("After DIV: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x07:
                //printf("AND memory[%x] &= %x\n", instruction.operand1, instruction.operand2);
                memory.memory[instruction.operand1] &= instruction.operand2;
                //printf("After AND: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x08:
                //printf("OR memory[%x] |= %x\n", instruction.operand1, instruction.operand2);
                memory.memory[instruction.operand1] |= instruction.operand2;
                //printf("After OR: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x1b:
                //printf("XOR memory[%x] ^= memory[%x] (%x ^= %x)\n", instruction.operand1, instruction.operand2, memory.memory[instruction.operand1], memory.memory[instruction.operand2]);
                memory.memory[instruction.operand1] ^= memory.memory[instruction.operand2];
                //printf("After XOR: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x09:
                //printf("XOR memory[%x] ^= %x\n", instruction.operand1, instruction.operand2);
                memory.memory[instruction.operand1] ^= instruction.operand2;
                //printf("After XOR: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x0a:
                //printf("SHL memory[%x] <<= memory[%x] (%x <<= %x)\n", instruction.operand1, instruction.operand2, memory.memory[instruction.operand1], memory.memory[instruction.operand2]);
                memory.memory[instruction.operand1] <<= memory.memory[instruction.operand2];
                //printf("After SHL: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x0b:
                //printf("SHR memory[%x] >>= memory[%x] (%x >>= %x)\n", instruction.operand1, instruction.operand2, memory.memory[instruction.operand1], memory.memory[instruction.operand2]);
                memory.memory[instruction.operand1] >>= memory.memory[instruction.operand2];
                //printf("After SHR: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x0c:
                //printf("SHL memory[%x] <<= %x\n", instruction.operand1, instruction.operand2);
                memory.memory[instruction.operand1] <<= instruction.operand2;
                //printf("After SHL: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x0d:
                //printf("SHR memory[%x] >>= %x\n", instruction.operand1, instruction.operand2);
                memory.memory[instruction.operand1] >>= instruction.operand2;
                //printf("After SHR: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            case 0x11:
            {
                //printf("MOD memory[%x] %% memory[%x] (%x %% %x)\n", instruction.operand1, instruction.operand2, memory.memory[instruction.operand1], memory.memory[instruction.operand2]);
                char val = memory.memory[instruction.operand1] % memory.memory[instruction.operand2];
                memory.memory[instruction.operand1] = val;
                //printf("After MOD: memory[%x] = %x\n", instruction.operand1, memory.memory[instruction.operand1]);
                break;
            }
            case 0x15:
            {
                //printf("LABEL %x at PC %x\n", instruction.operand1, memory.memory[0x9]);
                label_map[label_map_size].key = instruction.operand1;
                label_map[label_map_size].value = memory.memory[0x9];
                label_map_size++;
                if (label_to_jump == instruction.operand1) {
                    //printf("Jumping to label %x\n", instruction.operand1);
                    goto jmp;
                }
                break;
            }
            case 0x18:
            {
            jmp:
                //printf("JMP to label %x\n", instruction.operand1);
                int found = 0;
                for (int i = 0; i < label_map_size; i++) {
                    if (label_map[i].key == instruction.operand1) {
                        memory.memory[0x9] = label_map[i].value;
                        flag = 0;
                        found = 1;
                        //printf("Jumped to PC %x\n", memory.memory[0x9]);
                        break;
                    }
                }
                if (!found) {
                    //printf("Label %x not found, setting flag\n", instruction.operand1);
                    label_to_jump = instruction.operand1;
                    flag = 1;
                }
                break;
            }
            case 0x14:
            {
                //printf("JZ to label %x (ZF = %x)\n", instruction.operand1, memory.memory[0x0a]);
                if (memory.memory[0x0a] == 0) {
                    int found = 0;
                    for (int i = 0; i < label_map_size; i++) {
                        if (label_map[i].key == instruction.operand1) {
                            memory.memory[0x9] = label_map[i].value;
                            found = 1;
                            //printf("Zero flag set, jumped to PC %x\n", memory.memory[0x9]);
                            break;
                        }
                    }
                    if (!found) {
                        //printf("Label %x not found, setting flag\n", instruction.operand1);
                        flag = 1;
                        label_to_jump = instruction.operand1;
                        goto end;
                    }
                }
                break;
            }
            case 0x16:
            {
                //printf("CMP memory[%x] (%x) == memory[%x] (%x)\n", instruction.operand1, memory.memory[instruction.operand1], instruction.operand2, memory.memory[instruction.operand2]);
                if (memory.memory[instruction.operand1] == memory.memory[instruction.operand2]) {
                    memory.memory[0x0a] = 0;
                    //printf("CMP set ZF to 0 (equal)\n");
                } else {
                    memory.memory[0x0a] = 1;
                    //printf("CMP set ZF to 1 (not equal)\n");
                }
                break;
            }
            case 0x1A:
            {
                //printf("CHECK memory[0] = %x (expecting 0x5820)\n", memory.memory[0]);
                //printf("Current memory status:\n");
                // for(int i = 0; i < 0x5000; i++) {
                //     //printf("%x,", memory.memory[i]);
                // }
                if (memory.memory[0] == 0) {
                    printf("\nPASSED DAT SHI\n");
                    return 1;
                } else {
                    return 0;
                }
            }
        }
    end:
        // //printf("Advancing PC: %x -> %x\n", memory.memory[0x9], memory.memory[0x9] + 3);
        memory.memory[0x9] += 3;
    }
}

//=============== rest_of_input_check ===============
__attribute__((section(".text")))
void rest_of_input_check()
{
    make_func_rwx(setup, 0x14d);
    guard((unsigned char *)setup, 0x14d);
    setup();
    guard((unsigned char *)setup, 0x14d);
	return; 
}

//=============== check ===============
__attribute__((section(".text")))
void check(char * input)
{
    if (memcmp(input, final_flag, sizeof(final_flag)) == 0) {
        printf("Password verified.\n");
        // asm("ud2");
        make_func_rwx(rest_of_input_check, 0x60);
        guard((unsigned char*)rest_of_input_check, 0x60);
        rest_of_input_check();
        guard((unsigned char*)rest_of_input_check, 0x60);

    } else {
        return ;
        // //printf("Password verification failed.\n");
    }
}

//=============== detected_fuck ===============
__attribute__((section(".text")))
void detected_fuck(pid_t val) {
    char path[64], buf[256];
    snprintf(path, sizeof(path), "/proc/%d/status", val);

    FILE *f = fopen(path, "r");
    if (!f) return;

    while (fgets(buf, sizeof(buf), f)) {
        if (strncmp(buf, "TracerPid:", 10) == 0) {
            int tracer_pid = atoi(buf + 10);
            if (tracer_pid != 0) {
                kill(val, SIGKILL);
                exit(1);
            }
            break;
        }
    }

    fclose(f);
}

//=============== cipher ===============
__attribute__((section(".text")))
void cipher(unsigned char* data, size_t len, const unsigned char* key, size_t keylen)
{
    for(size_t i = 0; i < len; i++)
    {
        data[i] ^= OBSCURE(key[i % keylen]) ^ 0xEF;
    }
}

//=============== rotl32 ===============
__attribute__((section(".text")))
uint32_t rotl32(uint32_t x, int n) 
{
    return (x << n) | (x >> (32 - n));
}

//=============== pack4 ===============
__attribute__((section(".text")))
uint32_t pack4(const uint8_t *a)
{
    uint32_t res = 0;
    res |= (uint32_t)a[0] << 0 * 8;
    res |= (uint32_t)a[1] << 1 * 8;
    res |= (uint32_t)a[2] << 2 * 8;
    res |= (uint32_t)a[3] << 3 * 8;
    return res;
}

//=============== chacha20_init_block ===============
__attribute__((section(".text")))
void chacha20_init_block(struct chacha20_context *ctx, uint8_t key[], uint8_t nonce[])
{
    ctx->state[0] = OBSCURE(chacha20_constants[0]);
    ctx->state[1] = OBSCURE(chacha20_constants[1]);
    ctx->state[2] = OBSCURE(chacha20_constants[2]);
    ctx->state[3] = OBSCURE(chacha20_constants[3]);

    for (int i = 0; i < 8; i++) {
        ctx->state[4 + i] = ((uint32_t)key[i * 4]) | ((uint32_t)key[i * 4 + 1] << 8) |
                           ((uint32_t)key[i * 4 + 2] << 16) | ((uint32_t)key[i * 4 + 3] << 24);
    }

    ctx->state[12] = 0; // Counter initialized later
    ctx->state[13] = ((uint32_t)nonce[0]) | ((uint32_t)nonce[1] << 8) |
                    ((uint32_t)nonce[2] << 16) | ((uint32_t)nonce[3] << 24);
    ctx->state[14] = ((uint32_t)nonce[4]) | ((uint32_t)nonce[5] << 8) |
                    ((uint32_t)nonce[6] << 16) | ((uint32_t)nonce[7] << 24);
    ctx->state[15] = ((uint32_t)nonce[8]) | ((uint32_t)nonce[9] << 8) |
                    ((uint32_t)nonce[10] << 16) | ((uint32_t)nonce[11] << 24);

    memcpy(ctx->key, key, sizeof(ctx->key));
    memcpy(ctx->nonce, nonce, sizeof(ctx->nonce));
}

//=============== chacha20_block_set_counter ===============
__attribute__((section(".text")))
void chacha20_block_set_counter(struct chacha20_context *ctx, uint64_t counter)
{
    ctx->state[12] = (uint32_t)counter;
    // Note: High 32 bits of counter ignored for simplicity, as in first implementation
}

//=============== chacha20_block_next ===============
__attribute__((section(".text")))
void chacha20_block_next(struct chacha20_context *ctx)
{
    uint32_t x[16];
    memcpy(x, ctx->state, 16 * sizeof(uint32_t));

    for (int i = 0; i < 10; i++) {
        QR(x[0], x[4], x[8], x[12]);
        QR(x[1], x[5], x[9], x[13]);
        QR(x[2], x[6], x[10], x[14]);
        QR(x[3], x[7], x[11], x[15]);
        QR(x[0], x[5], x[10], x[15]);
        QR(x[1], x[6], x[11], x[12]);
        QR(x[2], x[7], x[8], x[13]);
        QR(x[3], x[4], x[9], x[14]);
    }

    for (int i = 0; i < 16; i++) {
        ctx->keystream32[i] = x[i] + ctx->state[i];
    }

    ctx->state[12]++;
}

//=============== chacha20_init_context ===============
__attribute__((section(".text")))
void chacha20_init_context(struct chacha20_context *ctx, uint8_t key[], uint8_t nonce[], uint64_t counter)
{
    memset(ctx, 0, sizeof(struct chacha20_context));

    make_func_rwx(chacha20_init_block, 0x233);
    guard((unsigned char *)chacha20_init_block, 0x233); 
    chacha20_init_block(ctx, key, nonce);
    guard((unsigned char *)chacha20_init_block, 0x233);

    make_func_rwx(chacha20_block_set_counter,0x20);
    guard((unsigned char *)chacha20_block_set_counter, 0x20); 
    chacha20_block_set_counter(ctx, counter);
    guard((unsigned char *)chacha20_block_set_counter, 0x20); 

    ctx->counter = counter;
    ctx->position = 64;
}

//=============== chacha20_xor ===============
__attribute__((section(".text")))
void chacha20_xor(struct chacha20_context *ctx, uint8_t *bytes, size_t n_bytes)
{
    uint8_t keystream[64];
    size_t i;

    for (i = 0; i < n_bytes; i++) {
        if (ctx->position >= 64) {
            make_func_rwx(chacha20_block_next, 0x495);
            guard((unsigned char *) chacha20_block_next, 0x495);
            chacha20_block_next(ctx);
            ctx->position = 0;

            for (int j = 0; j < 16; j++) {
                keystream[j * 4] = (uint8_t)(ctx->keystream32[j]);
                keystream[j * 4 + 1] = (uint8_t)(ctx->keystream32[j] >> 8);
                keystream[j * 4 + 2] = (uint8_t)(ctx->keystream32[j] >> 16);
                keystream[j * 4 + 3] = (uint8_t)(ctx->keystream32[j] >> 24);
            }
        }
        bytes[i] ^= keystream[ctx->position];
        ctx->position++;
    }
}

//=============== make_func_rwx ===============
__attribute__((section(".text")))
void make_func_rwx(void *func, size_t size) {
    long pagesize = sysconf(_SC_PAGESIZE);
    if (pagesize == -1) {
        perror("sysconf");
        return;
    }

    uintptr_t start = (uintptr_t)func;
    uintptr_t end = start + size;

    // Align the start address down to the nearest page boundary
    uintptr_t page_start = start & ~(pagesize - 1);
    // Align the end address up to the nearest page boundary
    uintptr_t page_end = (end + pagesize - 1) & ~(pagesize - 1);

    size_t length = page_end - page_start;

    if (mprotect((void *)page_start, length, PROT_READ | PROT_WRITE | PROT_EXEC) != 0) {
        perror("mprotect");
    }
}

//=============== guard ===============
__attribute__((section(".text")))
void guard(unsigned char * func_addr, uint32_t size)
{
    static unsigned char* code_buffer = NULL;
    static size_t buffer_size = 0;

    cipher((unsigned char *) func_addr, size, key, keylen);
}