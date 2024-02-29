# Predictable
## Category: `Crypto`
## Difficulty: `Medium`

## Description

Can you help me test out this PRNG I implemented? I'm inserting a backdoor, but I'm sure you can't find it.
Oh btw, I did some optimizing, so version 2 is faster. You can still try out version 1 though. They're the same anyway. 

## Handout
- nc link

`Flag format: bi0sctf{...}`

## Short writeup

Side channel attack on the Double-and-Add algorithm. Bits can be recovered based on timing. 
After recovering the relationship between P and Q, it's Dual EC DRBG backdoor.
See [here](https://eprint.iacr.org/2015/767.pdf)

## Author
- Mohith LS

### Flag: bi0sctf{w3_l0v3_oUr_b4ckd00r5}