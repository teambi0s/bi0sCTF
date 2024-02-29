# BFS

### Challenge Description

-[------->+<]>-.-[--->+<]>++.+.-----------.--[--->+<]>-.--[->++++<]>+.----------.++++++.-[---->+<]>+++.++[--->++<]>.---.++.------.--[--->+<]>-.[->+++<]>++.[--->+<]>----.+++[->+++<]>++.++++++++.+++++.--------.---[->+++<]>+.-[--->+<]>.++++++++.-[++>---<]>+.---[->++<]>.++++++++++.

**Challenge File**:
+ [Primary Link](https://drive.google.com/file/d/1ezrfqxKfrq3LtOpZi4b7_vauXcnfUbJh/view?usp=sharing)
+ [Mirror Link](https://1drv.ms/u/s!AlEp2QnTDJwM603AbtNMhWkoAlUt?e=4l5TdS)

**MD5 Hash**: 2ba3ba906f6ccfd97617f1cfd8514f5e

### Short Writeup

+ For each of the following you have to write a code in brainf*ck :
+ First level is to bring the flag from an arbitrary byte to the original dp position to leak the byte.
+ Second level is to mark the flag bytes using the . Instruction and finally on marking every byte correctly you get the next part of the flag.
+ Third level is to leak the flag byte by doing a division and modulus operation and moving the dp as much as the result to leak the corresponding result of the division or modulus and thus leak the flag through 2 tries doing each of the operations one-bye one each try.

### Flag

bi0sctf{M4yb3_I_M1sint3rpret3d_th3_t3rm_Tur1ng_c0Mplet3}

### Author

**[R0R1](https://twitter.com/adudewhodr23891)**
