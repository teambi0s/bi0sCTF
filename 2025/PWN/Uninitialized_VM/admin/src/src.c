#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define MAX_CODE 0x100
#define MAX_STACK 0x100
#define MAX_REGS 0x8


enum op {
    PUSH = 0x31,
    PUSH_R = 0x32,
    POP_R = 0x33,
    MOV = 0x34,
    MOV_R_X = 0x35,
    CPY = 0x36,
    AND = 0x37,
    OR = 0x38,
    XOR = 0x39,
    NOT = 0x40,
    SHR = 0x41,
    SHL = 0x42,
    ADD = 0x43,
    SUB = 0x44,
    JMP = 0x45,
};

struct memory {
    unsigned char code_mem[MAX_CODE];
    uint64_t data_mem[MAX_STACK];
};

struct regs {
    unsigned char * pc; 
    uint64_t * sp;
    uint64_t * bp;
    uint64_t regs[MAX_REGS];
};

void init() {
    setvbuf(stdin, NULL, _IONBF, 0);
    setvbuf(stdout, NULL, _IONBF, 0);
}

int expand(struct regs ** reg, struct memory ** mem) {
    struct memory * mctx = calloc(sizeof(struct memory), 1);
    struct regs * rctx = calloc(sizeof(struct regs), 1);
    if ((int64_t)mctx == -1 || (int64_t)rctx == -1) { perror("CALLOC FAIL"); return 1; }

    memcpy(mctx->data_mem, (*mem)->data_mem, sizeof(mctx->data_mem));
    memcpy(rctx, *reg, sizeof(struct regs));
    
    rctx->bp = &mctx->data_mem[MAX_STACK-1];
    rctx->sp = rctx->bp - ((*reg)->bp - (*reg)->sp); 
    rctx->pc = &mctx->code_mem[0];

    free(*mem);
    free(*reg);
   
    *mem = mctx;
    *reg = rctx;
    return 0;
}

int main() {
    init();
    uint8_t r8_1 = 0, r8_2 = 0;
    uint16_t r16_1 = 0, len = MAX_STACK+1;
    uint64_t * r64_1 = NULL,* r64_2 = NULL;
    struct memory * mctx = calloc(sizeof(struct memory), 1);
    struct regs  * rctx = calloc(sizeof(struct regs), 1);
    
    if ((int64_t)mctx == -1 || (int64_t)rctx == -1) { perror("CALLOC FAIL"); return 1; }
    
    rctx->bp = &mctx->data_mem[MAX_STACK-1];
    rctx->sp = rctx->bp; 
    rctx->pc = &mctx->code_mem[0];
    
    printf("[ lEn? ] >> ");
    scanf("%hd",&len);
    len = len % MAX_CODE;

    printf("[ BYTECODE ] >>");
    read(0, mctx->code_mem, len);
    
    while (rctx->pc < mctx->code_mem+len) {
        switch(*rctx->pc) {
            case PUSH:
                if (rctx->sp >= mctx->data_mem) { 
                    int op = *(++rctx->pc);
                    *(rctx->sp--) = op;                    
                    rctx->pc++;
                }
                break;
            case PUSH_R:
                if (rctx->sp >= mctx->data_mem) {
                    r8_1 = *(++rctx->pc) % MAX_REGS;
                    *(rctx->sp--) = rctx->regs[r8_1];
                    rctx->pc++;
                    break;
                }
                break;
            case POP_R:
                if (rctx->sp <= rctx->bp) {
                    r8_1 = *(++rctx->pc) % MAX_REGS;
                    rctx->regs[r8_1] = *(++rctx->sp);
                    rctx->pc++;
                    break;
                }
                break;
            case MOV:
                r8_1 = *(++rctx->pc) % MAX_REGS;
                r8_2 = *(++rctx->pc) % MAX_REGS;
                rctx->regs[r8_1] = rctx->regs[r8_2];
                rctx->pc++;
                break;
            case MOV_R_X:
                r8_1 = *(++rctx->pc) % MAX_REGS;
                rctx->regs[r8_1] = *(uint64_t *)(++rctx->pc);
                rctx->pc += 8;
                break;
            case CPY:
                r64_1 = mctx->data_mem + (rctx->regs[*(++rctx->pc) % MAX_REGS] % MAX_STACK);
                r64_2 = mctx->data_mem + (rctx->regs[*(++rctx->pc) % MAX_REGS] % MAX_STACK);
                r8_1 = *(++rctx->pc) % MAX_STACK - 1;
                rctx->pc += 2;
                memcpy(r64_1, r64_2, r8_1);  
                break;
            case AND:
                r8_1 = *(++rctx->pc) % MAX_REGS;
                r8_2 = *(++rctx->pc) % MAX_REGS;
                rctx->regs[r8_1] = rctx->regs[r8_1] & rctx->regs[r8_2]; 
                rctx->pc++;
                break;
            case OR:
                r8_1 = *(++rctx->pc) % MAX_REGS;
                r8_2 = *(++rctx->pc) % MAX_REGS;
                rctx->regs[r8_1] = rctx->regs[r8_1] | rctx->regs[r8_2]; 
                rctx->pc++;
                break;
            case XOR:
                r8_1 = *(++rctx->pc) % MAX_REGS;
                r8_2 = *(++rctx->pc) % MAX_REGS;
                rctx->regs[r8_1] = rctx->regs[r8_1] ^ rctx->regs[r8_2]; 
                rctx->pc++;
                break;
            case NOT:
                r8_1 = *(++rctx->pc) % MAX_REGS;
                rctx->regs[r8_1] = ~rctx->regs[r8_1];
                rctx->pc++;
                break;
            case SHR:
                r8_1 = *(++rctx->pc) % MAX_REGS;
                r8_2 = *(++rctx->pc) % MAX_REGS;
                rctx->regs[r8_1] = rctx->regs[r8_1] >> rctx->regs[r8_2];
                rctx->pc++;
                break;
            case SHL:
                r8_1 = *(++rctx->pc) % MAX_REGS;
                r8_2 = *(++rctx->pc) % MAX_REGS;
                rctx->regs[r8_1] = rctx->regs[r8_1] << rctx->regs[r8_2];
                rctx->pc++;
                break;
            case ADD:
                r8_1 = *(++rctx->pc) % MAX_REGS;
                r8_2 = *(++rctx->pc) % MAX_REGS;
                rctx->regs[r8_1] = rctx->regs[r8_1] + rctx->regs[r8_2]; 
                rctx->pc++;
                break;
            case SUB:
                r8_1 = *(++rctx->pc) % MAX_REGS;
                r8_2 = *(++rctx->pc) % MAX_REGS;
                rctx->regs[r8_1] = rctx->regs[r8_1] - rctx->regs[r8_2]; 
                rctx->pc++;
                break;
            case JMP:
                r16_1 = *(++rctx->pc) % MAX_CODE;
                rctx->pc = mctx->code_mem + r16_1; 
                break;      
            default:
                if (rctx->pc < mctx->code_mem+len) {
                    int fail = expand(&rctx, &mctx);
                    if (fail == 1) { perror("CALLOC FAIL"); return 1; }

                    printf("[ lEn? ] >> ");
                    scanf("%hd",&len);
                    len = len % MAX_CODE;

                    printf("[ BYTECODE ] >>");
                    read(0, mctx->code_mem, len);
                } else {
                    rctx->pc++;
                }
        }
    }
    return 0;
}
