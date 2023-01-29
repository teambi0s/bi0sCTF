#include <stdio.h>
#include <sys/mman.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#include <byteswap.h>
typedef uint8_t byte;
typedef uint32_t Dword;
typedef uint64_t Qword;

Dword dump[] =
  { 53, 0, 53, 3, 62, 53, 3, 53, 3, 62, 53, 3, 62, 53, 3, 62, 53, 0, 53, 3,
62, 53, 3, 62, 53, 3, 62, 53, 3, 53, 3, 62, 53, 0, 53, 3, 62, 53, 3, 62, 53, 3, 53, 3,
62, 53, 0, 53, 3, 62, 53, 3, 62, 0x30, 0, 3, 0x31, 0, 3, 0x3d, 3, 0x30, 0, 3, 0x31, 0,
3, 0x3d, 3, 0x30, 0, 3, 0x30, 0, 3, 0x3d, 3, 0x30, 0, 3, 0x30, 0, 3, 0x31, 0, 3, 0x3d,
3, 0x3e, 0x36, 0, 3, 0x36, 0, 3, 0x36, 0, 3, 0x36, 0, 3, 0x40 };

int ind;

typedef Qword (dynamic_function) ();

Dword p1, p2, p3, p4, p5, p6, p7, p8, p9;

enum regs
{ RAX, RCX, RDX, RBX, RSP, RBP, RSI, RDI };

void
set (byte * flag)
{
  p1 = bswap_32 (*((Dword *) & (flag[0x8])));
  p2 = bswap_32 (*((Dword *) & (flag[0xc])));
  p3 = bswap_32 (*((Dword *) & (flag[0x10])));
  p4 = bswap_32 (*((Dword *) & (flag[0x14])));
  p5 = 0x7eff4b91;
  p6 = 0x1ef6e9eb;
  p7 = 0x34cc1889;
  p8 = 0x68e54823;
  p9 = 0x11226d6a;

}

void *
allocate_memory ()
{
  void *addr =
    mmap (NULL, 4096, PROT_EXEC | PROT_READ | PROT_WRITE,
	  (MAP_PRIVATE | MAP_ANON), -1, 0);

  if (addr == MAP_FAILED)
    return NULL;

  return addr;
}

int
funcfree (void *mem, size_t len)
{
  return munmap (mem, len);
}

#define emit_type(i,type)          *(type*)(*addr) = i; *addr += sizeof(type)
#define emit_byte(i)               emit_type(i, byte)
#define emit_int(i)                emit_type(i, Dword)
#define emit_qword(i)                emit_type(i, Qword)

void
add_rr (byte ** addr, enum regs r1, enum regs r2)
{
  emit_byte (0x48);
  emit_byte (0x01);
  emit_byte (0xC0 | r2 << 3 | r1);
}

void
sub_rr (byte ** addr, enum regs r1, enum regs r2)
{
  emit_byte (0x48);
  emit_byte (0x29);
  emit_byte (0xC0 | r2 << 3 | r1);
}

void
and_rr (byte ** addr, enum regs r1, enum regs r2)
{
  emit_byte (0x48);
  emit_byte (0x21);
  emit_byte (0xC0 | r2 << 3 | r1);
}

void
or_rr (byte ** addr, enum regs r1, enum regs r2)
{
  emit_byte (0x48);
  emit_byte (0x09);
  emit_byte (0xC0 | r2 << 3 | r1);
}

void
xor_rr (byte ** addr, enum regs r1, enum regs r2)
{
  emit_byte (0x48);
  emit_byte (0x31);
  emit_byte (0xc0 | (r2 << 3) | r1);
}

void
mov_rr (byte ** addr, enum regs r1, enum regs r2)
{
  emit_byte (0x48);
  emit_byte (0x89);
  emit_byte (0xc0 | (r2 << 3) | r1);
}

void
test (byte ** addr, enum regs r1, enum regs r2)
{
  emit_byte (0x48);
  emit_byte (0x85);
  emit_byte (0xc0 | (r2 << 3) | r1);
}

void
mov_ri (byte ** addr, enum regs r1, Qword num)
{
  emit_byte (0x48);

  if (num > 0x7fffffff)
    {
      emit_byte (0xb8 | r1);
      emit_qword (num);
    }
  else
    {
      emit_byte (0xc7);
      emit_byte (0xc0 | r1);
      emit_int (num);
    }
  //emit_byte(0x0f); emit_byte(0xc0 | (r1 + 8));
}

void
dec (byte ** addr, enum regs r1)
{
  emit_byte (0x48);
  emit_byte (0xff);
  emit_byte (0xc0 | (r1 + 8));
}

void
mul_rr (byte ** addr, enum regs r1)
{
  emit_byte (0x48);
  emit_byte (0xf7);
  emit_byte (r1 | 0xe0);
}

void
div_rr (byte ** addr, enum regs r1)
{
  emit_byte (0x48);
  emit_byte (0xf7);
  emit_byte (r1 | 0xf0);
}

void
push (byte ** addr, enum regs r1)
{
  emit_byte (0x48);
  emit_byte (0x50 | r1);
}

void
pop (byte ** addr, enum regs r1)
{
  emit_byte (0x48);
  emit_byte (0x58 | r1);
}

void
jne (byte ** addr, byte offset)
{
  emit_byte (0x75);
  emit_byte (offset);
}

void
leave (byte ** addr)
{
  emit_byte (0x48);
  emit_byte (0xC9);
  emit_byte (0x48);
  emit_byte (0xC3);
}

bool
check_1 (byte * flag)
{
  return !(memcmp (flag, "bi0sCTF{", 8));
}
