#include <linux/cdev.h>
#include <linux/fs.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/random.h>
#include <linux/uaccess.h>
#include <linux/spinlock.h>
#include "linux/slab.h"
#include "mail_utils.c"

/* Hope you have fun :D */

MODULE_LICENSE("GPL");
MODULE_AUTHOR("R0R1");
MODULE_DESCRIPTION("Kernel Mailbox");

#define       DEV_NAME  "mailbox"
#define  MAILBOX_CACHE  "mailbox_caches"
#define     MAIL_CACHE  "mail_caches"
#define     FRAMECACHE  "frame_cache"

static dev_t devnum;
static struct cdev chrdev;

static void mail_setup_cache(void *addr) {
  memset(addr,0,MAILSIZE);
}

static void mailbox_setup_cache(void *addr) {
  memset(addr,0,MAILBOXSIZE);
}

static void mailframe_setup_cache (void *addr) {
  memset(addr,0,FR_SIZE);
}

/* We store the mailbox in file->private_data */
static int maildev_open(struct inode *inode, struct file *filp) {

  mailbox *box = kmem_cache_alloc(mailboxcache, GFP_KERNEL);

  spin_lock(&open_lock);
  
  initmailbox(box);
  filp->private_data = box;

  spin_unlock(&open_lock);

  if (!filp->private_data)
    return -ENOMEM;

  mail_refs.counter++;
  return 0;
}

/* bye bye mail device */
static int maildev_close(struct inode *inode, struct file *filp) {

  mailbox *box = filp->private_data;
  remove_mailbox(&mailusers,box);
  kmem_cache_free(mailboxcache, box);
  mail_refs.counter--;
  return 0;

}

static noinline long maildev_ioctl(struct file *file, unsigned int cmd, unsigned long __user arg) {
  
  long res = 0;

	usr_info mailinfo;

  spin_lock(&ioctl_lock);
  
	if(copy_from_user((void *)&mailinfo,(void *)arg,sizeof(usr_info))) {
    res = -EFAULT;
    goto fastret;
  }

  /* This is the heart of the mailbox service */
  switch(cmd) {
    case INITBOX:
      res = initmailboxkey(file,&mailinfo.mail);
      break;
    case SENDMAIL:
      res = writemail(file->private_data,&mailinfo.mail,(void *)arg);
      break; 
    case RECVMAIL:
      res = readmail(file->private_data,&mailinfo.mail,(void *)arg);
      if(!res) 
        if(copy_to_user((void *)arg,&mailinfo,sizeof(usrmail)))
          res = -EFAULT;
      break;
    case STAT_SET:
      res = set_mailstatus(file,&mailinfo.stat);
      break;
    case STAT_GET:
      res = get_mailstatus(file,&mailinfo.stat);
      if(copy_to_user((void *)arg,(void *)&mailinfo.stat,sizeof(usr_info)))
        res = -EFAULT;
      break;
    case SUBSCRIBE:
      res = subscribe_to_mail(file,&mailinfo.mail);
      break;
    case UNSUBSCRIBE:
      res = unsubscribe_to_mail(file,&mailinfo.mail);
      break;
    default:
      res = -EINVAL;
  }

  fastret:
      spin_unlock(&ioctl_lock);
      return res;
    
}

static struct file_operations module_fops = {
  .owner   = THIS_MODULE,
  .open    = maildev_open,
  .release = maildev_close,
  .unlocked_ioctl = maildev_ioctl
};

static int __init setup_mail_module(void) {

  mail_refs.counter = 0;

  if(alloc_chrdev_region(&devnum,0,1,DEV_NAME)) {
    return -EBUSY;
  }

  cdev_init(&chrdev,&module_fops);
  chrdev.owner = THIS_MODULE;

  if (cdev_add(&chrdev,devnum, 1)) {
      unregister_chrdev_region(devnum, 1);
      return -EBUSY;
  }

  /* Our custom caches for the everything we need / hopefully the kernel can provide for it */
  mailboxcache = kmem_cache_create(MAILBOX_CACHE,MAILBOXSIZE,0,0,mailbox_setup_cache);
  mailcache    = kmem_cache_create_usercopy(MAIL_CACHE,MAILSIZE,0,SLAB_ACCOUNT,0x0,MAILSIZE,mail_setup_cache);
  mframecache  = kmem_cache_create(FRAMECACHE,FR_SIZE,0,0,mailframe_setup_cache);

  if(!mailcache || !mailboxcache || !mframecache)
        return -ENOMEM;
  
  return 0;
  
}

static void __exit cleanup_mail_module(void) {
  kmem_cache_destroy(mailboxcache);
  kmem_cache_destroy(mailcache);
  return;
}

// Setup the intializers for the module 
module_init(setup_mail_module);
module_exit(cleanup_mail_module);