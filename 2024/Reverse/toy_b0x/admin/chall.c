#include <stdio.h>  
#include <stdlib.h> 
#include <string.h>

enum errorCode
{
    SUCCESS = 0,
    ERROR_AES_UNKNOWN_KEYSIZE,
    ERROR_MEMORY_ALLOCATION_FAILED,
};


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
        : "=r" (is_debugged)                                                     \
    );

#define ARRAY_SIZE 257  
int is_debugged = 0;


unsigned int sbox[256];

void __attribute__((constructor)) init()
{
    CHECK_DEBUGGER;
}

void generateArray(int *arr, int start, int end, int index) {
    if (start <= end) {
        arr[index] = start;
        generateArray(arr, start + 1, end, index + 1);
    }
}


int* generateNumbers() {
    int *arr = (int*)malloc(ARRAY_SIZE * sizeof(int));
    if (arr == NULL) {
        fprintf(stderr, "Memory allocation failed.\n");
        exit(1);
    }
    generateArray(arr, 0, 255, 0);
    return arr;
}

unsigned char getSBoxValue(unsigned char num);
void init_fake_sbox(unsigned int *fake_sbox)
{
    fake_sbox[0] = 328;
    fake_sbox[1] = 446;
    fake_sbox[2] = 451;
    fake_sbox[3] = 191;
    fake_sbox[4] = 148;
    fake_sbox[5] = 482;
    fake_sbox[6] = 221;
    fake_sbox[7] = 477;
    fake_sbox[8] = 1;
    fake_sbox[9] = 237;
    fake_sbox[10] = 325;
    fake_sbox[11] = 43;
    fake_sbox[12] = 207;
    fake_sbox[13] = 446;
    fake_sbox[14] = 336;
    fake_sbox[15] = 471;
    fake_sbox[16] = 484;
    fake_sbox[17] = 163;
    fake_sbox[18] = 294;
    fake_sbox[19] = 152;
    fake_sbox[20] = 314;
    fake_sbox[21] = 152;
    fake_sbox[22] = 10;
    fake_sbox[23] = 49;
    fake_sbox[24] = 42;
    fake_sbox[25] = 337;
    fake_sbox[26] = 240;
    fake_sbox[27] = 295;
    fake_sbox[28] = 140;
    fake_sbox[29] = 205;
    fake_sbox[30] = 313;
    fake_sbox[31] = 433;
    fake_sbox[32] = 202;
    fake_sbox[33] = 219;
    fake_sbox[34] = 324;
    fake_sbox[35] = 458;
    fake_sbox[36] = 130;
    fake_sbox[37] = 161;
    fake_sbox[38] = 240;
    fake_sbox[39] = 174;
    fake_sbox[40] = 406;
    fake_sbox[41] = 136;
    fake_sbox[42] = 82;
    fake_sbox[43] = 106;
    fake_sbox[44] = 77;
    fake_sbox[45] = 497;
    fake_sbox[46] = 314;
    fake_sbox[47] = 8;
    fake_sbox[48] = 432;
    fake_sbox[49] = 334;
    fake_sbox[50] = 299;
    fake_sbox[51] = 397;
    fake_sbox[52] = 305;
    fake_sbox[53] = 190;
    fake_sbox[54] = 420;
    fake_sbox[55] = 73;
    fake_sbox[56] = 216;
    fake_sbox[57] = 230;
    fake_sbox[58] = 289;
    fake_sbox[59] = 15;
    fake_sbox[60] = 446;
    fake_sbox[61] = 418;
    fake_sbox[62] = 276;
    fake_sbox[63] = 483;
    fake_sbox[64] = 19;
    fake_sbox[65] = 375;
    fake_sbox[66] = 416;
    fake_sbox[67] = 312;
    fake_sbox[68] = 89;
    fake_sbox[69] = 280;
    fake_sbox[70] = 200;
    fake_sbox[71] = 159;
    fake_sbox[72] = 448;
    fake_sbox[73] = 412;
    fake_sbox[74] = 218;
    fake_sbox[75] = 147;
    fake_sbox[76] = 101;
    fake_sbox[77] = 12;
    fake_sbox[78] = 344;
    fake_sbox[79] = 291;
    fake_sbox[80] = 32;
    fake_sbox[81] = 496;
    fake_sbox[82] = 366;
    fake_sbox[83] = 10;
    fake_sbox[84] = 469;
    fake_sbox[85] = 444;
    fake_sbox[86] = 82;
    fake_sbox[87] = 49;
    fake_sbox[88] = 384;
    fake_sbox[89] = 7;
    fake_sbox[90] = 28;
    fake_sbox[91] = 188;
    fake_sbox[92] = 116;
    fake_sbox[93] = 296;
    fake_sbox[94] = 2;
    fake_sbox[95] = 225;
    fake_sbox[96] = 3;
    fake_sbox[97] = 234;
    fake_sbox[98] = 196;
    fake_sbox[99] = 4;
    fake_sbox[100] = 343;
    fake_sbox[101] = 405;
    fake_sbox[102] = 124;
    fake_sbox[103] = 407;
    fake_sbox[104] = 337;
    fake_sbox[105] = 405;
    fake_sbox[106] = 439;
    fake_sbox[107] = 413;
    fake_sbox[108] = 418;
    fake_sbox[109] = 496;
    fake_sbox[110] = 67;
    fake_sbox[111] = 199;
    fake_sbox[112] = 189;
    fake_sbox[113] = 144;
    fake_sbox[114] = 438;
    fake_sbox[115] = 290;
    fake_sbox[116] = 163;
    fake_sbox[117] = 74;
    fake_sbox[118] = 261;
    fake_sbox[119] = 32;
    fake_sbox[120] = 500;
    fake_sbox[121] = 273;
    fake_sbox[122] = 455;
    fake_sbox[123] = 428;
    fake_sbox[124] = 469;
    fake_sbox[125] = 421;
    fake_sbox[126] = 2;
    fake_sbox[127] = 340;
    fake_sbox[128] = 273;
    fake_sbox[129] = 268;
    fake_sbox[130] = 356;
    fake_sbox[131] = 159;
    fake_sbox[132] = 136;
    fake_sbox[133] = 268;
    fake_sbox[134] = 279;
    fake_sbox[135] = 225;
    fake_sbox[136] = 280;
    fake_sbox[137] = 392;
    fake_sbox[138] = 49;
    fake_sbox[139] = 315;
    fake_sbox[140] = 260;
    fake_sbox[141] = 165;
    fake_sbox[142] = 295;
    fake_sbox[143] = 465;
    fake_sbox[144] = 269;
    fake_sbox[145] = 137;
    fake_sbox[146] = 40;
    fake_sbox[147] = 132;
    fake_sbox[148] = 402;
    fake_sbox[149] = 100;
    fake_sbox[150] = 493;
    fake_sbox[151] = 194;
    fake_sbox[152] = 483;
    fake_sbox[153] = 181;
    fake_sbox[154] = 76;
    fake_sbox[155] = 379;
    fake_sbox[156] = 499;
    fake_sbox[157] = 390;
    fake_sbox[158] = 98;
    fake_sbox[159] = 56;
    fake_sbox[160] = 57;
    fake_sbox[161] = 298;
    fake_sbox[162] = 233;
    fake_sbox[163] = 422;
    fake_sbox[164] = 84;
    fake_sbox[165] = 109;
    fake_sbox[166] = 131;
    fake_sbox[167] = 341;
    fake_sbox[168] = 275;
    fake_sbox[169] = 334;
    fake_sbox[170] = 476;
    fake_sbox[171] = 185;
    fake_sbox[172] = 6;
    fake_sbox[173] = 375;
    fake_sbox[174] = 291;
    fake_sbox[175] = 44;
    fake_sbox[176] = 57;
    fake_sbox[177] = 104;
    fake_sbox[178] = 158;
    fake_sbox[179] = 73;
    fake_sbox[180] = 94;
    fake_sbox[181] = 155;
    fake_sbox[182] = 304;
    fake_sbox[183] = 81;
    fake_sbox[184] = 254;
    fake_sbox[185] = 487;
    fake_sbox[186] = 439;
    fake_sbox[187] = 272;
    fake_sbox[188] = 106;
    fake_sbox[189] = 85;
    fake_sbox[190] = 265;
    fake_sbox[191] = 364;
    fake_sbox[192] = 475;
    fake_sbox[193] = 99;
    fake_sbox[194] = 56;
    fake_sbox[195] = 431;
    fake_sbox[196] = 445;
    fake_sbox[197] = 125;
    fake_sbox[198] = 491;
    fake_sbox[199] = 136;
    fake_sbox[200] = 252;
    fake_sbox[201] = 342;
    fake_sbox[202] = 98;
    fake_sbox[203] = 167;
    fake_sbox[204] = 230;
    fake_sbox[205] = 239;
    fake_sbox[206] = 390;
    fake_sbox[207] = 350;
    fake_sbox[208] = 277;
    fake_sbox[209] = 370;
    fake_sbox[210] = 176;
    fake_sbox[211] = 433;
    fake_sbox[212] = 327;
    fake_sbox[213] = 249;
    fake_sbox[214] = 277;
    fake_sbox[215] = 207;
    fake_sbox[216] = 340;
    fake_sbox[217] = 67;
    fake_sbox[218] = 261;
    fake_sbox[219] = 352;
    fake_sbox[220] = 153;
    fake_sbox[221] = 472;
    fake_sbox[222] = 291;
    fake_sbox[223] = 155;
    fake_sbox[224] = 273;
    fake_sbox[225] = 420;
    fake_sbox[226] = 248;
    fake_sbox[227] = 57;
    fake_sbox[228] = 323;
    fake_sbox[229] = 281;
    fake_sbox[230] = 338;
    fake_sbox[231] = 150;
    fake_sbox[232] = 367;
    fake_sbox[233] = 148;
    fake_sbox[234] = 332;
    fake_sbox[235] = 91;
    fake_sbox[236] = 257;
    fake_sbox[237] = 73;
    fake_sbox[238] = 204;
    fake_sbox[239] = 162;
    fake_sbox[240] = 388;
    fake_sbox[241] = 233;
    fake_sbox[242] = 334;
    fake_sbox[243] = 388;
    fake_sbox[244] = 74;
    fake_sbox[245] = 224;
    fake_sbox[246] = 99;
    fake_sbox[247] = 84;
    fake_sbox[248] = 19;
    fake_sbox[249] = 421;
    fake_sbox[250] = 47;
    fake_sbox[251] = 279;
    fake_sbox[252] = 429;
    fake_sbox[253] = 181;
    fake_sbox[254] = 188;
    fake_sbox[255] = 37;
    
    return;
}

void rotate(unsigned char *word);

void actually_decrypt_string(char *a, char *flag)
{
    for (int i = 0; a[i]; i++)
    {
        a[i] = a[i] ^ (i + 15);
    }
}

void decrypt_string(char *a)
{
    char *flag = "69*x^0x8we82130d";
    actually_decrypt_string(a, flag);
}

unsigned char Rcon[] = {
     0x00, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40,
    0x80, 0x1B, 0x36, 0x6C, 0xD8, 0xAB, 0x4D, 0x9A,
    0x2F, 0x5E, 0xBC, 0x63, 0xC6, 0x97, 0x35, 0x6A,
    0xD4, 0xB3, 0x7D, 0xFA, 0xEF, 0xC5, 0x91, 0x39};

unsigned char getRconValue(unsigned char num);

void core(unsigned char *word, int iteration);


enum keySize
{
    SIZE_16 = 16,
    SIZE_24 = 24,
    SIZE_32 = 32
};

void expandKey(unsigned char *expandedKey, unsigned char *key, enum keySize, size_t expandedKeySize);
void subBytes(unsigned char *state);

void shiftRows(unsigned char *state);
void shiftRow(unsigned char *state, unsigned char nbr);

void addRoundKey(unsigned char *state, unsigned char *roundKey);

unsigned char galois_multiplication(unsigned char a, unsigned char b);
void mixColumns(unsigned char *state);
void mixColumn(unsigned char *column);

void aes_round(unsigned char *state, unsigned char *roundKey);

void createRoundKey(unsigned char *expandedKey, unsigned char *roundKey);
void aes_main(unsigned char *state, unsigned char *expandedKey, int nbrRounds);


char aes_encrypt(unsigned char *input, unsigned char *output, unsigned char *key, enum keySize size);


int main(int argc, char *argv[])
{
    

    int expandedKeySize = 176;
    unsigned char expandedKey[expandedKeySize];

    unsigned char key[1024];
    unsigned char plaintext[1024];

    scanf("%[^\n]16s", key);
    scanf("%1024s", plaintext);
    
    enum keySize size = SIZE_16;
    int *arr = generateNumbers();

    expandKey(expandedKey, key, size, expandedKeySize);
    
    char prefix[] = {91, 121, 98, 50, 122, 103, 53, 119, 55, 107, 124, 121, 105, 121, 105, 36, 15};
    memcpy(sbox, arr, 1024);
    
    if (is_debugged)
    {
        unsigned int *fake_sbox = malloc(256 * sizeof(int));
        init_fake_sbox(fake_sbox);
        memcpy(sbox, fake_sbox, 1024);
    }

    decrypt_string(prefix);
    int prefixLength = strlen(prefix);  
    int plaintextLength = strlen(plaintext);

    int numBlocks = (plaintextLength + prefixLength) / 16 + 1;

    int paddedLength = numBlocks * 16;

    unsigned char paddedPlaintext[paddedLength];
    memcpy(paddedPlaintext, prefix, prefixLength);
    memcpy(paddedPlaintext + prefixLength, plaintext, plaintextLength);

    int paddingBytes = paddedLength - prefixLength - plaintextLength;
    memset(paddedPlaintext + prefixLength + plaintextLength, paddingBytes, paddingBytes);

    for (int i = 0; i < numBlocks; i++)
    {
        unsigned char block[16];
        memcpy(block, paddedPlaintext + i * 16, 16);

        unsigned char blockCiphertext[16];
        aes_encrypt(block, blockCiphertext, key, SIZE_16);

        for (int j = 0; j < 16; j++)
        {
            printf("%2.2x", blockCiphertext[j]);
        }
    }
    printf("\n");
    return 0;

}

unsigned char getSBoxValue(unsigned char num)
{
    return sbox[num];
}


void rotate(unsigned char *word)
{
    unsigned char c;
    int i;

    c = word[0];
    for (i = 0; i < 3; i++)
        word[i] = word[i + 1];
    word[3] = c;
}

unsigned char getRconValue(unsigned char num)
{
    return Rcon[num];
}

void core(unsigned char *word, int iteration)
{
    int i;

    rotate(word);

    for (i = 0; i < 4; ++i)
    {
        word[i] = getSBoxValue(word[i]);
    }

    word[0] = word[0] ^ getRconValue(iteration);
}

void expandKey(unsigned char *expandedKey,
               unsigned char *key,
               enum keySize size,
               size_t expandedKeySize)
{
    int currentSize = 0;
    int rconIteration = 1;
    int i;
    unsigned char t[4] = {0}; 

    for (i = 0; i < size; i++)
        expandedKey[i] = key[i];
    currentSize += size;

    while (currentSize < expandedKeySize)
    {
        for (i = 0; i < 4; i++)
        {
            t[i] = expandedKey[(currentSize - 4) + i];
        }

 
        if (currentSize % size == 0)
        {
            core(t, rconIteration++);
        }

        if (size == SIZE_32 && ((currentSize % size) == 16))
        {
            for (i = 0; i < 4; i++)
                t[i] = getSBoxValue(t[i]);
        }

        for (i = 0; i < 4; i++)
        {
            expandedKey[currentSize] = expandedKey[currentSize - size] ^ t[i];
            currentSize++;
        }
    }
}

void subBytes(unsigned char *state)
{
    int i;
    for (i = 0; i < 16; i++)
        state[i] = getSBoxValue(state[i]);
}

void shiftRows(unsigned char *state)
{
    int i;
    for (i = 0; i < 4; i++)
        shiftRow(state + i * 4, i);
}

void shiftRow(unsigned char *state, unsigned char nbr)
{
    int i, j;
    unsigned char tmp;
    for (i = 0; i < nbr; i++)
    {
        tmp = state[0];
        for (j = 0; j < 3; j++)
            state[j] = state[j + 1];
        state[3] = tmp;
    }
}

void addRoundKey(unsigned char *state, unsigned char *roundKey)
{
    int i;
    for (i = 0; i < 16; i++)
        state[i] = state[i] ^ roundKey[i];
}

unsigned char galois_multiplication(unsigned char a, unsigned char b)
{
    unsigned char p = 0;
    unsigned char counter;
    unsigned char hi_bit_set;
    for (counter = 0; counter < 8; counter++)
    {
        if ((b & 1) == 1)
            p ^= a;
        hi_bit_set = (a & 0x80);
        a <<= 1;
        if (hi_bit_set == 0x80)
            a ^= 0x1b;
        b >>= 1;
    }
    return p;
}

void mixColumns(unsigned char *state)
{
    int i, j;
    unsigned char column[4];

    for (i = 0; i < 4; i++)
    {
        for (j = 0; j < 4; j++)
        {
            column[j] = state[(j * 4) + i];
        }

        mixColumn(column);

        for (j = 0; j < 4; j++)
        {
            state[(j * 4) + i] = column[j];
        }
    }
}

void mixColumn(unsigned char *column)
{
    unsigned char cpy[4];
    int i;
    for (i = 0; i < 4; i++)
    {
        cpy[i] = column[i];
    }
    column[0] = galois_multiplication(cpy[0], 2) ^
                galois_multiplication(cpy[3], 1) ^
                galois_multiplication(cpy[2], 1) ^
                galois_multiplication(cpy[1], 3);

    column[1] = galois_multiplication(cpy[1], 2) ^
                galois_multiplication(cpy[0], 1) ^
                galois_multiplication(cpy[3], 1) ^
                galois_multiplication(cpy[2], 3);

    column[2] = galois_multiplication(cpy[2], 2) ^
                galois_multiplication(cpy[1], 1) ^
                galois_multiplication(cpy[0], 1) ^
                galois_multiplication(cpy[3], 3);

    column[3] = galois_multiplication(cpy[3], 2) ^
                galois_multiplication(cpy[2], 1) ^
                galois_multiplication(cpy[1], 1) ^
                galois_multiplication(cpy[0], 3);
}

void aes_round(unsigned char *state, unsigned char *roundKey)
{
    subBytes(state);
    shiftRows(state);
    mixColumns(state);
    addRoundKey(state, roundKey);
}

void createRoundKey(unsigned char *expandedKey, unsigned char *roundKey)
{
    int i, j;
    for (i = 0; i < 4; i++)
    {
        for (j = 0; j < 4; j++)
            roundKey[(i + (j * 4))] = expandedKey[(i * 4) + j];
    }
}

void aes_main(unsigned char *state, unsigned char *expandedKey, int nbrRounds)
{
    int i = 0;

    unsigned char roundKey[16];

    createRoundKey(expandedKey, roundKey);
    addRoundKey(state, roundKey);

    for (i = 1; i < nbrRounds; i++)
    {
        createRoundKey(expandedKey + 16 * i, roundKey);
        aes_round(state, roundKey);
    }

    createRoundKey(expandedKey + 16 * nbrRounds, roundKey);
    subBytes(state);
    shiftRows(state);
    addRoundKey(state, roundKey);
}

char aes_encrypt(unsigned char *input,
                 unsigned char *output,
                 unsigned char *key,
                 enum keySize size)
{
    int expandedKeySize;

    int nbrRounds;

    unsigned char *expandedKey;

    unsigned char block[16];

    int i, j;

    switch (size)
    {
    case SIZE_16:
        nbrRounds = 10;
        break;
    case SIZE_24:
        nbrRounds = 12;
        break;
    case SIZE_32:
        nbrRounds = 14;
        break;
    default:
        return ERROR_AES_UNKNOWN_KEYSIZE;
        break;
    }

    expandedKeySize = (16 * (nbrRounds + 1));

    expandedKey = (unsigned char *)malloc(expandedKeySize * sizeof(unsigned char));

    if (expandedKey == NULL)
    {
        return ERROR_MEMORY_ALLOCATION_FAILED;
    }
    else
    {
       
        for (i = 0; i < 4; i++)
        {
            for (j = 0; j < 4; j++)
                block[(i + (j * 4))] = input[(i * 4) + j];
        }

        expandKey(expandedKey, key, size, expandedKeySize);

        aes_main(block, expandedKey, nbrRounds);

        for (i = 0; i < 4; i++)
        {
            for (j = 0; j < 4; j++)
                output[(i * 4) + j] = block[(i + (j * 4))];
        }

        free(expandedKey);
        expandedKey = NULL;
    }

    return SUCCESS;
}
