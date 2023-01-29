#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/device.h>
#include <linux/mutex.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <linux/uaccess.h>
#include <linux/delay.h>
#include "k32.h"


static long k32_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
{
    req_t req;
    long result;
    mutex_lock(&operations_lock);

    if(copy_from_user(&req, (void *)arg, sizeof(req_t)))
    {
        error("[-] Unable to copy_from_user in k32_ioctl");
    }

    switch(cmd)
    {
        case KCREATE: 
            result = k32_create(&req);
            break;

        case KDELETE:
            result = k32_delete(&req);
            break;

        case KREAD:
            result = k32_read(&req);
            break;

        case KWRITE: 
            result = k32_write(&req);
            break;

        default: result = -2;
    }

    mutex_unlock(&operations_lock);
    return result;
}


static noinline k32_t *k32_search(uint32_t idx)
{
    k32_t *k32 = k32_head;
    
    for(int i = 0; i < idx; i++)
    {
        if(k32 == NULL || k32->buf == NULL) return 0;
        k32 = k32->next;
    }
    return k32;
}


static noinline uint8_t k32_fix_size(uint8_t size)
{
   if(size > 0x30) return 0x30;
   else return 0x20;
}


static noinline long k32_create(req_t *req)
{
    k32_t *k32 = k32_head;
    k32_t *prev = NULL;

    req->size = k32_fix_size(req->size);

    while(k32 != NULL && k32->buf != NULL)
    {
        prev = k32;
        k32 = k32->next;
    }

    if(k32 == NULL)
    {
        k32 = kmem_cache_zalloc(k32_cachep, GFP_KERNEL_ACCOUNT);
        if(k32 == NULL) return error("[-] Unable to kmem_cache_zalloc() in k32_create");
        if(k32_head != NULL) prev->next = k32;
        else k32_head = k32;
    }

    k32->buf = kmalloc(k32_fix_size(req->size), GFP_KERNEL);
    if(k32->buf == NULL) return error("[-] Unable to kmalloc() in k32_create");

    k32->next = NULL;
    k32->size = req->size;

    return 0;
}


static noinline long k32_delete(req_t *req)
{
    k32_t *prev;
    k32_t *k32;

    k32 = k32_search(req->idx);
    if(k32 == NULL) return -1;
    prev = k32_search(req->idx-1);

    kfree(k32->buf);
    if(prev != NULL)
    {
        prev->next = k32->next;
        kmem_cache_free(k32_cachep, k32); 
    }
   else
   {
    k32->buf = NULL;
    k32->size = 0;
   }

    return 0;
}


static noinline long k32_read(req_t *req)
{
    k32_t *k32;

    k32 = k32_search(req->idx);
    if(k32 == NULL) return -1;
    
    if(req->size > k32->size) return -1;

    if(copy_to_user(req->buf, k32->buf, req->size))
    {
        error("[-] Unable to copy_to_user() in k32_read");
        return -1;
    }

    return 0;
}


static noinline long k32_write(req_t *req)
{
    k32_t *k32;

    k32 = k32_search(req->idx);
    if(k32 == NULL) return -1;

    if(req->size > k32->size) return -1;

    if(copy_from_user(k32->buf, req->buf, req->size))
    {
        error("[-] Unable to copy_from_user() in k32_write");
        return -1;
    }

    return 0;
}


static int __init init_k32(void)
{

    k32_cachep = KMEM_CACHE(k32_t, SLAB_PANIC | SLAB_ACCOUNT);
    if(k32_cachep == NULL) return error("[-] Failed to get cache");

    mutex_init(&operations_lock);
    if(misc_register(&k32_device) < 0){
        mutex_destroy(&operations_lock);
        error("[-] Failed to register k32");
    }

    return 0;
}


static void __exit exit_k32(void)
{
    k32_t *prev;

    while(k32_head != NULL)
    {
        kfree(k32_head->buf);
        prev = k32_head;
        k32_head = k32_head->next;
        kmem_cache_free(k32_cachep, prev);
    }

    misc_deregister(&k32_device);
}

module_init(init_k32);
module_exit(exit_k32);