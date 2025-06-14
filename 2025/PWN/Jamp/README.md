# JAMP

### Challenge Description

`J`ust `A`nother `M`IDI `P`arser init ? :D 
Just send in a file and we will parse it through. 

**Challenge File**:
+ [Primary Link](https://drive.google.com/file/d/18vqTB5agiQR8guc-y0wI0mRny_rM11Zy/view?usp=sharing)

**MD5 Hash**: 
6b4b568ecc18011a6f8f5031af785748

### Short Writeup

- Parser has an OOB increment bug, which can be used to increment vector and make writes across the heap
- Since it is a leakless challenge the user can change the vector to copy bytes from one region to another
- Using that they can edit the file structure and get shell on the file calling fclose() on exit

### Flag

bi0sctf{J4mp1ng_Ar0und_T7e_H34p_bl1nd_:D_Z2dzIG1hdGUg}

### Author
[r0r1](https://x.com/Itsr0r1)