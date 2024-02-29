# Challenge Name

Katanaverse 0.0

### Challenge Description

Subject Zero, 

Guess what? We found a secret vault, and it supposedly spills the beans on Chronos. We know you're itching for the truth, so we're handing this over to you.

To crack the vault, think weird. Twist logic, mess with time – you got it. The code is the key, and it's like a puzzle in a wonky dimension.

Please wrap the flag around the given flag format bi0sCTF{...}

**Challenge File**:
+ [Primary Link](https://drive.google.com/file/d/1g6PuFsuXP3fXuZ42BZ58XoQyuNOHYWpB/view?usp=sharing)
+ [Mirror Link](https://amritauniv-my.sharepoint.com/:u:/g/personal/amenu4eac21061_am_students_amrita_edu/EbAl3FLIKiFGsg5zgdFLblQBpArn3bAO2MMmokYFzvLNuA?e=vG0vJg)

**MD5 Hash**: 

katanaverse: *310aa1c0d47b55e367e08906df190356*
dump.dmp: *66a3765685295ea94f5175de939007de*

### Short Writeup

- Input flag converted to base64 and undergoes bit manipulation 
- The entire process is done via a VM, so get the disassembly to figure out the bit manipulation
- The resultant 2D array undergoes quantum gate operations which needs to be bruted with given constraints
- The points obtained are divided through QAOA (Quantum Approximate Optimization Algorithm) 
- The given binary does not serve as flag checker but more like a driver for the entire process, the quantum part needs to be coded by the solver using qiskit module and ran on a quantum server 

### Flag

bi0sCTF{QuBitJugglr}

### Author

**Sejal Koshta: k1n0r4**