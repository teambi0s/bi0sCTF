from pwn import remote
import time
from fastecdsa.point import Point
from fastecdsa.curve import Curve
from Crypto.Util.number import inverse

io = remote('localhost', 1337)
print(io.recvline())
io.sendlineafter(b'> ', b'2')
print(io.recvline())
dbits = []
while True:
    start = time.time()
    dat = io.recvuntil(b'\r', drop=True, timeout=5)
    end = time.time()
    if dat == b'':
        break
    dbits.append(end-start)
    print(end-start)
avg_time = sum(dbits) / len(dbits)
print("Average:", avg_time)
dbits = ['1' if i > avg_time else '0' for i in dbits]
d = int(''.join(dbits)[::-1], 2)
print(d)
curve = io.recvline().decode().split()[1]
if curve == 'secp256k1':
    p = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f
    a = 0
    b = 7
    Gx = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798
    Gy = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8
    n = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141
else:
    p = 0xfffffffffffffffffffffffffffffffeffffffffffffffff
    a = 0xfffffffffffffffffffffffffffffffefffffffffffffffc
    b = 0x64210519e59c80e70fa7e9ab72243049feb8deecc146b9b1
    Gx, Gy = (0x188da80eb03090f67cbf20eb43a18800f4ff0afd82ff1012, 0x07192b95ffc8da78631011ed6b24cdd573f977a11e794811)
    n = 0xffffffffffffffffffffffff99def836146bc9b1b4d22831

E = Curve(curve, p, a, b, n, Gx, Gy)
P = Point(*(eval(io.recvline().decode())), E)
Q = Point(*(eval(io.recvline().decode())), E)
print(P)
print(Q)
R = P * d
print(R)

def lift_x(x, all=False):
    try:
        point_a = Point(x, pow(x**3 + a*x + b, (p+1)//4, p), E)
        if all:
            return [point_a, Point(x, p - pow(x**3 + a*x + b, (p+1)//4, p), E)]
        else:
            return point_a
    except:
        return []
    
class RNG:
    def __init__(self, seed, P, Q):
        self.seed = seed
        self.P = P
        self.Q = Q

    def next(self): 
        self.seed = (self.seed * self.P).x
        return (self.seed * self.Q).x & (2**(8 * 30) - 1)

def predict_seed(r1, r2, e=inverse(d, n)):
    print("Starting prediction")
    print(r1, r2, e)
    for i in range(2**16):
        r_ = (i<<240) ^ r1
        for point in lift_x(r_, all=True):
            if (((e*point).x*Q).x & (2**240 - 1)) == r2:
                return (e*point).x
    print("Prediction failed :(")

io.sendlineafter('➤ '.encode(), b'1')
r1 = int(io.recvline().decode())
print(r1)
io.sendlineafter('➤ '.encode(), b'1')
r2 = int(io.recvline().decode())
print(r2)
seed = predict_seed(r1, r2)
print(seed)
prng = RNG(seed, P, Q)
io.sendlineafter('➤ '.encode(), b'2')
io.sendlineafter(b'prediction: ', str(prng.next()).encode())
io.interactive()