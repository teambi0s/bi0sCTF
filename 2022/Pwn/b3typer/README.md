# b3typer

### Challenge Description

Typer bugs are easy to exploit, right?

**Challenge Files** 

+ [Primary Link](https://drive.google.com/file/d/1N15pe7jRbVWEwahUse71d4vHWqaXdrJc/view?usp=sharing)
+ [Mirror Link](https://www.dropbox.com/s/uelghnql78hn2g5/b3typer_handout.zip?dl=0)

**MD5 Hash**: f6adb6103fe2abf9ca6eb0ee18010f79

### Short Writeup

+ Simple typer bug, range of BitAnd opcode is assumed to be [1, operand] when in reality it is [0, operand].
+ Use range assumptions to create unchecked integer underflow.
+ Bypass array bounds checks and obtain OOB write, overwrite size of array to get overlap.
+ Use double & object array overlap to create addrOf & fakeObj primitives.
+ Create overlapping fake array using StructureID leak to obtain arbitrary R/W.

### Flag

`bi0s{typ3r_expl01ts_b3_ez_d33e42198c98}`

### Author

[DarkKnight](https://twitter.com/_d4rkkn1gh7)
