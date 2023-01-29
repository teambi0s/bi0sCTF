#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/device.h>
#include <linux/mutex.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <linux/uaccess.h>
#include <linux/miscdevice.h>

MODULE_AUTHOR("k1R4");                        
MODULE_DESCRIPTION("\"k32\" - bi0s CTF 2022");
MODULE_LICENSE("GPL");

#define KCREATE     0xb10500a
#define KDELETE     0xb10500b
#define KREAD       0xb10500c
#define KWRITE      0xb10500d

static DEFINE_MUTEX(operations_lock);
static struct kmem_cache *k32_cachep;

typedef struct{
    char *buf;
    uint8_t size;
    uint32_t idx;
}req_t;


typedef struct k32_t{
    struct k32_t *next;
    char *buf;
    uint8_t size;
}k32_t;


k32_t *k32_head = NULL;

unsigned long idx = 0;

static long k32_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
static struct file_operations k32_fops = {.unlocked_ioctl = k32_ioctl};

static noinline long k32_create(req_t *req);
static noinline long k32_delete(req_t *req);
static noinline long k32_read(req_t *req);
static noinline long k32_write(req_t *req);

static long error(char *msg)
{
    printk(KERN_ALERT "%s\n", msg);
    return -1;
}

struct miscdevice k32_device = {
    .minor = MISC_DYNAMIC_MINOR,
    .name = "k32",
    .fops = &k32_fops,
};
