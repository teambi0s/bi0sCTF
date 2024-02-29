# required notes revenge

### Challenge Description

Every CTF requires an overly complicated notes app. Actually overly complicated this time

**Challenge File**:
+ [Primary Link](./handout/chall.zip)
+ [Mirror Link](./handout/chall.zip)

**MD5 Hash**:
b65b3cbc48737e270df52c2385e4fdbf 

### Short Writeup

+ prototype pollution in protobufjs 
+ use require gadget to pollute name and exports to make Healthcheck note load attacker note when "require"d
+ bypass check by making use of the fact that relativeResolveCacheIdentifier once added is not deleted when cache is cleared.
+ use ssleaks with `<object>` tag to leak admin note id using the `/search` endpoint.

### Flag

bi0sctf{dynamic_flag}

### Author

[ZePacifist](https://twitter.com/ZePacifist)