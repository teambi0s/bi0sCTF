# ഓണസദ്യ

### Challenge Description

പരിപ്പ്, പപ്പടം, നെയ്യ്, സാമ്പാര്‍, കാളന്‍, രസം, മോര്, അവിയല്‍, തോരന്‍, എരിശ്ശേരി, ഓലന്‍, കിച്ചടി, പച്ചടി, കൂട്ടുകറി, ഇഞ്ചി, നാരങ്ങ, മാങ്ങാ അച്ചാറുകള്‍, പഴം നുറുക്ക്, കായ വറുത്തത്, ശര്‍ക്കര വരട്ടി, അടപ്രഥമന്‍, പാലട, പരിപ്പ് പ്രഥമന്‍, സേമിയ പായസം, പാല്‍പ്പായസം തുടങ്ങിയവയാണ് ഓണസദ്യയിലെ വിഭവങ്ങള്‍.

**MD5 Hash**: 64767df8fbdf83b13e20c6c5dbfce8b3

### Short Writeup

+ Challenge uses custom hashing algorithm
+ Understand that and reduce the number of possible characters 
+ brute input to match the right input part
+ signal handler creates and calls another file which checks password and 2nd part of input
+ find key and password and chacha20 decrypt to get the password
+ Solve the final vm to get the 2nd part of the username 

### Flag

bi0sctf{ShrlkCheetzul1kesT4llWom3n_l4d1eS-m4n-2i6-fr}

### Author

Cheetzu