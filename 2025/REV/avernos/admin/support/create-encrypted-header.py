import random

# === config ===
INPUT_BIN = "instructions.bin"
OUTPUT_HEADER = "instructions_array.h"
KEYS = [0x42, 0x7F, 0x13]

with open(INPUT_BIN, "rb") as f:
    raw = list(f.read())

def encrypt_instruction(instruction):
    instruction = (((instruction >> 4) | (instruction << 4)) & 0xff)
    instruction = (instruction ^ 0x42) & 0xff
    return instruction

data = bytearray(raw)
# print(data)
for i in range(len(data)):
    data[i] = encrypt_instruction(data[i])

with open(OUTPUT_HEADER, "w") as f:
    f.write("unsigned char embedded_instructions[] = {\n")
    for i, byte in enumerate(data):
        f.write(f"0x{byte:02x}, ")
        if (i + 1) % 16 == 0:
            f.write("\n")
    f.write("\n};\n")
    f.write(f"const int embedded_instruction_length = {len(data)};\n")