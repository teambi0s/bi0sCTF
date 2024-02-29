#include <linux/signal.h>
#include <linux/virtio.h>
#include <linux/virtio_config.h>
#include <asm/page_types.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/device.h>
#include <linux/mutex.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <linux/uaccess.h>
#include <linux/miscdevice.h>
#include <linux/gfp.h>
#include <linux/random.h>
#include <linux/gfp_types.h>
#include <linux/slab.h>
#include <linux/list.h>
#include <asm/io.h>

#define VIRTIO_ID_NOTE    42
#define NOTE_SZ           0x40
#define MAGIC             0xdeadbeefcafebabe

MODULE_AUTHOR("k1R4");                        
MODULE_DESCRIPTION("\"virtio-note\" - bi0s CTF 2024");
MODULE_LICENSE("GPL");

typedef enum
{
    VN_READ,
    VN_WRITE
} operation;

typedef unsigned long hwaddr;
typedef struct
{
    unsigned int idx;
    hwaddr addr;
    operation op;
} req_t;

typedef struct
{
    unsigned int idx;
    char *buf;
} arg_t;

static struct virtio_device_id id_table[] = {
	{ VIRTIO_ID_NOTE, VIRTIO_DEV_ANY_ID },
	{ 0 },
};
static unsigned int feature_table[] = { };

struct vnote_device {
    struct virtqueue *vnq;
    struct virtio_device *vdev;
    struct completion ready;
    char *buffer;
    struct mutex lock;
};
struct vnote_device *vnote;

static noinline long vn_ioctl(struct file *file, unsigned int cmd, unsigned long uarg);
static int probe_virtio_note(struct virtio_device *vdev);
static void remove_virtio_note(struct virtio_device *vdev);

static struct file_operations vn_fops = {.unlocked_ioctl = vn_ioctl};


static struct virtio_driver driver_virtio_note = {
    .driver.name = "virtio-note",
    .driver.owner = THIS_MODULE,
    .id_table = id_table,
    .feature_table = feature_table,
    .feature_table_size = ARRAY_SIZE(feature_table),
    .probe = probe_virtio_note,
    .remove = remove_virtio_note
};

static struct miscdevice vnmisc_device = {
    .minor = MISC_DYNAMIC_MINOR,
    .name = "virtionote",
    .fops = &vn_fops,
};