from hashlib import md5
from math import gcd
from pwn import *
import json

io = remote("localhost",int(1337))

P = eval(io.recvline()[12: ])
Enc = eval(io.recvline()[16: ])
p = 0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff

coll1 = "4dc968ff0ee35c209572d4777b721587d36fa7b21bdc56b74a3dc0783e7b9518afbfa200a8284bf36e8e4b55b35f427593d849676da0d1555d8360fb5f07fea2" 
coll2 = "4dc968ff0ee35c209572d4777b721587d36fa7b21bdc56b74a3dc0783e7b9518afbfa202a8284bf36e8e4b55b35f427593d849676da0d1d55d8360fb5f07fea2" 

io.sendlineafter(b"Message: ",b"a".hex())
io.sendlineafter(b"Nonce: ",coll1 + "00" * 16)

t1 = json.loads(io.recvline())

io.sendlineafter(b"Message: ",b"b".hex())
io.sendlineafter(b"Nonce: ",coll2 + "00" * 16)

t2 = json.loads(io.recvline())


def recover(p, x1, y1, x2, y2):
    a = pow(x1 - x2, -1, p) * (pow(y1, 2, p) - pow(y2, 2, p) - (pow(x1, 3, p) - pow(x2, 3, p))) % p
    b = (pow(y1, 2, p) - pow(x1, 3, p) - a * x1) % p
    return int(a), int(b)

def solve_congruence(a, b, m):
    g = gcd(a, m)
    a //= g
    b //= g
    n = m // g
    for i in range(g):
        yield (pow(a, -1, n) * b + i * n) % m
        

def attack(n, m1, r1, s1, m2, r2, s2):
    for k in solve_congruence(int(s1 - s2), int(m1 - m2), int(n)):
        for x in solve_congruence(int(r1), int(k * s1 - m1), int(n)):
            return int(k), int(x)
            
m1 = int(md5(bytes.fromhex(t1["msg"])).hexdigest(),16)
r1 = int(t1["r"],16)
s1 = int(t1["s"],16)

m2 = int(md5(bytes.fromhex(t2["msg"])).hexdigest(),16)
r2 = int(t2["r"],16)
s2 = int(t2["s"],16)

a,b = recover(p,P[0],P[1],Enc[0],Enc[1])
print(a,b)
E = EllipticCurve(GF(p),[a,b])
n = E.order()

P = E(P)
Enc = E(Enc)
print("--------------------------------------")
k,x = attack(n,m1,r1,s1,m2,r2,s2)

print(bytes.fromhex(hex((Enc * inverse_mod(x,n)).xy()[0])[2:]).decode())


