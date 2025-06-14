#include <linux/kref.h>
#include <linux/rbtree_types.h>
#include <linux/rbtree.h>
#include <linux/refcount.h>
#include <linux/slab.h>


// Different mailbox states that change mailbox behavior
#define MAILTMP (0x1 << 0x8)
#define MAILDEL (0x1 << 0x9)
#define MAILBLK (0x1 << 0xa)
#define MAILCLR (0x1 << 0xb)
#define MAILUSR (MAILBLK | MAILCLR )
#define MAILALL (MAILTMP | MAILDEL | MAILBLK | MAILCLR)
#define MAILACT (MAILDEL | MAILBLK | MAILCLR)
#define MAILHLT (MAILTMP | MAILDEL | MAILBLK)
#define MAILSTK (MAILTMP | MAILDEL )

#define    MAILBOXSIZE  sizeof(mailbox)
#define       MAILSIZE  0x300
#define    MAX_MAIL_SZ  0x8000

enum mailerrors {
    ENOSUBS  = 0xf0,
    ENOMAIL  = 0xf1,
    EBADMAIL = 0xf2,
    EBADKEY  = 0xf3,
    ENOKEYT  = 0xf4,
    EBADSZ   = 0xf5,
};

enum : int {
    INITBOX = 0x1337001,
    SENDMAIL,
    RECVMAIL,
    STAT_SET,
    STAT_GET,
    SUBSCRIBE,
    UNSUBSCRIBE,
    GETPROCINFO,
};

# define REGULAR_MAIL   0x1
# define BROADCAST_MAIL 0x2
# define FR_SIZE       0x20

/* USERLAND INTERFACING STRUCTS */
struct mailentry {
    unsigned stat;
    unsigned public_key;
};

/* TODO: For process view features
            when it will be implemented */

typedef struct usrctx {
    unsigned nprocs;
    unsigned nentries;
    struct mailentry entries [];
} userctx;

typedef struct usrstat {
    unsigned short ctlop;
    unsigned short nextmtype;
    unsigned public_key;
    unsigned secret_key;
    unsigned nmails;
    unsigned lenmail;
    unsigned lenrmail;
    unsigned nsubs;
    unsigned submax;
} usrstat;

# define ALLMAIL 0x1000
# define REGMAIL 0x2000

/* This is for actions init, sndmail, rcvmail, subscribe, unsubscribe, */
typedef struct usrmail {
    unsigned flags;
    unsigned public_key;
    unsigned long secret_key;
    unsigned long size;
    char data [];
} usrmail;

typedef union usr_info {
    usrmail mail;
    usrstat stat;
    userctx pctx;
} usr_info;

/* KERNEL MAILING MODULE STRUCTURES */

/* mail fragment that stores rest of the mail */
typedef struct mlist {
    unsigned size;
    struct mlist *next;
    int8_t data [];
} mlist;

struct mailbox;

typedef struct tlist {
    struct mailbox *prev;
    struct mailbox *next;
} tlist;

/* 
 * List of mails that are to be broadcasted
 * We should be able to remove the blist entry after broadcast
 */
typedef struct blist {
    struct mailbox *mbox;
    struct blist *next;
    struct blist *prev;
} blist;

static struct rb_root mailusers = RB_ROOT;

/* head of a mail object in kernel used as a reference to data */
typedef struct mail_head {
    struct kref rcount;
    struct mlist *mfrag;
    struct mail_head *next;
    struct mail_head *prev;
    struct mailbox *lhead;
    unsigned long size;
    int8_t data [];
} mailhead;

/* Access implemented depending on object type */
typedef union object {
    struct mail_head obj;
    struct mail_head *ptr;
} object;

typedef struct frame {
    long objtype;
    struct frame *next;
    struct frame *prev;
    object elm;
} frame ;

/* mailbox that tracks the mails for every process */
typedef struct mailbox {
    unsigned mailbox_status;
    unsigned public_key;
    size_t secret_key;
    struct rb_node entree;
    unsigned nmails;
    unsigned bmails;
    struct frame *inboxmails;
    struct mail_head *rmailinglist;
    struct mail_head *outmails;
    /* Broadcast system */
    unsigned nsubs;
    unsigned submax;
    struct blist *bmailinglist;
} mailbox ;

# define FRAMESZ 0x20
# define DATASZ (MAILSIZE - (sizeof(struct mail_head) + FRAMESZ))
# define FRAGDATASZ (MAILSIZE - sizeof(mlist))

static atomic_t mail_refs;

static DEFINE_SPINLOCK(ioctl_lock);
static DEFINE_SPINLOCK(open_lock); 