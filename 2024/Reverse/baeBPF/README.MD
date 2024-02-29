# baEBPF

### Challenge Description
eBPF?? What is that??? wrap flag with bi0sctf{}

**Challenge file**

### MD5 Hash

**c2a272124e5270a8dcac9bdf60b69740f55f06138054f30a1ae3d7fe017042dc**

### Short Writeup

+ nc challenge, 2 levels, first level is bytebyte xor to get the password and then get the file name, understand it from the assembly dump. 
+ Second level is dumping the TEA encrypted output of another python file. Decrypting it will give us another optimisation level. 

### Flag

bi0sctf{eBPF_wtF_1s_th4t???}

### Author

**Sherlock Cheezu**