# k32

### Challenge Description

32 bytes is all you get, or is it? :-O

**Handout**:
+ [Primary Link](https://drive.google.com/file/d/1yIZkLoY52u3A3fGZqYQzoqOE4LLSpOSN/view?usp=sharing)
+ [Mirror Link](https://www.dropbox.com/s/8ecwjle9pjg8crd/k32_handout.zip?dl=0)

**MD5 Hash**: a18327c48826e40f8b583d8c38d696c3

### Short Writeup

+ Giving size > 48, causes size miscalculation which leads to OOB r/w on heap chuks
+ Use OOB read to leak heap and kernel base
+ Allocate seq_operations struct next to target chunk and use overflow to add gadgets
+ Using gadgets, the stack is moved down which causes RIP to be popped from userland saved registers
+ We get only limited control of RIP, so pivot to heap where we setup ropchain using msg_msg structs
+ Ropchain is used to commit_creds(prepare_kernel_cred(0)) and return to userland

### Flag

bi0sctf{km4ll0c-32_1sn't_3xpl01tabl3_r1gh7_guy5?_3feb178d2a9c}

### Author

[k1R4](https://twitter.com/justk1R4)