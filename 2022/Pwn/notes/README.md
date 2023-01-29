# notes

### Challenge Description

Heard of heap notes? this ain't one.

**Challenge File**:
+ [Primary Link](https://drive.google.com/file/d/1hNEtO7rEPNirhYfUwwAXtyNZJnaX0VJT/view?usp=sharing)
+ [Mirror Link](https://www.dropbox.com/s/507i46bb9u52z3h/notes?dl=0)

**MD5 Hash**: 9b356d89cb5126630d245b2b5a90a70c

### Short Writeup

+  ptr->thread2_done is not reset after first run.
+  Store note takes input into buffer, Thread 2 checks size and memcpy from shared memory
+  Double Fetch Race Condition when it tries to memcpy the buffer into msg.
+  Overwrite the size during the race window (after the size check and before the memcpy.)
+  Since the buffer is being encrypted, we send the encrypted payload as input and program decrypts it.
+  bof after memcpy which gives us rip control.
+  Now SROP!.

### Flag

bi0sCTF{D3j4_vu!_1v3_ju5t_b33n_1n_th15_pl4c3_b3f0r3_0b91342067c4}


### Author

[spektre](https://twitter.com/0xspektre)
