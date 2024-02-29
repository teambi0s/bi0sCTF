# kowaiiVm

### Challenge Description

I fear no man, but that thing..., JIT, it scares me

**Challenge File**:
+ [Primary Link](https://drive.google.com/file/d/1IrOWMeicU5EAoYSlYiBpIuvEoxFO88Yp/view?usp=sharing)
+ [Mirror Link](https://1drv.ms/u/s!AuMSH5328nQ7hFtWNNY7QvbsY-D0?e=0zZuwb)

**MD5 Hash**: 71875377feb8982f64469d8653e85bd5

### Short Writeup

+ PC overflows into rw region
+ JIT compiler assumes that function is safe since it already ran n times
+ Modify bytecode at runtime using set instruction
+ During JIT, modified bytecode is interpreted differently
+ The ret at the end is considered as part of previous instruction
+ Place bytecode with no restrictions following the ret
+ Place ROP gadgets as immidiate argument for mov
+ Use push to place ropchain on stack & finally ret to execute
+ Profit

### Flag

bi0sctf{4ssump7i0ns_4r3nt_4lw4y5_tru3_811f079e}

### Author

**k1R4**  
