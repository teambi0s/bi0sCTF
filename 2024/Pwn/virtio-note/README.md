# virtio-note

### Challenge Description

Heap notes have become very repitive :(\
How about adding a *few* layers of ~~abstraction~~ fun in between :D

**Challenge File**:
+ [Primary Link](https://drive.google.com/file/d/1I9pJ0NkPvIsPIiNETnJcb9Qs1Vbff-nY/view?usp=sharing)
+ [Mirror Link](https://1drv.ms/u/s!AuMSH5328nQ7hFxwzqpu9-Y95q6q?e=kwG0JB)

**MD5 Hash**: 3dbdd23335e589f7f6623ea3cf526a26

### Short Writeup

+ A basic virtio device with +ve OOB pointer access
+ Use OOB to get heap leak of neighborhood
+ Calculate VirtIONote object's address from leak
+ Setup arbitrary r/w primitive
    - Write pointer array address to a pointer
    - Use appropriate index to acess pointer array as a pointer
    - Write required address to pointer array
    - Dereference the pointer on pointer array for r/w
+ Leak address of virtqueue through vnote->vnq
+ Read code pointer in VirtIONote for PIE base leak
+ Place open,read,write ropchain on heap
+ Place ropchain to pivot to first chain, at start of vnote->parent_obj
+ Overwrite vnote->vnq->handler with stack pivoting gadget
+ Profit

### Flag

bi0sctf{virt10_n0t3_b3tt3r_7han_h34p_n0t3_51a15b2f}

### Author

**k1R4**  
