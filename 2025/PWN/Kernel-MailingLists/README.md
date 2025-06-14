# Kernel-Mailinglists

### Challenge Description

Linus cannot stop me from writing bad code into the kernel :D LKM FTW, **evil laugh**

Hopefully the kernel doesn't burn to ashes.

**Challenge File**:
+ [Primary Link](https://drive.google.com/drive/folders/1ZwpQH2vzaRL7khwu743-qeDBtTFvsngB?usp=sharing)

**MD5 Hash**: 
69ddd7e54411cef50e34251f436e5d66

### Short Writeup

  1. BUG >> broadcast mailing list sets mail_head->lhead even if lhead is not initialised. Since unlink happens for bmailinglist from in between too, while unlink happens in regular mails in a FIFO manner. 
  
  Intended solve >> 

  2. This gives you an `arbitrary write` of a pointer which points to your `next mail`
  3. Since the regular mails and broadcast mails differ in size, you can write the broadcast mail pointer to the unitialised lhead field. This lets you leak out the pointer by putting it into your payload while unlinking.
  4. Now you have kernel heap leak. With this you can cross cache and you will know the address of the page which you are leaking and thus you can write to that page through the same unlink primitive. But you can still only write the address of your next mail in the box.
  5. Through cross cache you can do many things, but what I used is a lot of calls to `clone()` so that it can break down the order 3 pages to order 0 and then consume many order 0 pages with a bunch of `pipe()` calls. Then unlink write on the pipe to figure out which was our page after which we can release and reclaim it using `setuid()` calls into the cred struct.
  6. Find the address that has a null byte through identifying and rotating the freelists.
  7. Do a bunch of unlinks and null out the uid gid, fsuid etc, and finally make sure your address exists only in the cred->cap_inheritable and securebits field. and pray it does not screw it up.
  8. spawn a shell :) and you are root.
  9. Hoping yall liked the challenge.

### Flag

bi0sctf{1_Th1nk_Chin3se_J0hn_X1na_g3tt1ng_m4inlined_w4s_b3tt3r_19djr37s9kr3291}

### Author
[r0r1](https://x.com/Itsr0r1)