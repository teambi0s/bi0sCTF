from hashlib import md5
from Crypto.Util.number import bytes_to_long, long_to_bytes
from secret import FLAG, p1,p2, a1,a2, b2,b2
#from sage.all import *

priv1 = bytes_to_long(FLAG[:len(FLAG)//2])
priv2 = bytes_to_long(FLAG[len(FLAG)//2:])

def sign_1(msg):
    hsh = md5(msg).digest()
    nonce = md5(long_to_bytes(priv1) + hsh).digest()
    hsh, nonce = bytes_to_long(hsh), bytes_to_long(nonce)
    r = int((nonce * G1)[0]) % q1
    s = (inverse_mod(nonce, q1) * (hsh + priv1 * r)) % q1
    return r, s

def sign_2(msg):
    hsh = md5(msg).digest()
    nonce = md5(long_to_bytes(priv2) + hsh).digest()
    hsh, nonce = bytes_to_long(hsh), bytes_to_long(nonce)
    r = int((nonce * G2)[0]) % q2
    s = (inverse_mod(nonce, q2) * (hsh + priv2 * r)) % q2
    return r, s

E1 = EllipticCurve(GF(p1),[a1,b1])
G1 = E1.gens()[0]
q1 = G1.order()
E2 = EllipticCurve(GF(p2),[a2,b2])
G2 = E2.gens()[0]
q2 = G2.order()

print("N = "+str(hex(p1*p2)))
print("p1 = "+str(p1))

print("a1 = "+str(hex(a1)))
print("b1 = "+str(hex(b1)))

print("a2 = "+str(hex(a2)))
print("b12= "+str(hex(b2)))


i = 0
while i<5:
    print("1 -> View Soure")
    print("2 -> Sign Message")
    print("3 -> Exit")
    choice = input("Enter your choice: ")
    if choice == "1":
        print(open("chall.sage").read())
    elif choice == "2":
        msg = input("Enter message to sign: ")
        if msg > len(48):
            print("Signature: ")
            print(sign_1(bytes(msg)))
            print(sign_2(bytes(msg)))
            print("Signature from Curve 1: "+str(sig1))
            print("Signature from Curve 2: "+str(sig2))
            i+=1
        else:
            print("Message too short!")
    elif choice == "3":
        i+=5
print("Bye!")

