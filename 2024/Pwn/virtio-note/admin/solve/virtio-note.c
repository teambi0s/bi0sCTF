#include "virtio-note.h"
#include "linux/completion.h"
#include "linux/kern_levels.h"
#include "linux/virtio.h"

static noinline long vn_ioctl(struct file *file, unsigned int cmd, unsigned long uarg)
{
    long ret = -1;
    req_t *req = 0;
    arg_t arg;
    struct scatterlist sg;
    mutex_lock(&vnote->lock);

    if(copy_from_user(&arg, (void *)uarg, sizeof(arg_t))) goto end;

    req = kzalloc(sizeof(req_t), GFP_KERNEL);
    if(!req) goto end;
    req->addr = virt_to_phys(vnote->buffer);
    req->idx = arg.idx;

    switch(cmd)
    {
        case VN_READ:
            req->op = VN_READ;
            *(unsigned long *)vnote->buffer = MAGIC;
            break;

        case VN_WRITE:
            if(copy_from_user(vnote->buffer, arg.buf, NOTE_SZ)) goto end;
            req->op = VN_WRITE;
            break;

        default:
            goto end;
    }

    sg_init_one(&sg, req, sizeof(req_t));
    virtqueue_add_outbuf(vnote->vnq, &sg, 1, req, GFP_KERNEL);
    virtqueue_kick(vnote->vnq);

    wait_for_completion(&vnote->ready);

    if(cmd == VN_READ)
    {
        if(*(unsigned long *)vnote->buffer == MAGIC)
        {
            printk(KERN_INFO "Failed to read from virtio-note");
            goto end;
        }
        if(copy_to_user(arg.buf, vnote->buffer, NOTE_SZ)) goto end;
    }
    ret = 0;

end:
    mutex_unlock(&vnote->lock);
    return ret;
}

void vn_notify_callback(struct virtqueue *vq) {
    int len;
    void *buf = virtqueue_get_buf(vq, &len);
    if(buf) kfree(buf);
    complete(&vnote->ready);
    return;
}

int virtio_note_assign_virtqueue(struct vnote_device *vnote) {
    const char *names[] = { "virtio-note-queue"};
    vq_callback_t *callbacks[] = { vn_notify_callback };
    struct virtqueue *vq;

    int err = virtio_find_vqs(vnote->vdev, 1, &vq, callbacks, names, NULL);
    if(err) return err;

    vnote->vnq = vq;
    return 0;
}

int probe_virtio_note(struct virtio_device *vdev) {

    int ret;

    printk(KERN_INFO "virtio-note device realized!\n");
    
    vnote = kzalloc(sizeof(struct vnote_device), GFP_KERNEL);
    if(vnote == NULL) {
        ret = ENOMEM;
        goto err;
    }

    vdev->priv = vnote;
    vnote->vdev = vdev;
    ret = virtio_note_assign_virtqueue(vnote);
    if(ret)
    {
        printk(KERN_INFO "virtio-note: Error adding virtqueue\n");
        goto err;
    }

    init_completion(&vnote->ready);
    mutex_init(&vnote->lock);

    if(misc_register(&vnmisc_device))
    {
        printk(KERN_INFO "virtio-note: Error creating miscdevice\n");
        ret = -ENODEV;
        goto err;
    }

    vnote->buffer = (char *)get_zeroed_page(GFP_KERNEL);
    if(!vnote->buffer)
    {
        printk(KERN_INFO "virtio-note: Error getting buffer memory\n");
        ret = -ENOMEM;
        goto err;
    }
    printk(KERN_INFO "virtio-note: virt_to_phys => %#lx\n", (unsigned long)virt_to_phys(vnote->buffer));

    return 0;

err:
    kfree(vnote);
    return ret;
}

static void remove_virtio_note (struct virtio_device *vdev) {
    misc_deregister(&vnmisc_device);
    complete(&vnote->ready);
    vdev->config->reset(vdev);
    vdev->config->del_vqs(vdev);
    free_pages((unsigned long)vnote->buffer, 0);
    kfree(vnote);
    printk(KERN_INFO "virtio-note device unrealized\n");
}

static int probe_virtio_note(struct virtio_device *vdev);
static void remove_virtio_note(struct virtio_device *vdev);

module_virtio_driver(driver_virtio_note);