# babybs

### Challenge Description

just a useless bs program which does *nothing* (or does it?).

**Challenge File**:
+ [Primary Link](https://drive.google.com/drive/folders/1PVdK342bp7xNrMoLDDKhjfHlTnzM_UZx?usp=sharing)
+ [Mirror Link](https://www.dropbox.com/scl/fo/v09vnkc6zoi54bbwx0m08/h?rlkey=holjmi8yb5brzvjifu7fncq8q&dl=0)

**MD5 Hash**: 7ef669f869499a25e40ed2bcb264333b

### Short Writeup

+  The program doesnt check for the index, which allows users to do out of bounds writes with the increment and decrement functions.
+  This allows users to modify the instructions, and the flag is written in the binary, 
+  So we need to write shellcode somewhere in the memory first and then overwrite one of the jump instructions to jump to our shellcode. After that the shellcode should print out the flag.

### Flag

bi0sctf{g4s_g4s_g4s_1m_g0nna_st3p_0n_th3_g4s_773048f384}

### Author

**spektre**
