# Unintialized VM 

### Challenge Description

Gang have you init a VM in your life?

**Challenge File**:
+ [Primary Link](https://drive.google.com/file/d/13_eYH-61sVpUBCrQSD9eYw_8JDLwhWU8/view?usp=sharing)
+ [Mirror Link](https://drive.google.com/file/d/13_eYH-61sVpUBCrQSD9eYw_8JDLwhWU8/view?usp=sharing)

### Short Writeup

- Wait for VM to init.
- Expand VM and use memcpy size overflow to copy unsorted bin pointers onto VM stack.
- Operate on pointers and copy to reg struct chunk to overwrite VM stack bp and sp.
- Relocate VM stack over environ to leak stack address.
- Relocate VM stack over process stack to ovewrite return and write payload.

### Flag

bi0sctf{1ni7ia1i53_Cr4p70_pWn_N3x7_5$67?!@&86}

### Author

**B4tMite**
