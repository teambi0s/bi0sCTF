#!/usr/bin/python3

from pwn import *

io = remote("localhost" ,5555)
f = open("./exp.js", "r")
data = f.read()
io.sendlineafter(">>", str(len(data)))
io.sendafter(">>", data)
io.interactive()
