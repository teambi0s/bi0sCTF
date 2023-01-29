# Rusted

### Challenge Description

Retrieve the key to this binary.
flag format: bi0s{}

**Challenge File**:
+ [Primary Link](https://drive.google.com/file/d/1Ho0nDSVgGhMf-FqLVa_NapzDAFsjOAV7/view?usp=share_link)
+ [Mirror Link](https://mega.nz/file/rQdVRDKR#3mOuDhVkd6WIrQA1MetC7y4PS3JKckMf4mFo_gqc_rs)

**MD5 Hash**: d4aafb5a945af67530fe0daa0c3f92ec

### Short Writeup

+  The chall uses SM4 encryption to encrypt the input.
+  The encrypted input is then checked using a simple JIT
+  The check uses the following equations:
    + `e1 = enc[0:4] - [0x93, 0xa3, 0xf3, 0xcd]`
    + `e2 = e1 + enc[4:8] - ([0x13, 0x37, 0xbe, 0xef] ^ [0x33, 0xae, 0xf5, 0xcb])`
    + `t1 = e2 + enc[8..12]`
    + `e3_1 = (t1 ^ enc[12:16]) - [0x5f, 0x97, 0x51, 0xeb]`
    + `e3_2 = (t1 ^ enc[16:20]) - [0x55, 0x0d, 0x68, 0xce]`
    + `e3 = e3_1 + e3_2`
    + `t2 = e3 + enc[20:24]`
    + `t3 = e3 + enc[24:28]`
    + `e4_1 = (t2 ^ enc[28:32]) - [0x04, 0xaa, 0x34, 0xa4]`
    + `e4_2 = (t3 ^ enc[28:32]) - [0x2c, 0x78, 0x65, 0x53]`
    + `e4 = e4_1 + e4_2`
    + `e5_1 = (enc[8..12] ^ enc[12:16] ^ enc[16:20]) - [0x74, 0x18, 0x00, 0x51]`
    + `e5_2 = (enc[20:24] ^ enc[24:28] ^ enc[28:32]) - [0x3e, 0x07, 0x99, 0x4c]`
    + `e5 = e4 + e5_1 + e5_2`
+ The `e5` is then checked if it is equal to 0
+ After determining `enc`, you can use SM4 CBC decryption to extract the key and IV from binary. 


### Flag

bi0s{jitrustyjeRPUGEbTa}

### Author

fug1t1ve