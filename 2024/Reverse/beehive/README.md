# Challenge Name 
beehive 

### Challenge Description
according to all known laws of aviation, there is no way a bee should be able to fly 

(wrap the key in bi0sctf{})

**Challenge File**
+ [Primary Link](https://drive.google.com/file/d/1xYDKBNOOLx9swKrP74yKg7vAlueLFSVc/view?usp=sharing)
+ [Seconday Link](https://amritauniv-my.sharepoint.com/:u:/g/personal/am_en_u4cse22055_am_students_amrita_edu/EdJd66V9BvNPqC0JQRD3RAUBigGndMFdzZVlyL4TU3zwhA?e=jWgyFD)

**MD5 Hash**
cef430c856b5b0cf609ef557afc18912

### Short Writeup 

+ eBPF program that hooks onto syscall number 0x1337 
+ hooks, then checks for arguments passed to syscall 
+ takes each byte from the argument, then flips its bits (8 padded)
+ checks that against a hardcoded array 

### Flag 
bi0sctf{jus7_4noth3r_us3rn4me@bi0s.in}

### Author 
**the-m3chanic**
