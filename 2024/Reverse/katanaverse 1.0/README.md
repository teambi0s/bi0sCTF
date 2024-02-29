# Challenge Name

Katanaverse 1.0

### Challenge Description

Yes, that should work. 

**Challenge File**:
+ [Primary Link](https://drive.google.com/file/d/1qXQF3D-dxid70F2T0F2fjRL_V5268WQc/view?usp=sharing)
+ [Mirror Link](https://amritauniv-my.sharepoint.com/:u:/g/personal/amenu4eac21061_am_students_amrita_edu/EUTYfwzRq5NPtYZ1NtSKMAMBqQeHfR2x_lUTFPdCamoHmw?e=oV8Dpq)

**MD5 Hash**: 

katanaverse1.0: *c86e0909a1f1d0296d58c059a02bbeed*; 
1_dump.dmp: *de7024faaf03edc69c2e52ee9aa95f9f*

### Short Writeup

- Input flag converted to base64 and undergoes bit manipulation 
- The entire process is done via a VM, so get the disassembly to figure out the bit manipulation
- The resultant 2D array undergoes quantum gate operations which needs to be bruted with given constraints
- The points obtained are divided through QAOA (Quantum Approximate Optimization Algorithm) using brute method
- The given binary does not serve as flag checker but more like a driver for the entire process, the quantum part needs to be coded by the solver using qiskit module and ran on a quantum server 

### Flag

bi0sctf{q_cmptng-is_fun}

### Author

**Sejal Koshta: k1n0r4**; 
**Suraj Kumar: the.m3chanic**; 
**Chandra B Nair: Sherlock Cheezu**
