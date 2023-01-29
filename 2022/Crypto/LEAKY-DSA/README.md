# LEAKY-DSA

### Challenge description

This challenge is warmup for Crypto ;)

Note: wrap the flag in the format bi0sctf{xxxxx}

### Handout

nc link

### Short-Writeup

The operation is used to extract private keys from ECDSA signatures, given two signatures and the knowledge of a small portion of the private key. It does this by creating a polynomial, finding its roots, and using the roots to calculate the private key. The script also uses the sha256 hash function and the Elliptic Curve Digital Signature Algorithm (ECDSA). The private key is derived from the flag, which is imported from a separate file called secret.py. Finally, it converts the private key from bytes to long and prints the result.

### Flag

bi0sctf{3CC_S1gn1nG_1s_SECCY_6675636b}

### author
victim1307