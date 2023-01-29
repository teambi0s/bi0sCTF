# kawaii_vm

### Challenge Description

The VM is only kawaii from the outside T_T

**Challenge File**:
+ [Primary Link](https://drive.google.com/file/d/1aLvzqJAAfvMAsihla2wSGRDEdYFRGvAY/view?usp=sharing)
+ [Mirror Link](https://www.dropbox.com/s/2f7rbx4h9dev5jy/kawaii_vm_handout.zip?dl=0)

**MD5 Hash**: 205b811ed9650f90d79f952f800c1126

### Short Writeup

+ A simple bytecode vm that has 3 general purpose registers and also pc, sp, a stack and an array
+ Selecting custom size of NaN causes array to go OOB
+ Use OOB reads to get stack, libc leaks
+ Craft a fake fastbin chunk on array and write its address in main_arena
+ When reset functionality is used the register context is allocated on the fake chunk
+ overwrite SP to point to actual stack
+ use push and pop functionality to write ropchain on stack
+ halt the machine to execute ropchain

### Flag

bi0sctf{kawaii_vm_n0t_s0_k4wa1i_4ft3r_4ll_f97cf315ea3a}

### Author

[k1R4](https://twitter.com/justk1R4)  