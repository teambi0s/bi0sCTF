#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <complex.h>
#include <ctype.h>
#include <setjmp.h>
#include "aes.h"
#include <sys/ptrace.h>

#define stackSize 0x1000 
#define mem_size 0x1000

#define CHECK_DEBUGGER                                                           \
    __asm__(                                                                     \
        ".intel_syntax noprefix;\n"                                              \
        "push rbx               \n" /* backup ebx */                             \
        "xor  ecx, ecx          \n"                                              \
        "mov rax, 0x22bc       \n" /* obfuscate syscall to confuse decompiler */\
        "cwd                    \n"                                              \
        "mov ebx, 0x156        \n" /* eax = 0x1a = ptrace */                    \
        "idiv bx                \n"                                              \
        "xor  ebx, ebx          \n" /* PTRACE_TRACEME */                         \
        "xor  edx, edx          \n"                                              \
        "or   dl, 1             \n"                                              \
        "xor  esi, esi          \n"                                              \
        "int  0x80              \n" /* do syscall */                             \
        "nop                    \n"                                              \
        /* eax is 0 or -1 (-1 mean debugger precense) */                         \
        "neg  eax               \n" /* -1 ~> 0, 0 ~> 1 */                        \
        "mov %0, eax           \n" /* store result */                           \
        "pop  rbx               \n"                                              \
        ".att_syntax noprefix;  \n"                                              \
        : "=r" (s)                                                     \
    )


int s = 0;

void __attribute__((constructor)) init()
{
    CHECK_DEBUGGER;
}

char b64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

int unk_0[] = {148, 36, 90, 207, 32, 145, 114, 252, 16, 154, 133, 190, 66, 240, 89, 106, 0, 0, 0, 0, 0, 0, 0, 0, 48, 23, 207, 60, 55, 127, 0, 0};
// int unk_0[] = {204, 61, 15, 18, 100, 153, 230, 89, 215, 240, 14, 193, 153, 233, 24, 137, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

// int unk_0[] = {};



void func_1( unsigned char in[], char b64str[], int len ) {
    unsigned char out[5];
    out[0] = b64[ in[0] >> 2 ];
    out[1] = b64[ ((in[0] & 0x03) << 4) | ((in[1] & 0xf0) >> 4) ];
    out[2] = (unsigned char) (len > 1 ? b64[ ((in[1] & 0x0f) << 2) |
             ((in[2] & 0xc0) >> 6) ] : '=');
    out[3] = (unsigned char) (len > 2 ? b64[ in[2] & 0x3f ] : '=');
    out[4] = '\0';
    strncat(b64str, out, sizeof(out));
}

void func_2(char *clrstr, char *b64dst) {
  unsigned char in[3];
  int i, len = 0;
  int j = 0;

  b64dst[0] = '\0';
  while(clrstr[j]) {
    len = 0;
    for(i=0; i<3; i++) {
     in[i] = (unsigned char) clrstr[j];
     if(clrstr[j]) {
        len++; j++;
      }
      else in[i] = 0;
    }
    if( len ) {
      func_1( in, b64dst, len );
    }
  }
}

struct Registers {
    int S0;
    int S1;
    int S2;
    int S3;
    int S4;
    int S5;
    int S6;
    int S7;
    int PC; 
    int SP; 
    int BP; 
    int MP;
    int EF;
    int ZF;
};

char* func_3(char* filename)
{
    FILE *filePtr;
    filePtr = fopen(filename, "rb");

    if (filePtr == NULL) {
        printf("Error opening the file");
        return NULL;
    }

    fseek(filePtr, 0L, SEEK_END); 
    long int fileSize = ftell(filePtr);
    fseek(filePtr, 0, SEEK_SET);

    char *fileContent = (char *)malloc((fileSize + 1) * sizeof(char));

    fread(fileContent, sizeof(char), fileSize, filePtr);
    fileContent[fileSize] = '\0';
    fclose(filePtr);

    return fileContent;
}

void func_4(int regist, int value, struct Registers *reg)
{
    switch(regist)
    {
        case 700:
            reg->S0 = value;
            break;
        case 701:
            reg->S1 = value;
            break;
        case 702:
            reg->S2 = value;
            break;
        case 703:
            reg->S3 = value;
            break;
        case 704: 
            reg->S4 = value;
            break;
        case 705:
            reg->S5 = value;
            break;
        case 706:
            reg->S6 = value;
            break;
        case 707:
            reg->S7 = value;
            break;
        case 708:
            reg->MP = value;
            break;
        default:
            printf("Invalid choice of register");
            exit(0);
    }
}

int func_5(int regist, struct Registers *reg)
{
    switch(regist)
    {
        case 700:
            return reg->S0;
            break;
        case 701:
            return reg->S1;
            break;
        case 702:
            return reg->S2;
            break;
        case 703:
            return reg->S3;
            break;
        case 704: 
            return reg->S4;
            break;
        case 705:
            return reg->S5;
            break;
        case 706:
            return reg->S6;
            break;
        case 707:
            return reg->S7;
            break;
        case 708:
            return reg->MP;
            break;
        default:
            printf("Invalid choice of register");
            exit(0);
    }
}

void func_6(int opcode, struct Registers *reg, char* Code, uint8_t ** Stack, uint8_t **memory)
{
    switch(opcode)
    {
        case 1200: //MOVR
        {
            char reg_sa[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            char reg_sb[4] = {Code[reg->PC + 7], Code[reg->PC + 8], Code[reg->PC + 9], '\0'};
            int reg_ia = atoi(reg_sa);
            int reg_ib = atoi(reg_sb);
            int val = func_5(reg_ib, reg);
            func_4(reg_ib, 0, reg);
            func_4(reg_ia, val, reg);
            reg->PC = reg->PC + 10;
            break;
        }
        case 1201: // COPI
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            char val[2] = {Code[reg->PC + 7], '\0'};
            int val0 = atoi(val);
            func_4(reg_i, val0, reg); 
            reg->PC = reg->PC+8; 
            break;
        }
        case 1202: //COPR
        {   
            char reg_sa[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            char reg_sb[4] = {Code[reg->PC + 7], Code[reg->PC + 8], Code[reg->PC + 9], '\0'};
            int reg_ia = atoi(reg_sa);
            int reg_ib = atoi(reg_sb);
            int val = func_5(reg_ib, reg);
            func_4(reg_ia, val, reg);
            reg->PC = reg->PC+10;
            break;
        }
        case 1203: // ADDI
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            char val[2] = {Code[reg->PC + 7], '\0'};
            int val0 = atoi(val);
            int a = func_5(reg_i, reg);
            func_4(reg_i, a + val0, reg);
            reg->PC = reg->PC + 8;
            break;
        }
        case 1204: // ADDR
        {
            char reg_sa[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            char reg_sb[4] = {Code[reg->PC + 7], Code[reg->PC + 8], Code[reg->PC + 9], '\0'};
            int reg_ia = atoi(reg_sa);
            int reg_ib = atoi(reg_sb);
            int reg_a = func_5(reg_ia, reg);
            int reg_b = func_5(reg_ib, reg);
            func_4(reg_ia, reg_a + reg_b, reg);
            reg->PC = reg->PC + 10;
            break;            
        }
        case 1205: // SUBI
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            char val[2] = {Code[reg->PC + 7], '\0'};
            int val0 = atoi(val);
            int a = func_5(reg_i, reg);
            func_4(reg_i, a - val0, reg);
            reg->PC = reg->PC + 8;
            break;
        }
        case 1206: // SUBR
        {
            char reg_sa[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            char reg_sb[4] = {Code[reg->PC + 7], Code[reg->PC + 8], Code[reg->PC + 9], '\0'};
            int reg_ia = atoi(reg_sa);
            int reg_ib = atoi(reg_sb);
            int reg_a = func_5(reg_ia, reg);
            int reg_b = func_5(reg_ib, reg);
            func_4(reg_ia, reg_a - reg_b, reg);
            reg->PC = reg->PC + 10;
            break;           
        }
        case 1207: // XORI
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            char val[2] = {Code[reg->PC + 7], '\0'};
            int val0 = atoi(val);
            int a = func_5(reg_i, reg);
            func_4(reg_i, a ^ val0, reg);
            reg->PC = reg->PC + 8;
            break;
        }
        case 1208: // XORR
        {
            char reg_sa[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            char reg_sb[4] = {Code[reg->PC + 7], Code[reg->PC + 8], Code[reg->PC + 9], '\0'};
            int reg_ia = atoi(reg_sa);
            int reg_ib = atoi(reg_sb);
            int reg_a = func_5(reg_ia, reg);
            int reg_b = func_5(reg_ib, reg);
            func_4(reg_ia, reg_a ^ reg_b, reg);
            reg->PC = reg->PC + 10;
            break;            
        }
        case 1209: //DIVI
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            char val[2] = {Code[reg->PC + 7], '\0'};
            int val0 = atoi(val);
            int a = func_5(reg_i, reg);
            func_4(reg_i, a / val0, reg);
            reg->PC = reg->PC + 8;
            break;
        }
        case 1210: //DIVR
        {
            char reg_sa[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            char reg_sb[4] = {Code[reg->PC + 7], Code[reg->PC + 8], Code[reg->PC + 9], '\0'};
            int reg_ia = atoi(reg_sa);
            int reg_ib = atoi(reg_sb);
            int reg_a = func_5(reg_ia, reg);
            int reg_b = func_5(reg_ib, reg);
            func_4(reg_ia, reg_a / reg_b, reg);
            reg->PC = reg->PC + 10;
            break;             
        }
        case 1211: //MULI
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            char val[2] = {Code[reg->PC + 7], '\0'};
            int val0 = atoi(val);
            int a = func_5(reg_i, reg);
            func_4(reg_i, a * val0, reg);
            reg->PC = reg->PC + 8;
            break;
        }
        case 1212: //MULR
        {
            char reg_sa[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            char reg_sb[4] = {Code[reg->PC + 7], Code[reg->PC + 8], Code[reg->PC + 9], '\0'};
            int reg_ia = atoi(reg_sa);
            int reg_ib = atoi(reg_sb);
            int reg_a = func_5(reg_ia, reg);
            int reg_b = func_5(reg_ib, reg);
            func_4(reg_ia, reg_a * reg_b, reg);
            reg->PC = reg->PC + 10;
            break;           
        }
        case 1213: //POPA
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            int val = (*Stack)[reg->SP];
            func_4(reg_i, val, reg);
            reg->SP = reg->SP + 1;
            reg->PC = reg->PC + 7;
            break;
        }
        case 1214: //PUSH
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            reg->SP = reg->SP - 1;
            int val = func_5(reg_i, reg);
            (*Stack)[reg->SP] = val;
            reg->PC = reg->PC + 7;
            break;
        }
        case 1215: //LOAD
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            char val[2] = {Code[reg->PC + 7], '\0'};
            int val0 = atoi(val);
            uint8_t a = (*memory)[reg->MP + val0];
            func_4(reg_i, a, reg);
            reg->PC += 8;
            break;
        }
        case 1216: // STOR
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            int a = func_5(reg_i, reg);
            (*memory)[reg->MP] = a;
            reg->MP += 1;
            reg->PC = reg->PC + 7;
            break;
        }
        case 1217: //CALL
        {
            char len[2] = {Code[reg->PC + 4], '\0'};
            char fun_name[len[0]];
            for(int j=0;j<len[0];j++)
            {
                fun_name[j] = Code[reg->PC+5+j];
            }

            void (*fun_name_ptr)() = (void (*)())fun_name;
            fun_name_ptr();
            reg->PC = reg->PC + 5 + len[0];
            break;
        }
        case 1218: //INCR
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            int a = func_5(reg_i, reg);
            func_4(reg_i, a+1, reg);
            reg->PC = reg->PC + 7;
            break;
        }   
        case 1219: //DECR
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            int a = func_5(reg_i, reg);
            func_4(reg_i, a-1, reg);
            reg->PC = reg->PC + 7;
            break;
        }
        case 1220: //LD_D
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            char val[2] = {Code[reg->PC + 7], '\0'};
            int val0 = atoi(val);
            uint8_t a = (*memory)[reg->MP + val0];
            (*memory)[reg->MP + val0] = 0;
            func_4(reg_i, a, reg);

            reg->PC += 8;
            break;

        }
        case 1221: //SHRI
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            char val[2] = {Code[reg->PC + 7], '\0'};
            int val0 = atoi(val);
            int a = func_5(reg_i, reg);
            func_4(reg_i, a >> val0, reg);
            reg->PC = reg->PC + 8;
            break;
        }
        case 1222: //SHRR
        {
            char reg_sa[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            char reg_sb[4] = {Code[reg->PC + 7], Code[reg->PC + 8], Code[reg->PC + 9], '\0'};
            int reg_ia = atoi(reg_sa);
            int reg_ib = atoi(reg_sb);
            int rega = func_5(reg_ia, reg);
            int regb = func_5(reg_ib, reg);
            func_4(reg_ia, rega >> regb, reg);
            reg->PC = reg->PC + 10;
            break;    
        }
        case 1223: //SHLI
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            char val[2] = {Code[reg->PC + 7], '\0'};
            int val0 = atoi(val);
            int a = func_5(reg_i, reg);
            func_4(reg_i, a << val0, reg);
            reg->PC = reg->PC + 8;
            break;
        }
        case 1224: //SHLR
        {
            char reg_sa[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            char reg_sb[4] = {Code[reg->PC + 7], Code[reg->PC + 8], Code[reg->PC + 9], '\0'};
            int reg_ia = atoi(reg_sa);
            int reg_ib = atoi(reg_sb);
            int rega = func_5(reg_ia, reg);
            int regb = func_5(reg_ib, reg);
            func_4(reg_ia, rega << regb, reg);
            reg->PC = reg->PC + 10;
            break;    
        }
        case 1225: //PRIM
        {
            char len[2] = {Code[reg->PC + 4], '\0'};
            char message[len[0]];
            for(int j=0;j<len[0];j++)
            {
                message[j] = Code[reg->PC+5+j];
            }
            printf("%s\n", message);
            reg->PC = reg->PC + 5 + len[0];
            break;
        }
        case 1226: //PRIR
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            int a = func_5(reg_i, reg);
            printf("%d\n", a);
            reg->PC = reg->PC + 7;
            break;
        }
        case 1227: //COPS
        {
            int val0;
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            char val[2] = {Code[reg->PC + 7], '\0'};
            if(val[0] == 0x24)
            {
                val0 = 10;
            }
            else {
                val0 = atoi(val);
            }            
            uint8_t a = (*Stack)[reg->SP + val0];
            func_4(reg_i, a, reg);
            reg->PC += 8;
            break;
        }
        case 1228: //JZD
        {
            uint8_t val = Code[reg->PC + 4];
            if(reg->ZF == 1)
            {
                reg->PC = reg->PC + val;
            }
            else{
                reg->PC = reg->PC + 5;
            }
            break;
        }
        case 1229: //JNZD
        {
            uint8_t val = Code[reg->PC + 4];
            if(reg->ZF == 0)
            {
                reg->PC = reg->PC + val;
            }
            else
            {
                reg->PC = reg->PC + 5;
            }
            break;
        }
        case 1230: //JMPD
        {
            uint8_t val = Code[reg->PC + 4];
            reg->PC = reg->PC + val;
            break;
        }
        case 1231: //SCAN
        {
            char val[2] = {Code[reg->PC + 4], '\0'};
            char reg_s[4] = {Code[reg->PC + 5], Code[reg->PC + 6], Code[reg->PC + 7], '\0'};
            int reg_i = atoi(reg_s);

            switch(val[0])
            {
                case 105:
                {
                    int a;
                    scanf("%d", &a); 
                    func_4(reg_i, a, reg);
                    reg->PC = reg->PC + 8;
                    break;
                }
                case 99:
                {
                    char c;
                    scanf("%c", &c);
                    (*memory)[reg->MP++] = c;
                    reg->PC = reg->PC + 5;
                    break;
                }
                case 115:
                {
                    char flag[100];
                    fgets(flag, 100, stdin);
                    char cont[100] = {0};
                    char decont[100];
                    int i =8;
                    while(flag[i] != '}')
                    {
                        cont[i-8] = flag[i];
                        i++;
                    }
                    
                    func_2(cont, decont);
                    char input[] = "bi0sctf{";
                    strcat(input, decont);
                    strcat(input, "}");
                    int inp_len = strlen(input);

                    for(int j=0;j<inp_len;j++)
                    {
                        (*memory)[reg->MP++] = input[j];
                    }
                    reg->S0 = inp_len;
                    reg->PC = reg->PC + 5;
                    break;
                }
                default:
                {
                    printf("Invalid choice of scan");
                    exit(0);
                }
            }
            break;
        }
        case 1232: //CMPI
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            char val[2] = {Code[reg->PC + 7], '\0'};
            int val0 = atoi(val);
            int a = func_5(reg_i, reg);
            if(val0 == a)
            {
                reg->ZF = 1;
            }
            else{
                reg->ZF = 0;
            }
            reg->PC = reg->PC + 8;
            break;
        }
        case 1233: //CMPR
        {
            char reg_sa[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            char reg_sb[4] = {Code[reg->PC + 7], Code[reg->PC + 8], Code[reg->PC + 9], '\0'};
            int reg_ia = atoi(reg_sa);
            int reg_ib = atoi(reg_sb);
            int rega = func_5(reg_ia, reg);
            int regb = func_5(reg_ib, reg);
            if(rega == regb)
            {
                reg->ZF = 1;
            }
            else{
                reg->ZF = 0;
            }
            reg->PC = reg->PC + 10;
            break;
        }
        case 1234: //EXIT
        {
            reg->EF = 1;
            break;
        }
        case 1235: //ANDI
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            char val[2] = {Code[reg->PC + 7], '\0'};
            int val0 = atoi(val);
            int a = func_5(reg_i, reg);
            func_4(reg_i, a & val0, reg);
            reg->PC = reg->PC + 8;
            break;
        }
        case 1236: //ANDR
        {
            char reg_sa[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            char reg_sb[4] = {Code[reg->PC + 7], Code[reg->PC + 8], Code[reg->PC + 9], '\0'};
            int reg_ia = atoi(reg_sa);
            int reg_ib = atoi(reg_sb);
            int reg_a = func_5(reg_ia, reg);
            int reg_b = func_5(reg_ib, reg);
            func_4(reg_ia, reg_a & reg_b, reg);
            reg->PC = reg->PC + 10;
            break;            
        }
        case 1237: //  ORRI
        {
            char reg_s[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            int reg_i = atoi(reg_s);
            char val[2] = {Code[reg->PC + 7], '\0'};
            int val0 = atoi(val);
            int a = func_5(reg_i, reg);
            func_4(reg_i, a | val0, reg);
            reg->PC = reg->PC + 8;
            break;
        }
        case 1238: //ORRR
        {
            char reg_sa[4] = {Code[reg->PC + 4], Code[reg->PC + 5], Code[reg->PC + 6], '\0'};
            char reg_sb[4] = {Code[reg->PC + 7], Code[reg->PC + 8], Code[reg->PC + 9], '\0'};
            int reg_ia = atoi(reg_sa);
            int reg_ib = atoi(reg_sb);
            int reg_a = func_5(reg_ia, reg);
            int reg_b = func_5(reg_ib, reg);
            func_4(reg_ia, reg_a | reg_b, reg);
            reg->PC = reg->PC + 10;
            break;            
        }
        case 1239: //JZU
        {
            uint8_t val = Code[reg->PC + 4];
            if(reg->ZF == 1)
            {
                reg->PC = reg->PC - val;
            }
            else{
                reg->PC = reg->PC + 5;
            }
            break;
        }
        case 1240: //JNZU
        {
            uint8_t val = Code[reg->PC + 4];
            if(reg->ZF == 0)
            {
                reg->PC = reg->PC - val;
            }
            else
            {
                reg->PC = reg->PC + 5;
            }
            break;
        }
        case 1241: //JMPU
        {
            uint8_t val = Code[reg->PC + 4];
            reg->PC = reg->PC - val;
            break;
        }
        case 1242: //JNZ
        {
            uint8_t val = Code[reg->PC + 4];    
            if(reg->ZF == 0)
            {
                reg->PC = val;
            }
            else
            {
                reg->PC = reg->PC + 5;
            }
            break;
        }
        case 1243: //JZ
        {
            uint8_t val = Code[reg->PC + 4];
            if(reg->ZF == 1)
            {
                reg->PC = val;
            }
            else{
                reg->PC = reg->PC + 5;
            }
            break;
        }
        default:
        {
            printf("Invalid choice of instruction");
            exit(0);
        }

    }
}


void func_7(int elist[41][3], int *res_bits[12])
{
    char encr_bytes[] = {68, 101, 99, 114, 121, 112, 116, 32, 109, 101, 32, 45, 45, 32, 226, 197, 125, 195, 194, 124, 125, 227, 194, 169, 125, 194, 195, 193, 180, 125, 196, 174, 125, 169, 197, 196, 174, 125, 187, 168, 195, 190, 169, 196, 194, 195, 125, 187, 193, 188, 170, 184, 185, 129, 125, 196, 169, 125, 196, 174, 125, 195, 194, 195, 184, 181, 196, 174, 169, 184, 195, 169, 131, 125, 222, 194, 168, 193, 185, 125, 180, 194, 168, 125, 173, 193, 184, 188, 174, 184, 125, 174, 194, 193, 171, 184, 125, 169, 197, 196, 174, 114, 167, 167, 135, 135, 206, 169, 188, 169, 196, 190, 125, 195, 194, 196, 174, 184, 167, 167, 220, 186, 184, 195, 169, 129, 125, 202, 184, 125, 197, 188, 173, 173, 184, 195, 184, 185, 125, 169, 194, 125, 175, 184, 190, 194, 175, 185, 125, 188, 125, 190, 194, 195, 171, 184, 175, 174, 188, 169, 196, 194, 195, 125, 191, 184, 169, 170, 184, 184, 195, 125, 224, 188, 175, 169, 196, 195, 125, 188, 195, 185, 125, 197, 196, 174, 125, 174, 168, 191, 194, 175, 185, 196, 195, 188, 169, 184, 174, 131, 125, 219, 194, 175, 125, 180, 194, 168, 175, 125, 175, 184, 187, 184, 175, 184, 195, 190, 184, 129, 125, 197, 184, 175, 184, 125, 196, 174, 125, 169, 197, 184, 125, 169, 175, 188, 195, 174, 190, 175, 196, 173, 169, 125, 194, 187, 125, 194, 168, 175, 125, 190, 194, 195, 171, 184, 175, 174, 188, 169, 196, 194, 195, 131, 167, 167, 206, 168, 191, 194, 175, 185, 196, 195, 188, 169, 184, 125, 108, 119, 125, 228, 174, 125, 196, 169, 125, 173, 194, 174, 174, 196, 191, 193, 184, 125, 187, 194, 175, 125, 188, 195, 125, 194, 175, 185, 196, 195, 188, 175, 180, 125, 173, 184, 175, 174, 194, 195, 125, 169, 194, 125, 194, 173, 184, 195, 125, 169, 197, 184, 125, 171, 188, 168, 193, 169, 114, 167, 224, 188, 175, 169, 196, 195, 119, 125, 227, 194, 129, 125, 185, 184, 187, 196, 195, 196, 169, 184, 193, 180, 125, 195, 194, 169, 131, 125, 201, 197, 184, 125, 171, 188, 168, 193, 169, 125, 195, 184, 184, 185, 174, 125, 169, 194, 125, 191, 184, 125, 174, 193, 188, 174, 197, 184, 185, 125, 108, 111, 125, 169, 196, 192, 184, 174, 125, 196, 195, 125, 194, 175, 185, 184, 175, 125, 169, 194, 125, 185, 196, 171, 196, 185, 184, 125, 169, 197, 194, 174, 184, 125, 108, 111, 125, 173, 194, 196, 195, 169, 174, 125, 184, 187, 187, 196, 190, 196, 184, 195, 169, 193, 180, 129, 125, 188, 195, 185, 125, 169, 197, 196, 174, 125, 195, 184, 184, 185, 174, 125, 169, 194, 125, 191, 184, 125, 185, 194, 195, 184, 125, 192, 168, 193, 169, 196, 173, 193, 184, 125, 169, 196, 192, 184, 174, 131, 131, 131, 167, 206, 168, 191, 194, 175, 185, 196, 195, 188, 169, 184, 125, 111, 119, 125, 229, 194, 170, 184, 171, 184, 175, 129, 125, 228, 125, 197, 188, 171, 184, 125, 197, 184, 188, 175, 185, 125, 169, 197, 188, 169, 125, 180, 194, 168, 125, 188, 175, 184, 125, 175, 184, 172, 168, 196, 175, 184, 185, 125, 169, 194, 125, 168, 174, 184, 125, 188, 195, 125, 122, 184, 187, 187, 196, 190, 196, 184, 195, 169, 125, 192, 184, 169, 197, 194, 185, 122, 125, 169, 194, 125, 185, 196, 171, 196, 185, 184, 125, 169, 197, 184, 125, 173, 194, 196, 195, 169, 174, 167, 224, 188, 175, 169, 196, 195, 119, 125, 212, 194, 168, 125, 188, 175, 184, 125, 175, 196, 186, 197, 169, 129, 125, 169, 197, 184, 125, 198, 184, 180, 125, 169, 194, 125, 169, 197, 196, 174, 125, 174, 169, 175, 188, 195, 186, 184, 125, 192, 184, 169, 197, 194, 185, 125, 196, 174, 125, 122, 223, 175, 168, 169, 184, 122, 167, 167, 220, 193, 193, 125, 170, 184, 125, 197, 188, 171, 184, 125, 196, 174, 125, 169, 197, 196, 174, 131, 125, 220, 193, 193, 125, 169, 197, 184, 125, 191, 184, 174, 169, 125, 196, 195, 125, 187, 196, 195, 185, 196, 195, 186, 125, 169, 197, 184, 125, 190, 194, 175, 175, 184, 190, 169, 125, 175, 184, 173, 193, 188, 190, 184, 192, 184, 195, 169, 125, 187, 194, 175, 125, 169, 197, 184, 125, 186, 196, 171, 184, 195, 125, 187, 168, 195, 190, 169, 196, 194, 195, 131, 167, 167, 135, 135, 206, 169, 188, 169, 196, 190, 125, 195, 194, 196, 174, 184, 167, 0};    
    // printf("Decrypt me -- Oh no! Not only is this function flawed, it is nonexistent. Could you please solve this?\n\n**Static noise\n\nAgent, We happened to record a conversation between Martin and his subordinates. For your reference, here is the transcript of our conversation.\n\nSubordinate 1: Is it possible for an ordinary person to open the vault?\nMartin: No, definitely not. The vault needs to be slashed 12 times in order to divide those 12 points efficiently, and this needs to be done multiple times...\nSubordinate 2: However, I have heard that you are not required to use an 'efficient method' to divide the points, but rather some other strange method?\nMartin: You are right, the key to this strange method is 'Quantum'... Have you heard of Optimization?\n\nAll we have is this. All the best in finding the correct replacement for the given function.\n\n**Static noise\n");
}
 
int func_8(double xyz1[3], double xyz2[3]) {
    int consta = 10;
    double sum_of_squares = 0.0;
    for (int i = 0; i < 3; i++) {
        double difference = xyz1[i] - xyz2[i];
        sum_of_squares += difference * difference;
    }
    sum_of_squares = consta * sqrt(sum_of_squares);
    int rounded_distance = round(sum_of_squares);
    return rounded_distance;
}

void func_9(const uint8_t *encrypted_shellcode, size_t shellcode_len, uint8_t *decrypted_shellcode, int subtract_key, int xor_key) {
    for (size_t i = 0; i < shellcode_len; i++) {
        decrypted_shellcode[i] = encrypted_shellcode[i] + subtract_key;
        decrypted_shellcode[i] %= 256;  
        decrypted_shellcode[i] ^= xor_key;
    }
}

void func_10(const uint8_t *encrypted_shellcode, size_t shellcode_len, int subtract_key, int xor_key, uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta) {
    static jmp_buf shellcode_env;

    uint8_t decrypted_shellcode[shellcode_len];
    func_9(encrypted_shellcode, shellcode_len, decrypted_shellcode, subtract_key, xor_key);

    void (*decrypted_shellcode_ptr)(uint8_t, uint8_t, uint8_t *, uint8_t *) = (void (*)(uint8_t, uint8_t, uint8_t *, uint8_t *))decrypted_shellcode;

    if (setjmp(shellcode_env) == 0) {
        decrypted_shellcode_ptr(alpha, beta, new_alpha, new_beta);
    } else {
        printf("Well, I already said it's broken.\n");
    }
}

void Blaze(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 130, 105, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 130, 110, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 105, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118, 125, 0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}

void Horizon(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 130, 105, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 110, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 130, 110, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118, 0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}

void Nova(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 130, 107, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 130, 111, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 105, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118, 0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}

void Quantum(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 130, 107, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 130, 111, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 107, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118,0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}

void Echo(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 130, 105, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 130, 110, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 107, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118, 0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}

void Radiant(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 130, 111, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 105, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118, 0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}

void Zenith(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 130, 110, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 110, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118, 0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}

void Cipher(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 130, 107, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 105, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 130, 111, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118, 0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}

void Nimbus(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 130, 107, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 105, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118, 0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}

void Pulse(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 130, 105, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 110, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118, 0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}

void Serene(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 130, 107, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 130, 110, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 105, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118, 0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}

void Ember(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 130, 105, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 107, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118, 0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}

void Aurora(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 130, 111, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 105, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118, 0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}

void Lumina(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 130, 111, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 130, 107, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 110, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118, 0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}

void Cascade(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 130, 110, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 130, 110, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 105, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118, 0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}

void Kinetic(uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
    const uint8_t encrypted_shellcode[] = {226, 205, 216, 227, 204, 220, 206, 224, 125, 111, 131, 109, 118, 160, 167, 196, 195, 190, 193, 168, 185, 184, 125, 127, 172, 184, 193, 196, 191, 108, 131, 196, 195, 190, 127, 118, 160, 167, 186, 188, 169, 184, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 125, 182, 125, 125, 176, 160, 167, 186, 188, 169, 184, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 185, 196, 174, 184, 195, 169, 188, 195, 186, 193, 184, 175, 210, 185, 186, 125, 172, 109, 118, 125, 176, 160, 167, 186, 188, 169, 184, 125, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 173, 188, 175, 188, 192, 109, 129, 173, 188, 175, 188, 192, 108, 132, 125, 172, 109, 125, 182, 125, 175, 184, 174, 184, 169, 125, 172, 109, 118, 125, 174, 169, 188, 169, 184, 210, 173, 175, 184, 173, 188, 175, 188, 169, 196, 194, 195, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 109, 118, 125, 176, 160, 167, 172, 175, 184, 186, 125, 172, 111, 214, 108, 208, 118, 160, 167, 190, 175, 184, 186, 125, 190, 111, 214, 108, 208, 118, 160, 167, 196, 195, 196, 169, 196, 188, 193, 196, 183, 184, 133, 188, 193, 173, 197, 188, 129, 191, 184, 169, 188, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 180, 133, 173, 196, 130, 105, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 183, 133, 173, 196, 130, 107, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 175, 181, 133, 173, 196, 130, 107, 132, 125, 172, 111, 214, 109, 208, 118, 160, 167, 192, 184, 188, 174, 168, 175, 184, 125, 172, 111, 214, 109, 208, 125, 128, 115, 125, 190, 111, 214, 109, 208, 118, 0};
    size_t shellcode_len = strlen((const char *)encrypted_shellcode);

    func_10(encrypted_shellcode, shellcode_len, subtract_key, xor_key, alpha, beta, new_alpha, new_beta);
}


void func_11(int choi, uint8_t alpha, uint8_t beta, double complex *new_alpha, double complex *new_beta, int subtract_key, int xor_key) {
   switch (choi) {
       case 0:
           Blaze(alpha, beta, new_alpha, new_beta, subtract_key, xor_key);
           break;
       case 1:
           Horizon(alpha, beta, new_alpha, new_beta, subtract_key, xor_key);
           break;
       case 2:
           Nova(alpha, beta, new_alpha, new_beta, subtract_key, xor_key);
           break;
       case 3:
           Quantum(alpha, beta, new_alpha, new_beta, subtract_key, xor_key);
           break;
       case 4:
           Echo(alpha, beta, new_alpha, new_beta, subtract_key, xor_key);
           break;
       case 5:
           Radiant(alpha, beta, new_alpha, new_beta, subtract_key, xor_key);
           break;
       case 6:
           Zenith(alpha, beta, new_alpha, new_beta, subtract_key, xor_key);
           break;
       case 7:
           Cipher(alpha, beta, new_alpha, new_beta, subtract_key, xor_key);
           break;
       case 8:
           Nimbus(alpha, beta, new_alpha, new_beta, subtract_key, xor_key);
           break;
       case 9:
           Pulse(alpha, beta, new_alpha, new_beta, subtract_key, xor_key);
           break;
       case 10:
           Serene(alpha, beta, new_alpha, new_beta, subtract_key, xor_key);
           break;
       case 11:
           Ember(alpha, beta, new_alpha, new_beta, subtract_key, xor_key);
           break;
       case 12:
           Aurora(alpha, beta, new_alpha, new_beta, subtract_key, xor_key);
           break;
       case 13:
           Lumina(alpha, beta, new_alpha, new_beta, subtract_key, xor_key);
           break;
       case 14:
           Cascade(alpha, beta, new_alpha, new_beta, subtract_key, xor_key);
           break;
       case 15:
           Kinetic(alpha, beta, new_alpha, new_beta, subtract_key, xor_key); 
           break;
       default:
           printf("Invalid choice: %d\n", choi);
   }
}


void func_12(double xyz[3], double complex *alpha, double complex *beta) {
    double r = sqrt(xyz[0] * xyz[0] + xyz[1] * xyz[1] + xyz[2] * xyz[2]);
    double theta = acos(xyz[2] / r);
    double phi = atan2(xyz[1], xyz[0]);
    *alpha = cos(theta / 2);
    *beta = cexp(I * phi) * sin(theta / 2);
}

void func_13(double complex alpha, double complex beta, double xyz[3]) {
    double r = cabs(alpha) * cabs(alpha) + cabs(beta) * cabs(beta);
    double theta = 2 * acos(cabs(alpha) / sqrt(r));
    double phi = carg(beta / alpha);
    xyz[0] = r * sin(theta) * cos(phi);
    xyz[1] = r * sin(theta) * sin(phi);
    xyz[2] = r * cos(theta);  
}


int main(int argc, char **argv) {


    if(argc != 2)
    {
        printf("Provide the code dump");
        exit(0);
    }
    char* fileName = argv[1]; 

    struct Registers reg;
    uint8_t *stack = (uint8_t *)malloc(stackSize * sizeof(uint8_t));
    uint8_t *memory = (uint8_t *)malloc(mem_size * sizeof(uint8_t));
    char* Code = func_3(fileName);

    reg.SP = stackSize; 
    reg.BP = stackSize;
    reg.EF = 0;
    reg.ZF = 0;
    reg.MP = 0;
    reg.PC = 0;

    while(reg.EF != 1)
    {
        char instr[5] = {Code[reg.PC], Code[reg.PC + 1], Code[reg.PC + 2], Code[reg.PC + 3], '\0'};
        int inst_i = atoi(instr);
        func_6(inst_i, &reg, Code, &stack, &memory);
    }

    int inp_len = reg.S0;
    int classified[(inp_len-1)*6][8];
    
    int c = 0;
    for(int i =0;i<(inp_len-1)*6;i++)
    {
        for(int j =0;j<8;j++)
        {
            classified[i][j] = *(memory + c);
            c += 1;
        }
    }


    uint8_t aes_key[16];

    for(int i =0;i<16;i++)
    {
        aes_key[i] = classified[i][7] * 1 + classified[i][6] * 2 + classified[i][5] * 4 + classified[i][4] * 8 + classified[i][3] * 16 + classified[i][2] * 32 + classified[i][1] * 64 + classified[i][0] * 128 ;
    }

    int seed_gen = 0;
    for(int i =0;i<8;i+=2)
    {
        seed_gen+=classified[i][3]*1 +classified[i][2]*2 + classified[i][1]*4 + classified[i][0]*8;
        seed_gen+=classified[i+1][7]*1 +classified[i+1][6]*2 + classified[i+1][5]*4 + classified[i+1][4]*8;
    }

    char g[1];
    printf("\nEnter the trigger: ");
    scanf("%c", &g[0]);

    if(g[0]=='r')
    {
        srand(seed_gen^g[0]^s);
    }
    else{
        printf("Wrong trigger\n");
        exit(0);
    }

             
    int conditions[84] = {1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0};
    int p=0;
    for(int j =0;j<(inp_len-1)*6;j+=6)
    { 
        int rands[3];
        rands[0] = rand()%4;
        for(int i=1; i<3; i++)
        {
            int r = rand()%4;
            while(r == rands[i-1] || r == rands[0])
            {
                r = rand()%4;
            }
            rands[i] = r;
        }

        for(int k=0;k<3;k++)
        {
            int g = (classified[j+rands[k]][0] == classified[j+rands[k]][7]);
            if(g != conditions[p])
            {
                printf("Wrong Input\n");
                exit(0);
            }
            p+=1;
        }
    }


    int subtract_key = classified[0][7]*1 + classified[0][6]*2 + classified[0][5]*4 + classified[0][4]*8 + classified[0][3]*16 + classified[0][2]*32 + classified[0][1]*64 + classified[0][0]*128;
    int xor_key = classified[4][7]*1 + classified[4][6]*2 + classified[4][5]*4 + classified[4][4]*8 + classified[4][3]*16 + classified[4][2]*32 + classified[4][1]*64 + classified[4][0]*128;
    double coordinates[(inp_len-1)*12][3];
    
    for(int i=0;i<(inp_len-1)*6;i+=6)
    {
        double complex alpha = 1 + 0*I;
        double complex beta = 0 + 0*I;
        double complex alts[12][2];

        for(int j=0;j<6;j++)
        {
            int com[2] = {0,0};
            com[0] = classified[i+j][0]*8 + classified[i+j][1]*4 + classified[i+j][2]*2 + classified[i+j][3]*1;
            com[1] = classified[i+j][4]*1 + classified[i+j][5]*2 + classified[i+j][6]*4 + classified[i+j][7]*8;
            func_11(com[0], alpha, beta, &alts[j*2][0], &alts[j*2][1], subtract_key, xor_key); 
            func_11(com[1], alts[j*2][0], alts[j*2][1], &alts[j*2+1][0], &alts[j*2+1][1], subtract_key, xor_key); 
            alpha = alts[j*2+1][0];
            beta = alts[j*2+1][1];
        }

        for(int k=0;k<12;k++)
        {
            func_13(alts[k][0], alts[k][1], coordinates[i*2+k]);
        }
    }

    int pairs[41][2] = {{0,2}, {0,4}, {0,6}, {0,8}, {0,10}, {1,0}, {1,3}, {1,5}, {1,7}, {1,9}, {1,11}, {2,1}, {2,4}, {2,6}, {2,8}, {2,10}, {3,2}, {3,5}, {3,7}, {3,9}, {3,11}, {4,3}, {4,6}, {4,8}, {4,10}, {5,4}, {5,7}, {5,9}, {5,11}, {6,5}, {6,8}, {6,10}, {7,6}, {7,9}, {7,11}, {8,7}, {8,10}, {9,8}, {9,11}, {10,9}, {11,10}};

    int fin_val[(inp_len-1)*2];

    for(int i = 0; i < (inp_len-1)*12; i += 12)
    {
        int res_bits[12];
        int elist[41][3];
        for(int j=0;j<inp_len;j++)
        {
            elist[j][0] = pairs[j][0];
            elist[j][1] = pairs[j][1];
            elist[j][2] = func_8(coordinates[pairs[j][0]], coordinates[pairs[j][1]]);
        }
        func_7(elist, &res_bits); 
        fin_val[i/6] =  64 + res_bits[0]*32 + res_bits[1]*16 + res_bits[2]*8 + res_bits[3]*4 + res_bits[4]*2 + res_bits[5]*1;
        fin_val[i/6+1] =  64 + res_bits[6]*32 + res_bits[7]*16 + res_bits[8]*8 + res_bits[9]*4 + res_bits[10]*2 + res_bits[11]*1;
    }

    uint8_t out[32];
    uint8_t *w; 

	w = aes_init(sizeof(aes_key));
    aes_key_expansion(aes_key, w);

    aes_cipher(fin_val, out , w );

    for(int i = 0; i<32;i++)
    {
        if(out[i] != unk_0[i])
        {
            printf("Nope, that's a wrong path");
            exit(0);
        }
    }

    printf("That's correct!");

    return 0;
}
