# badNotes

### Challenge Description

no hack pls

**Challenge File**:
+ [Primary Link](./Handout/chall.zip)
+ [Mirror Link](./Handout/chall.zip)

**MD5 Hash**: 879f1e93b7bd2e1a784aec0382af2ca7

### Short Writeup/exploit

+  File system caching, serialized cache files stored in the cache directory
+  File write exists, use file write to over write cache files with pickle rce payload (deserialization)
+  Can't access cache files directly, overwrite fd of cache files instead
+  Race condition to open a write access cache file fd and overwrite cache file

### Flag

bi0sctf{b3_c4r3ful_w1th_p1ckl3ss}

### Author

[sk4d](https://twitter.com/RahulSundar8)