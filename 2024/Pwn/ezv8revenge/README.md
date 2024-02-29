# ezv8 revenge

### Challenge Description

Looks like we have some reliability issues here; what could possibly go wrong?

**Challenge File**:
+ [Primary Link](https://drive.google.com/file/d/1tsllJSyfe_e1qJ-f7H7rE44ejEZuEgDS/view?usp=sharing)
+ [Mirror Link](https://www.dropbox.com/scl/fi/h8wm8rh5cg9iy3xn2b1mt/ezv8revenge.tar.gz?rlkey=4muo23zhd1lhcop5yahgmjr39&dl=0)

**MD5 Hash**: 8fe2928a17c59bedc4a08ab30a71c2bb

### Short Writeup

+  The vulnerability lies in the InferMapsUnsafe function in node-properties.cc. This function aims to determine if the Map of the target object (the receiver) is reliable. It traverses the effect chain until it finds the source of the Map.
+ if a JSCreate node is encountered which is not the source of the Map, the Map is incorrectly not marked as unreliable, where JSCreate can have side effects.
+ This can be done by passing a Proxy as the third argument to Reflect.construct(), which is reduced to a JSCreate node in JSCallReducer::ReduceReflectConstruct in the inlining phase. 
+ Thus, the Map of the object is not checked after it is modified, leading to type confusion and heap corruption.
+ The out of bounds read/write can then be used to overwrite the length field of another array .
+ After overwriting length, we get addrof and oob read/write primitives.
+ To escape the v8 ubercage, we overwrite the rwx pointer of wasm instace object with an arbitrary address and then call the exported function which will try to locate the exported function and calls the arbitrary address instead.
+ wasm code stores raw float literals in the compiled assembly instructions, so we smuggle our shellcode in the float literals and then call the exported function to execute the shellcode.
+ Write execve(/bin/sh) shellcode and overwrite the rwx pointer of wasm instance object and jump in between the float literals to execute the shellcode.

### Flag

bi0sctf{w3ll_d3f1n1t3ly_4_sk1ll_i55u3_1f3738f8}

### Author

**spektre**
