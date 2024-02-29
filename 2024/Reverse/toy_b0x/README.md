# T0Y_box
## Category: `Crypto/Rev`
## Difficulty: `Easy`

## Description

All my toys are shuffled. 

## Handout
- [chall](./handout/chall)
- [ciphertext](./handout/ciphertext.txt)

`Flag format: bi0sctf{...}`

## Short writeup
The SubBytes step is the non-linear part of AES, and is what makes it resistent to linear attacks. The standard SBOX of AES was designed with this in mind. In this binary, we use a linear sbox.

$SBOX[i \oplus j \oplus 0] = SBOX[i] \oplus SBOX[j] \oplus SBOX[0]$


See [here](https://kevinliu.me/posts/linear-cryptanalysis/)

## Author
- Sans, the.m3chanic

### Flag: bi0sctf{L1n34rly_Un5huffl3d_T0y5}