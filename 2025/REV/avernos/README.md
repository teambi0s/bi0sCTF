# Avernos 

## Challenge Description
An ancient engine stirs in the dark. It speaks no language you know. 

### Challenge File
- [Primary Link](https://drive.google.com/file/d/1FA2vuY9KVhMii1e8DaSf300dLSfDKJwY/view?usp=sharing)
- [Mirror Link](https://drive.google.com/file/d/1FA2vuY9KVhMii1e8DaSf300dLSfDKJwY/view?usp=sharing)

**MD5 Hash: 7ececdb3b42e02c4b1e29eadcebfc943**

## Short Writeup 
- Mixed mode assembly to hide various anti-debug checks in unmanaged code 
- Looks for `flag.txt` file in the user's system in a random path (which obviously will not exist), triggers exception 
- SEH trampoline to hide control flow which leads to calling managed code, which gets input 
- Managed code gets input, passes it to unmanaged code again 
- Unmanaged code sets up VM, passes the input received for verification 
- VM checks flag in 4 parts: 
    - Part 1: 2 byte x 4 check using CRC32 hash 
    - Part 2: 8 byte check using RC4 encrypt 
    - Part 3: 8 byte check using a rolling XOR 
    - Part 4: 8 byte check against constant flag bytes 


## Flag
`bi0s{m1x_m0d3_4_fun_w4y_to_h1de_s7uff}`

## Author 
[the.m3chanic](https://x.com/the_m3chanic_)
