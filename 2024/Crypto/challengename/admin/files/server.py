#!/bin/python3

from ecdsa.ecdsa import curve_256, generator_256, Public_key, Private_key
from ecdsa import ellipticcurve
from hashlib import md5
import random
import os
import json

flag = open("flag", "rb").read()[:-1]

magic = os.urandom(16)

p = 0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff
a = curve_256.a()
b = curve_256.b()
G = generator_256

q = G.order()

def bigsur(a,b):
    if len(a) < len(b):
        a,b = b,a
    return bytes([i ^ j for i,j in zip(a,bytes([int(bin(int(b.hex(),16))[2:].zfill(len(f'{int(a.hex(), 16):b}'))[:len(a) - len(b)] + bin(int(b.hex(),16))[2:].zfill(len(bin(int(a.hex(), 16))[2:]))[:len(bin(int(a.hex(), 16))[2:]) - len(bin(int(b.hex(), 16))[2:])][i:i+8], 2) for i in range(0,len(bin(int(a.hex(), 16))[2:]) - len(bin(int(b.hex(), 16))[2:]),8)]) + b)])

def bytes_to_long(s):
    return int.from_bytes(s, 'big')

def genkeys():
    d = random.randint(1,q-1)
    pubkey = Public_key(G, d*G)
    return pubkey, Private_key(pubkey, d)

def sign(msg,nonce,privkey):
    hsh = md5(msg).digest()
    nunce = md5(bigsur(nonce,magic)).digest()
    sig = privkey.sign(bytes_to_long(hsh), bytes_to_long(nunce))
    return json.dumps({"msg": msg.hex(), "r": hex(sig.r), "s": hex(sig.s)})

def enc(privkey):
    x = int(flag.hex(),16)
    ysqr = (x**3 - 3*x + b) % p
    y = pow(ysqr, (p+3)//4, p)
    Q = ellipticcurve.Point(curve_256, x, y)
    T = privkey.secret_multiplier*Q
    return (int(T.x()), int(T.y()))

pubkey, privkey = genkeys()
print("Public key:",(int(pubkey.point.x()),int(pubkey.point.y())))
print("Encrypted flag:",enc(privkey))

nonces = set()

for _ in '01':
    try:
        msg = bytes.fromhex(input("Message: "))
        nonce = bytes.fromhex(input("Nonce: "))
        if nonce in nonces:
            print("Nonce already used")
            continue
        nonces.add(nonce)
        print(sign(msg,nonce,privkey))
    except ValueError:
        print("No hex?")
        exit()