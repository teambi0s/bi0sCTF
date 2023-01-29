// gcc -o kawaii_vm kawaii_vm.c -lseccomp -O3 -Wl,-rpath="./lib/"
// patchelf --set-interpreter ./ld-linux-x86-64.so.2 kawaii_vm

#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/mman.h>
#include <string.h>
#include <seccomp.h>
#include <sys/syscall.h>

//#define DEBUG
#define SECCOMP
#define BYTECODE_SZ       0x10000
#define MAX_ARRAY_SZ      0x10000
#define ERROR_CODE        0x45
#define STACK_SZ          0x10000
#define MAX_REGS          0x4            


#define HALT    0xff
#define ADD     0x30
#define SUB     0x31
#define MUL     0x32
#define DIV     0x33
#define XOR     0x34
#define PUSH    0x35
#define POP     0x36
#define SET     0x37
#define GET     0x38
#define MOV     0x39
#define SHR     0x3a
#define SHL     0x3b
#define RESET   0x40

typedef struct
{
    unsigned long x[MAX_REGS];
    unsigned char *pc;
    unsigned long *sp;
    unsigned int  *ar;
}kawaii_registers;


kawaii_registers *regs;
unsigned long array_size = MAX_ARRAY_SZ;
float units = 0;
unsigned char *kawaii_map;

void print(char *msg)
{
    write(1,msg,strlen(msg));
}

void println(char *msg)
{
    print(msg);
    print("\n");
}

void prompt(char *msg)
{
    println(msg);
    print("> ");
}

void __attribute__ ((noinline)) kawaii_exit(char code){ syscall(SYS_exit_group, code); }

void error(char *msg)
{
    print("[-] ");
    println(msg);
    kawaii_exit(ERROR_CODE);
}


void invalid(){ return error("Invalid bytecode!"); }


void initialize()
{
    setbuf(stderr, NULL);
    setbuf(stdout, NULL);
    alarm(30);
}


void print_welcome_msg()
{
    print("\n");
    println(",  ,                     .   , .   , ");
    println("| /                o o   |  /  |\\ /| ");
    println("|<   ,-: , , , ,-: . .   | /   | V | ");
    println("| \\  | | |/|/  | | | |   |/    |   | ");
    println("'  ` `-` ' '   `-` ' '   '     '   ' ");
    println("                                     ");
    println("      .      ,-.          .       ");
    println("      |   o /  /\\         |    ,- ");
    println("      |-. . | / | ,-. ,-. |-   |  ");
    println("      | | | \\/  / `-. |   |    |- ");
    println("      `-' '  `-'  `-' `-' `-'  |  ");
    println("                              -'  ");
    print("\n");
}


void get_kawaii_map()
{
    char ans;

    prompt("Do you want a custom array size? (y/n)");

    scanf("%c", &ans);
    getchar();

    if(ans == 0x79) 
    {
        prompt("Enter no of pages (1 page = 4096 bytes)");
        scanf("%f", &units);
        if(units < 0 || units > MAX_ARRAY_SZ/0x1000) error("Array size isn't kawaii :/");
        array_size = 0x1000*units;
    }

    kawaii_map = mmap(NULL, (unsigned long)(BYTECODE_SZ + STACK_SZ + MAX_ARRAY_SZ),  PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE , 0, 0);
    if(kawaii_map == (void *)-1) error("mmap failed :-(");
}


void parse_input()
{
    int i = 0;
    int read_sz;

    prompt("Enter bytecode to be executed");
    read_sz = read(0, kawaii_map, BYTECODE_SZ-1);
    if(read_sz < 0) error("Couldn't read input ;-;");
    *(kawaii_map+read_sz) = HALT;

    while(i < read_sz)
    {
        switch(*(kawaii_map+i))
        {
            case ADD:
            case SUB:
            case MUL:
            case DIV:
            case XOR:
                if(i+3 >= read_sz) invalid();
                if(*(kawaii_map+i+1) >= MAX_REGS || *(kawaii_map+i+2) >= MAX_REGS || 
                    *(kawaii_map+i+3) >= MAX_REGS) invalid();
                i += 3;
                break;

            case PUSH:
            case POP:
            case SHR:
            case SHL:
                if(i+1 >= read_sz) invalid();
                if(*(kawaii_map+(i+1)) >= MAX_REGS) invalid();
                i++;
                break;

            case SET:
            case GET:
                if(i+5 >= read_sz) invalid();
                if(*(kawaii_map+i+1) >= MAX_REGS || *(unsigned int *)(kawaii_map+i+2) >= array_size/4) invalid();
                i += 5;
                break;

            case MOV:
                if(i+5 >= read_sz) invalid();
                if(*(kawaii_map+i+1) >= MAX_REGS) invalid();
                i += 5;
                break;
        }
        i++;
    }
}

#ifdef SECCOMP
void kawaii_seccomp()
{
    scmp_filter_ctx ctx;

    ctx = seccomp_init(SCMP_ACT_KILL);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(open), 0);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(openat), 0);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(read), 0);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(write), 0);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(exit), 0);
    seccomp_rule_add(ctx, SCMP_ACT_ALLOW, SCMP_SYS(exit_group), 0);

    close(STDIN_FILENO);
    println("[*] Applying seccomp filetrs, no escape ;)");
    if(seccomp_load(ctx)) error("Seccomp error :^(");
}
#endif

void init_vm()
{
    regs = (kawaii_registers *)(malloc(sizeof(kawaii_registers)));
    if(regs == NULL) error("malloc failed :c"); 

    regs->pc = kawaii_map;
    regs->sp = (unsigned long *)(kawaii_map + BYTECODE_SZ + STACK_SZ);
    regs->ar = (unsigned int *)(kawaii_map + BYTECODE_SZ + STACK_SZ);
    for(int i = 0; i < MAX_REGS; i++) regs->x[i] = 0;
}

#ifdef DEBUG
void kawaii_debug()
{
    putchar(0xa);
    printf("[KAWAII] PC => %#lx\n", regs->pc);
    printf("[KAWAII] SP => %#lx\n", regs->sp);
    printf("[KAWAII] AR => %#lx\n", regs->ar);

    for(int i = 0; i < MAX_REGS; i++)
    {
        printf("[KAWAII] X%d => %#lx\n", i, regs->x[i]);
    }
    putchar(0xa);
}
#endif

void run_vm()
{
    int ins_count = 0;
    unsigned char *saved_pc;

    while(*(regs->pc) != HALT)
    {
        switch(*(regs->pc))
        {
            case ADD:
                regs->x[*(regs->pc+1)] = regs->x[*(regs->pc+2)] + regs->x[*(regs->pc+3)];
                regs->pc += 3;
                break;

            case SUB:
                regs->x[*(regs->pc+1)] = regs->x[*(regs->pc+2)] - regs->x[*(regs->pc+3)];
                regs->pc += 3;
                break;

            case MUL:
                regs->x[*(regs->pc+1)] = regs->x[*(regs->pc+2)] * regs->x[*(regs->pc+3)];
                regs->pc += 3;
                break;

            case DIV:
                regs->x[*(regs->pc+1)] = regs->x[*(regs->pc+2)] / regs->x[*(regs->pc+3)];
                regs->pc += 3;
                break;

            case XOR:
                regs->x[*(regs->pc+1)] = regs->x[*(regs->pc+2)] ^ regs->x[*(regs->pc+3)];
                regs->pc += 3;
                break;

            case PUSH:
                if(regs->sp <= (unsigned long *)(kawaii_map+BYTECODE_SZ+8)) error("Stack Overflow (┛ಠ_ಠ)┛彡┻━┻"); 
                regs->sp--;
                *regs->sp = regs->x[*(++regs->pc)];
                break;

            case POP:
                if(regs->sp > (unsigned long *)(kawaii_map+BYTECODE_SZ+STACK_SZ)) error("Stack Underflow ┳━┳ ヽ(ಠل͜ಠ)ﾉ"); 
                regs->x[*(++regs->pc)] = *regs->sp;
                regs->sp++;
                break;

            case SET:
                regs->ar[*(unsigned int *)(regs->pc+2)] = (unsigned int)regs->x[*(regs->pc+1)];
                regs->pc += 5;
                break;

            case GET:
                regs->x[*(regs->pc+1)] = regs->ar[*(unsigned int *)(regs->pc+2)];
                regs->pc += 5;
                break;

            case MOV:
                regs->x[*(regs->pc+1)] = *(unsigned int *)(regs->pc+2);
                regs->pc += 5;
                break;

            case SHR:
                regs->x[*(regs->pc+1)] = regs->x[*(regs->pc+1)] >> 1;
                regs->pc++;
                break;

            case SHL:
                regs->x[*(regs->pc+1)] = regs->x[*(regs->pc+1)] << 1;
                regs->pc++;
                break;

            case RESET:
                saved_pc = regs->pc;
                init_vm();
                regs->pc = saved_pc;
                memset(kawaii_map+BYTECODE_SZ, 0x0, STACK_SZ);
                break;

            default:
                #ifdef DEBUG
                    printf("[!] Invalid opcode at position %d: %d\n", regs->pc - kawaii_map, *(regs->pc));
                #endif
                ins_count--;
                break;   
        }

        if(regs->pc < kawaii_map || regs->pc > kawaii_map+BYTECODE_SZ) error("SEGFAULT!");

        regs->pc++;
        ins_count++;

        #ifdef DEBUG
            kawaii_debug();
        #endif
    }
    #ifdef DEBUG
        printf("[*] Executed %d instructions!\n", ins_count);
    #endif
    println("[*] Execution complete!");
}


int main()
{

    initialize();
    print_welcome_msg();
    get_kawaii_map();
    parse_input();
    init_vm();
    #ifdef SECCOMP
    kawaii_seccomp();
    #endif
    run_vm();
    
    kawaii_exit(0);
}