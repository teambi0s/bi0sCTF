# bad2code

### Challenge Description

Description goes here: none

**Challenge File**:
+ chall.py
+ ct.txt

### Short Writeup

+ It appears that this code is attempting to decrypt a list of encrypted integers (ct) using a variant of the Merkle-Hellman knapsack cryptosystem. The decrypt function takes an encrypted integer ct and returns the decrypted value by solving a system of linear equations in modular arithmetic using the solve_linear_mod function. The decrypted integers are then processed with a linear congruential generator (LCG) by applying an unknown function load with the argument.

### Flag

bi0sctf{lcg_is_good_until_you_break_them_!!}

### Author

**victim1307**