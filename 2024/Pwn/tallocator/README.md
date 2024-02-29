# Challenge Name

### Challenge Description

Built our enhanced memory allocator, designed specifically for admins and prioritizing both speed and security. Experience the boost in performance firsthand with our website speed tester.

**Challenge File**:
+ [Primary Link](https://drive.google.com/file/d/1NDx4IsIp-01LVrPKhcDwknG7u8v8WFZa/view?usp=sharing)
+ [Mirror Link](https://1drv.ms/u/s!AnRA0IqCqZajjS4tx8DPVuOVOxbC?e=kbC8jA)

**MD5 Hash**: d0baca2761fb0c9f41d5ae5a8f0de571

### Short Writeup

+ native.c: 
    - Program is finding inverse of input matrix 
    - To solve, simply find the inverse of the comparison matrix (following the property (A⁻)⁻ == A)
+ tallocator: 
    - Get the heap offset by allocating something. 
    - Free an arbitrary chunk and insert pointers to point to the metadata (stores the free list).
    - Using the unlink function write a value in the RWX region to get a valid allocation. 
    - Overwrite heap free list pointer to RWX and write the shellcode there. 
    - Finally overwrite the talloc_hook to get flag :P
+ reverse_shell: 
    - create a socket connect to a listening port, then open, read, write the flag contents to the desired socket to leak the flag.
    - It is not possible to get a shell due to the SELinux sandboxed environment.

### Flag

``bi0sctf{y0u_h4v3_t4ll0c3d_y0ur_w4y_thr0ugh_1281624072}``

### Author

**tourpran, k0mi, the.m3chanic**
