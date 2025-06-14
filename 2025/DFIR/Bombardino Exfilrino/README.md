# Bombardino Exfilrino

## Challenge Description 
```
Once connected to a well-known drug business, some files were found in an abandoned outpost. It is thought to include private information related to a current probe into a possible cartel. Shortly after discovering anomalies in a clandestine operation, the primary investigator disappeared. You, Joe Mama being the best Forensic Investigator alive, is the last hope to close up the case.
```

**Challenge File**

- [Primary Link](https://drive.google.com/file/d/1y7KfcxCkfCocIOjWOm5_Hc2y1Qn9JzJ_/view?usp=sharing)
- [Mirror Link](https://drive.google.com/file/d/1iom1RZW88Xy9DW9yTTlvveWDjWVSOnhS/view?usp=sharing)

**MD5 Hash :** 

```
ba0b9f65ed70d9a7a3de753caa4418ad  chall1.E01
            
714410f62ad1bf89a3fdef40ae7cf5cc  chall2.E01
```

### Short Writeup

- RAID reconstruction using UFS/disk drill to reconstruct the parity storage pool created.
- Analyse the files present in the file system including a drone log to find the path to see where the droppoints were.
- Zeek log of the data exfiltrated from the system via dns exfiltration, scripted and to be reconstructed.

### Flag

```
bi0sctf{n07_4_g4m3_m0m_17s_f0r3ns1cs_92maj420}
```

### Author

**[kr4z31n](https://x.com/kr4z31n),[rudraagh](https://x.com/Rudraagh),[m1m1](https://x.com/__m1m1__1)**