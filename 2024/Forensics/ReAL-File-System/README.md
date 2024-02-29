# ReAL-File-System

### Challenge Description

In a desperate bid to synchronize my PC clock, I unwittingly downloaded an application that promised a quick fix but instead wrought havoc by encrypting all my important files. Turning to my DFIR friend for help, his attempts to decipher the encrypted mess only worsened the situation, leaving the filesystem corrupted. My friend told me that only a DFIR expert can help recover my files. I'm filled with hope for their assistance in fixing my computer catastrophe.

**Challenege File**:

- [Primary Link](./handout/chall.zip)
- [Mirror Link ](./handout/chall.zip)

**MD5 Hash**:
3652018eef0bece67b7a8c8fa6e1a232

### Short Writeup

- LCN of **Superblock** and **CheckPoint** are corrupt. Calculate the correct one and overwrite it.
- Extract the log files
- Analyse the redo log records and check the opcodes
- Examine the transactions to locate the `filename` and `timestamp`.
- Load the filesystem in `Active Disk Editor` and carve out the files.
- Find the rename `timestamp` to get **key1**.
- Find the `orig filenames` to brute and find **Salt** and **key2**.

### Flag

**bi0sctf{ReAL_1_w0nd3r_wHa7_t1m3_is_17_14dbc653fdb414c1d}**

### Author

**5h4rrK**
