# Lowkey Encryption 

Welcome to the Reversing Conundrum! This is a challenge that will test your skills in decoding and decrypting the most enigmatic of messages. A secret message has been encoded, and it's up to you to unravel the mystery and reveal the hidden truth. You'll just need to keep your wits about you to navigate through the maze of encryption. Are you ready to take on this challenge and unlock the secrets of the encoded message? The clock is ticking, so don't waste any time, and good luck!

## Challenge File:
[Primary Link](https://gitlab.com/teambi0s/bi0sctf/2022/rev/lowkeyEnc/-/blob/main/Handout/lowkeyEnc)

**MD5 Hash** : f0a011958ceedf45e6de432d222173e5

## Short Writeup:
This code is a combination of AES encryption in CBC mode and XOR encryption. The CBC256 struct holds the key and initialization vector (IV) for AES encryption. The EncryptByCBC() function encrypts the plaintext using AES in CBC mode by creating a new cipher block using the key, padding the plaintext using PKCS7, creating a new cipher block mode using the cipher block and IV, and encrypting the padded plaintext using the cipher block mode. The PadByPkcs7() function pads the plaintext using PKCS7 padding scheme. The parallel_encrypt() function encrypts the plaintext using AES in CBC mode in parallel. The xor_encrypt() function encrypts the data using XOR encryption by creating a new slice of bytes with the length of the plaintext, XORing each letter with a multiple of its ASCII value, and returning the encrypted data. The byteArrayToImage() function converts a byte array to an image by creating a small white image, filling it with white, and appending the data to the image at the last row.


## Flag
``bi0sCTF{Th3_fl4gs_l0wk3y_3ncryp7i0n_b3li3s_i7s_f0rmid4bl3_c1ph3r}``

## Authors

**Prabith Gupta**: Ad0lphus#5116
