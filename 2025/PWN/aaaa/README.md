# aaaa

### Challenge Description

Your typical bank management system, with improved loan technology.

**Challenge File**:
+ [Primary Link](https://drive.google.com/file/d/1BKdRDV2184fap4hyh6QA497hBRBe1TAh/view?usp=sharing)
+ [Mirror Link](https://mega.nz/file/sHcQWYYR#_Yug0upeTMMLldnqh9cRbvEI_CHwFus4DyMhtcp_gbI)

### Short Writeup

- Race condition in get_balance, which is only exploitable in set_tier as it doesnt have a lock at that time.
- You can use this to type confuse between admin and another account - with the balance field of other accounts overlapping with the secret/reserved field of the admins account.
- You can set the reserve field to whatever value you want, as a float bit pattern to set the balance of the account.
- Abuse the abs(balance/0x10) to get a negative value, as abs(INT_MIN) = INT_MIN
- Next, downgrade the loan tier to get positive oob in libc.
- Get leaks from loan thru transaction log, and use the 2 arb writes to get rce. (I did it by overwriting exit handlers) 

### Flag

bi0sctf{c0nfus3d_r4c3r_fl0w5_0v3r_scjac09823h}

### Author

**SkyLance**
