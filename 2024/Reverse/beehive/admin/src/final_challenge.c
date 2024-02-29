#include <linux/ptrace.h>
#include <bpf/bpf_helpers.h>
#include <linux/bpf.h>
#include <linux/sched.h>
#include <bpf/bpf_tracing.h>

#define MY_SYSCALL 0x31337
#define BIT_LENGTH 8

struct syscall_arguments {
    unsigned long syscall_id;
    const char* args[6];
};

__attribute__((section("raw_tracepoint/sys_enter"), used))
int weird_function(struct bpf_raw_tracepoint_args *ctx)
{
    struct syscall_arguments args = {};
    struct pt_regs *regs = (struct pt_regs *)ctx->args[0];
    char str[32];

    bpf_probe_read(&args.syscall_id, sizeof(args.syscall_id), &ctx->args[1]);
    if (args.syscall_id != MY_SYSCALL)
        return 0;

    bpf_probe_read(&args.args[0], sizeof(args.args[0]), &regs->rdi);
    bpf_probe_read(&args.args[1], sizeof(args.args[1]), &regs->rsi);
    bpf_probe_read_user_str(str, sizeof(str), args.args[0]);

    bpf_printk("Enter your key: %s", str);

    int is_domain = 0;
    int domain_length = 0;
    int non_domain_length = 0;
    int is_correct = 1;

    int reversed_keys[] = {86, 174, 206, 236, 250, 44, 118, 246, 46, 22, 204, 78, 250, 174, 206, 204, 78, 118, 44, 182, 166, 2, 70, 150, 12, 206, 116, 150, 118};
    int reversed_ctr = 0;
    int reversed_keys_length = 29;

    for (int i = 0; str[i]; i++) {
        if (str[i] == '@') {
            is_domain = 1;
        }

        is_domain ? domain_length++ : non_domain_length++;

        if (domain_length + non_domain_length > 32) {
            return 0;
        }

        unsigned char temp = str[i];
        int padded_binary = 0;

        for (int j = 0; j < BIT_LENGTH; j++) {
            padded_binary |= (temp & (1 << j)) ? (1 << (BIT_LENGTH - j - 1)) : 0;
        }

        if (reversed_ctr < reversed_keys_length) {
            // bpf_printk("padded_binary: %d, expected_key: %d", padded_binary, reversed_keys[reversed_ctr]);
            if (padded_binary != reversed_keys[reversed_ctr]) {
                is_correct = 0;
            }
        } else {
            break;
        }
        reversed_ctr++;
    }

    if (is_correct) {
        bpf_printk("Key is correct!");
    } else {
        bpf_printk("Key is incorrect!");
    }

    return 0;
}

char LICENSE[] SEC("license") = "GPL";
