#include <linux/fs.h>
#include <linux/minmax.h>
#include <linux/slab.h>
#include "linux/errno.h"
#include "linux/kref.h"
#include "linux/types.h"
#include "mailinglist.h"


static struct kmem_cache *mailboxcache = NULL;
static struct kmem_cache *mailcache    = NULL;
static struct kmem_cache *mframecache  = NULL;

/* A few externs cause it was inline-ing everything */
extern noinline long initmailboxkey(struct file *fl,usrmail *mail);
extern noinline long subscribe_to_mail(struct file *fl,usrmail *mail);
extern noinline long unsubscribe_to_mail (struct file *fl,usrmail *mail);
extern noinline long set_mailstatus (struct file *fl,usrstat *stats);
extern noinline long get_mailstatus (struct file *fl,usrstat *stats);
extern noinline long readmail (mailbox *box,usrmail *mail,void *__user arg);
extern noinline long writemail (mailbox *box,usrmail *mail,void *__user arg);
extern noinline void remove_mailbox (struct rb_root *root,struct mailbox *box);

/* Initialize mailbox and add to tmp list */
static void initmailbox(mailbox *box) {
	if (box == NULL) return;
	memset(box,0,sizeof(mailbox));
	box->mailbox_status = MAILTMP;
	box->submax = 0x10;
}

/* Lookup the mailbox using the public_key */
static noinline struct mailbox *lookup_mailbox(struct rb_root *root, unsigned key)
  {
  	struct rb_node *node = root->rb_node;

  	while (node) {
  		mailbox *box = (mailbox *)container_of(node, struct mailbox, entree);

		if(box->public_key < key) {
            node = node->rb_left;
        } else if (box->public_key > key) {
            node = node->rb_right;
        } else {
            return box;
        }
	}
	return NULL;

}

/* Insert mailbox into the rbtree */
static noinline bool insertmailbox(struct rb_root *root, struct mailbox *box)
  {
  	struct rb_node **new = &(root->rb_node), *parent = NULL;

  	while (*new) {
  		struct mailbox *this = container_of(*new, struct mailbox, entree);

		parent = *new;
  		if (this->public_key < box->public_key) 
  			new = &((*new)->rb_left);
  		else if (this->public_key > box->public_key)
  			new = &((*new)->rb_right);
  		else
  			return 1;
  	}

  	rb_link_node(&box->entree, parent, new);
  	rb_insert_color(&box->entree, root);

	return 0;
}

extern noinline long initmailboxkey(struct file *fl,usrmail *mail) {
	
	mailbox *box = fl->private_data;

	if (box->mailbox_status != MAILTMP) {
		return -ENOENT;
	} 
	
	box->public_key = mail->public_key;

	if(insertmailbox(&mailusers,box)) {
		box->public_key = 0;
		return -EEXIST;
	}
	
	box->secret_key = mail->secret_key;
	box->mailbox_status = MAILCLR;

	return 0;
}

/* add to last of dll */
static blist *appendtolist (blist *b1,blist *b2) {

	blist *x = b1;
	b2->next = NULL;

	if(!x) {
		b2->prev = NULL;
		return b2;
	}
	
	while(x->next) {
		x = x->next;
	}

	x->next = b2;
	b2->prev = x;

	return b1;

}

/* remove from the dll */
static blist *rm_fromlist (blist *b1,mailbox *box) {

	blist *x = b1;
	blist *y = NULL;

	if(!x) goto skip;

	while(x) {
		if (box == x->mbox) {
			y = x;
		} x = x->next;
	}

	if(!y) goto skip;

	if (y->next)
		y->next->prev = y->prev;

	if (y->prev) {
		y->prev->next = y->next;
	} else {
		x = y->next;
		kfree(y);
		return x;
	}

	skip:
		kfree(y);
		return b1;

}

static long checkinlist(blist *b1,mailbox *box) {
	blist *x = b1;
	while(x) {
		if(x->mbox == box) {return 1;}
		x = x->next;
	} return 0;
}

extern noinline long subscribe_to_mail(struct file *fl,usrmail *mail) {

	mailbox *box = fl->private_data;
	mailbox *subbox = lookup_mailbox(&mailusers,mail->public_key);

	if(box == subbox) {return -EEXIST;}
	if(box->mailbox_status & MAILHLT) return -ENOENT;
	if(!subbox || subbox->mailbox_status != MAILCLR) return -EAGAIN;

	if(subbox->nsubs < subbox->submax) {	
		if(checkinlist(subbox->bmailinglist,box)) {
			return -EEXIST;
		} blist *blistmember = kmalloc_noprof(sizeof(blist),GFP_KERNEL);
		if(!blistmember) return -ENOMEM;
		
		blistmember->mbox = box;
		subbox->bmailinglist = appendtolist(subbox->bmailinglist,blistmember);
		subbox->nsubs++;
	} else return -ENFILE;

	return 0;
	
}

extern noinline long unsubscribe_to_mail (struct file *fl,usrmail *mail) {

	mailbox *box = fl->private_data;
	mailbox *subbox = lookup_mailbox(&mailusers,mail->public_key);

	if(box->mailbox_status & MAILHLT) return -ENOENT;
	if(!subbox || subbox->mailbox_status & MAILSTK) return -EAGAIN;

	subbox->nsubs--;
	subbox->bmailinglist = rm_fromlist(subbox->bmailinglist,box);
	
	return 0;

}

extern noinline long set_mailstatus (struct file *fl,usrstat *stats) {
	
	mailbox *box = fl->private_data;

	if (stats->submax < 0x1000) box->submax = stats->submax;
	if (stats->ctlop == MAILBLK) box->mailbox_status = stats->ctlop;
	else if (stats->ctlop == MAILCLR) box->mailbox_status = stats->ctlop;
	else return -EINVAL;
	return 0;

}

static noinline struct mail_head *_get_head_from_frame (frame *fr) {

	if (!fr) return NULL;
	if(fr->objtype == REGULAR_MAIL) {
		return &fr->elm.obj;
	} else if (fr->objtype == BROADCAST_MAIL) {
		return fr->elm.ptr;
	} else { panic("INVALID MAIL FORMAT"); }

}

/* get next regular mail length */
static long getnextr_maillen(mailbox *box) {
	
	unsigned size = 0;
	mlist *ll;
	struct mail_head *x = box->rmailinglist;
	
	if(x) {
		ll = x->mfrag;
		while(ll) {
			size += ll->size;
			ll = ll->next;
		} size += x->size;
		return size;
	} else 
		return 0;

}

static long getnext_maillen(mailbox *box) {

	unsigned size = 0;
	mlist *ll;
	struct mail_head *x = _get_head_from_frame(box->inboxmails);
	if(x) {
		ll = x->mfrag;
		while(ll) {
			size += ll->size;
			ll = ll->next;
		} size += x->size;
		return size;
	} else 
		return 0;

}

static long getnext_mailtype(mailbox *box) {
	if(box->inboxmails)
		return box->inboxmails->objtype;
	return 0;
}

/* get the status of the next mail */
extern noinline long get_mailstatus (struct file *fl,usrstat *stats) {
	
	mailbox *box = fl->private_data;

	stats->nextmtype  = getnext_mailtype(box);
	if (stats->nextmtype == REGULAR_MAIL) {
		stats->lenrmail = getnext_maillen(box);	
		stats->lenmail = stats->lenrmail;
	} else {
		stats->lenrmail = getnextr_maillen(box);
		stats->lenmail    = getnext_maillen(box);
	}

	stats->ctlop      = box->mailbox_status;
	stats->nmails     = box->nmails;
	stats->nsubs      = box->nsubs;
	stats->public_key = box->public_key;
	stats->secret_key = box->secret_key;
	stats->submax     = box->submax;

	return 0;
}

static void free_mlistptr(mlist *ll) {
	mlist *tf;
	while (ll != NULL) {
		tf = ll;
		ll = ll->next;
		kmem_cache_free(mailcache,tf);
	}
}

static noinline void __free_user_rframe (struct kref *ref) {

	mlist *ll = NULL;
	frame *fr = container_of( // frame struct *
					container_of( // object union * 
						container_of( // mail_head struct *
							ref,struct mail_head,rcount)
												,object,obj)
														,frame,elm);

	ll = fr->elm.obj.mfrag;
	kmem_cache_free(mailcache,fr);
	free_mlistptr(ll);

}

static noinline void __free_user_bframe (struct kref *ref) {

	mlist *ll = NULL;

	struct mail_head *head = container_of(ref,struct mail_head,rcount);
	ll = head->mfrag;

	kmem_cache_free(mailcache,head);
	free_mlistptr(ll);

}

static noinline void __free_user_frame (struct frame *fr,unsigned flag) {

	mlist *ll = NULL;
	mlist *tf = NULL;
	if(!fr) return;
	if (flag == BROADCAST_MAIL) {
		ll = fr->elm.ptr->mfrag;
		if(kref_read(&(fr->elm.ptr->rcount)) == 0) {
			kmem_cache_free(mailcache,fr->elm.ptr);
		} kmem_cache_free(mframecache,fr);
	} else {
		ll = fr->elm.obj.mfrag;
		kmem_cache_free(mailcache,fr);
	}

	while (ll != NULL) {
		tf = ll;
		ll = ll->next;
		kmem_cache_free(mailcache,tf);
	}

}

/* Copy the mail from the kernel-land to userspace */
static noinline long copy_mail_to_user (struct mail_head *head,void *__user arg) {

	__user void *ptr = arg;
	mlist *mailfrag = head->mfrag;
	int val = copy_to_user(ptr,head->data,head->size);
	if(val) return -EFAULT;

	ptr += head->size;

	while (mailfrag != NULL) {
		if(copy_to_user(ptr,mailfrag->data,mailfrag->size)) {
			mailfrag = mailfrag->next;
			continue;
		} return -EFAULT;
	}

	return 0;

}

/* only to be called on a broadcast frame */
static frame *dup_user_bframe (frame *fr) {
	
	frame *nfr = kmem_cache_alloc(mframecache,GFP_KERNEL);
	if (!nfr) return NULL;
	nfr->objtype = BROADCAST_MAIL;
	nfr->elm.ptr = fr->elm.ptr;
	return nfr;

}

/* Basically copy mail from user */
static noinline struct frame *__craft_user_mail (void *__user arg,unsigned mailsz,unsigned type) {

	__user void *ptr = arg + sizeof(usrmail);
	mlist **lnext = NULL;
	ulong size = mailsz;
	frame *fr = NULL;
	struct mail_head *head = NULL;
	ulong copysz = min(size,DATASZ);

	if (type == REGULAR_MAIL) {
		fr = kmem_cache_alloc(mailcache,GFP_KERNEL);
		if (!fr) return NULL;
		head = &(fr->elm.obj);
		fr->objtype = REGULAR_MAIL;
	} else {
		fr = kmem_cache_alloc(mframecache,GFP_KERNEL);
		if (!fr) return NULL;
		fr->objtype = BROADCAST_MAIL;
		fr->elm.ptr = kmem_cache_alloc(mailcache,GFP_KERNEL);
		if (!fr->elm.ptr) return NULL;
		head = fr->elm.ptr;
	} 
	
	head->mfrag = NULL;

	if(copy_from_user(head->data,ptr,copysz))
		goto end;

	head->size = copysz;
	size -= copysz;
	ptr  += copysz;
	lnext = &(head->mfrag);
	
	/* If we can't copy it through, ditch it and run */
	while (size) {

		copysz = min(size,FRAGDATASZ);
		*lnext = kmem_cache_alloc(mailcache,GFP_KERNEL);
		if(!(*lnext)) goto end;

		(*lnext)->next = NULL;

		if(copy_from_user((*lnext)->data,ptr,copysz)) {
			goto end;
		}

		lnext = &((*lnext)->next);
		ptr += copysz;
		size -= copysz;

	} return fr;

end:
	__free_user_frame(fr,type);
	return NULL;

}

/* insert frame into the ll */
static void _link_user_frame(mailbox *box,struct frame *fr) {

	if(box->inboxmails) {
		fr->next = box->inboxmails;
		fr->prev = box->inboxmails->prev;
		fr->prev->next = fr;
		fr->next->prev = fr;
	} else {
		fr->next = fr;
		fr->prev = fr;
		box->inboxmails = fr;
	}

}

static void _link_head_object(mailbox *box,struct mail_head *head,unsigned type) {

	struct mail_head **headptr;
	if (type == REGULAR_MAIL) headptr = &box->rmailinglist;
	else headptr = &box->outmails;

	if(*headptr == NULL) {
	   *headptr     = head;
	    head->next  = head;
	    head->prev  = head;
		head->lhead = box;
	} else {
		head->prev = (*headptr)->prev;
		head->next = (*headptr);
		head->prev->next = head;
		head->next->prev = head;
	}

}

/* This is for linking in the following */
static void noinline link_user_frame (mailbox *box,struct frame *fr,unsigned type) {
	
	_link_user_frame(box,fr);

	if (type == REGULAR_MAIL) {
		struct mail_head *head = _get_head_from_frame(fr);
		_link_head_object(box,head,REGULAR_MAIL);
	}

}

static noinline void link_user_broadcast_frame (mailbox *box,struct frame *fr) {

	struct mail_head *head = _get_head_from_frame(fr);
	_link_head_object(box,head,BROADCAST_MAIL);

}


static struct frame *_get_next_rframe (mailbox *box) {

	struct mail_head *head = box->rmailinglist;
	if(head == NULL) return NULL;
	object *some = container_of(head,object,obj);
	return container_of(some,frame,elm);

}

static void __remove_user_frame (struct frame *fr) {

	if (fr->objtype == REGULAR_MAIL) {
		kref_put(&fr->elm.obj.rcount,__free_user_rframe);
	} else {
		kref_put(&fr->elm.ptr->rcount,__free_user_bframe);
		kmem_cache_free(mframecache,fr);
	}

}

/* unlink the mailhead object from the circular ll */
static void _unlink_head_object (struct mail_head *head,unsigned type) {
	
	if(head->next == head) {
		if (type == REGULAR_MAIL) {
			head->lhead->rmailinglist = NULL;
		} else {
			head->lhead->outmails = NULL;
		}
	} else {
		head->next->prev = head->prev;
		head->prev->next = head->next;
		if(head->lhead) {
			if(type == REGULAR_MAIL)
				head->lhead->rmailinglist = head->next;
			else
			 	head->lhead->outmails = head->next;
			
			head->next->lhead = head->lhead;
		} 
	}

}

/* This is frame function for unlinking */
static void unlink_user_frame (mailbox *box,frame *fr) {

	if(!fr) return;
	if(fr->objtype == REGULAR_MAIL) {
		_unlink_head_object(&fr->elm.obj,REGULAR_MAIL);
	} else {
		if((kref_read(&fr->elm.ptr->rcount)) <= 1)
			_unlink_head_object(fr->elm.ptr,BROADCAST_MAIL);
	}

	if (fr == box->inboxmails) {
		if (fr->next == fr) 
			box->inboxmails = NULL;
		else 
			box->inboxmails = fr->next;
	}
	
	fr->next->prev = fr->prev;
	fr->prev->next = fr->next;

	return;

}

static long __read_mail (mailbox *box,usrmail *mail,usrmail *__user arg) {
	
	int res = 0;
	struct mail_head * head;
	frame *fr;
	if(box->mailbox_status & MAILSTK) return -ENOENT;

	if(mail->flags & !( ALLMAIL | REGMAIL ))
		return -EINVAL;

	if(mail->flags & REGMAIL) {

		fr = _get_next_rframe(box);
		head = _get_head_from_frame(fr);
		if(!head) return -ENOMAIL;
		mail->size = getnextr_maillen(box);

	} else {

		fr = box->inboxmails;
		head = _get_head_from_frame(fr);
		if(!head) return -ENOMAIL;
		mail->size = getnext_maillen(box);

	}
		/* It is the user's responsibility to discard a bad mail */

	res = copy_mail_to_user(head,arg + 1);
	if(res || copy_to_user(&arg->size,&mail->size,sizeof(mail->size))) res = -EBADMAIL;

	unlink_user_frame(box,fr);
	__remove_user_frame(fr);

	box->nmails--;
	
	return 0;
	
}

extern noinline long readmail (mailbox *box,usrmail *mail,void *__user arg) {
	
	if (box->nmails > 0) {
		return __read_mail (box,mail,arg);
	} return -ENOMAIL;

}

extern noinline long writemail (mailbox *box,usrmail *mail,void *__user arg) {
	
	mailbox *sendbox = NULL;
	blist *senders = NULL;
	frame *nfr = NULL;
	struct mail_head *head;
	unsigned type;
	
	if (mail->flags & REGULAR_MAIL) type = REGULAR_MAIL; 
	else type = BROADCAST_MAIL;

	if (type == BROADCAST_MAIL && box->nsubs == 0) {
		return -ENOSUBS;
	}

	if(mail->size > MAX_MAIL_SZ) return -EBADSZ;
	
	if (mail->public_key) {
		if (type == REGULAR_MAIL ) {
			sendbox = lookup_mailbox(&mailusers,mail->public_key);
			if(!sendbox) return -ENOKEYT;
			if(mail->secret_key != sendbox->secret_key) return -ENOKEYT;
		} else senders = box->bmailinglist;
	} else return -EBADKEY;

	frame *fr = __craft_user_mail(arg,mail->size,type);
	if(fr == NULL) return -EBADTYPE;
	
	head = _get_head_from_frame(fr);
	kref_init(&head->rcount);

	if(type == BROADCAST_MAIL) {
		
		if (!senders) {
			__remove_user_frame(fr);
			return -ENOSUBS;
		} box->bmails++;

		/* Send to all senders and append to outlist of sendbox */
		while (senders) {
			if((senders->mbox->mailbox_status & MAILHLT)) {
				senders = senders->next;
				continue;
			} 
			
			nfr = dup_user_bframe(fr);
			link_user_frame(senders->mbox,nfr,type);
			kref_get(&head->rcount);
			senders->mbox->nmails++;
			senders = senders->next;
			
		} 
		
		link_user_broadcast_frame(box,fr);
		kmem_cache_free(mframecache,fr);

	} else {
		link_user_frame(sendbox,fr,type);
		kref_get(&head->rcount);
	}

	return 0;

}

/* Remove mailbox from rb tree and free resources */
extern noinline void remove_mailbox(struct rb_root *root,struct mailbox *box) {
	frame *fr;
	blist *bl;
	blist *tmp;
	struct mail_head *bmails;

	if(!box) return;
	fr = box->inboxmails;
	bl = box->bmailinglist;
	bmails = box->outmails;

	/* unlink all inbox mails */
	while (fr) {
		unlink_user_frame(box,fr);
		__remove_user_frame(fr);
		fr = box->inboxmails;
	} 
	
	/* unlink all boxes from bmailinglist */
	while (bl) {
		tmp = bl;
		bl = bl->next;
		rm_fromlist(tmp, box);
	} 
	
	/* Make sure nothing links back to the head */
	if(bmails) {
		while (bmails->next != box->outmails) {
			bmails->lhead = NULL;
			bmails = bmails->next;
		} 
	}

	if (box->public_key != 0) 
		if (lookup_mailbox(root,box->public_key))
			rb_erase(&box->entree, root);

}