from pwn import xor 

# there are 4 parts to this challenge 
# part 1: 2 byte crc32 brute, 4 such pairs  
# part 2: 8 byte rc4 decryption
# part 3: cyclic xor 
# part 4: byte by byte check 

flag = b""
# first part solve 

def hash(num):
    key = 0xD90B8320
    for i in range(32):
        if num & 1 == 0:
            num = (num >> 1) ^ key
        else:
            num = (num >> 1)
    return num

part_1_pair_1 = 0xcc9d08cb
part_1_pair_2 = 0xf6a29795
part_1_pair_3 = 0x5c12d754
part_1_pair_4 = 0x21563cf9

for i in range(32, 128):
    for j in range(32, 128):
        if hash(i << 8 | j) == part_1_pair_1:
            flag += bytes([i, j])

for i in range(32, 128):
    for j in range(32, 128):
        if hash(i << 8 | j) == part_1_pair_2:
            flag += bytes([i, j])

for i in range(32, 128):
    for j in range(32, 128):
        if hash(i << 8 | j) == part_1_pair_3:
            flag += bytes([i, j])

for i in range(32, 128):
    for j in range(32, 128):
        if hash(i << 8 | j) == part_1_pair_4:
            flag += bytes([i, j])

print("Flag after part 1: ", flag)

# second part solve

def ksa():
    key = b"\xde\xad\xbe\xef\xca\xfe\xba\xbe"
    S = [i for i in range(16)]
    j = 0
    for i in range(16):
        j = (j + S[i] + key[i % len(key)]) % 16
        S[i], S[j] = S[j], S[i]
    return S

def prga(S):
    i = 0
    j = 0
    while True:
        i = (i + 1) % 16
        j = (j + S[i]) % 16
        S[i], S[j] = S[j], S[i]
        K = S[(S[i] + S[j]) % 16]
        yield K

def rc4(plaintext): # key is always 0xdeadbeefcafebabe
    S = ksa()
    keystream = prga(S)
    ciphertext = bytearray()
    for byte in plaintext:
        ciphertext.append(byte ^ next(keystream))
    return bytes(ciphertext)

flag += rc4(b'\x56\x3d\x5c\x64\x7e\x6c\x5f\x7e') # rc4 will return plaintext is ciphertext is passed with the same key

print("Flag after part 2: ", flag)

# third part solve 

xor_key = b'\x43\x5c'
enc = bytearray(b'\x77\x66\x40\x6b\x70\x40\x77\x6d')

enc[-2:] = xor(enc[-2:], xor_key)
enc[-3:-1] = xor(enc[-3:-1], xor_key)
enc[-4:-2] = xor(enc[-4:-2], xor_key)
enc[-5:-3] = xor(enc[-5:-3], xor_key)
enc[-6:-4] = xor(enc[-6:-4], xor_key)
enc[-7:-5] = xor(enc[-7:-5], xor_key)
enc[-8:-6] = xor(enc[-8:-6], xor_key)

flag += bytes(enc)
print("Flag after part 3: ", flag)

# fourth part solve
flag += b'\x64\x65\x5f\x73\x37\x75\x66\x66'

print("Flag after part 4: ", flag)

print(f"Final flag: bi0s{{{flag.decode()}}}")