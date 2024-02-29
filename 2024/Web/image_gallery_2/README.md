# Image gallery 2

### Challenge Description

This time we have built a more secure version. Pls don't hack

use:
chrome://flags/#unsafely-treat-insecure-origin-as-secure
and add challenge host 

**Challenge File**:
+ [Primary Link]()
+ [Mirror Link]()

**MD5 Hash**: 16dbbaec650348bb7ffd3e01717eb154

### Short Writeup

+ Abuse partial caching in nginx to truncate id 
+ use script integriti and use dom clobbering to load matching js files
+ Use image cache probing to exfill chars

### Flag

bi0sctf{Wh3n_client_s1de_ch4ch1ng_m3t_s3rv3r_sid3_ch4ch1ng}

### Author

[ma1f0y](https://twitter.com/mal_f0y)