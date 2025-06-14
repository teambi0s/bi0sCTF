from sage.all import *
from hashlib import sha256
from Crypto.Util.number import inverse
import secrets

mask_lsb = (1 << 128) - 1
mask_msb = (1 << 256) - 1

p = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f
E = EllipticCurve(GF(p), [0, 7])
G = E(0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798, 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8)
n = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141

def sign(h, k, d):
    kG = k * G
    r = int(kG.x()) % n
    k_inv = inverse(k, n)
    s = (k_inv * (h + r * d)) % n
    return r, s

d = secrets.randbelow(n)
assert d.bit_length() == 256

Q = d * G

h = int(sha256(b"Karmany-evadhikaras te ma phalesu kadacana ma karma-phala-hetur bhur ma te sango 'stv akarmani.").hexdigest(), 16)
k = (h - (h & (pow(2, 128) - 1))) + ((d - (d & (pow(2, 128) - 1))) // pow(2, 128))
r, s = sign(h, k, d)

print(f"Q = ({int(Q.x())}, {int(Q.y())})\n{r = }\n{s = }")
# flag : bi0sCTF{d}