from hashlib import md5
from Crypto.Util.number import bytes_to_long, long_to_bytes
from secret import FLAG, p1,p2
from sage.all import *

a1 = 284714395592149985031071990064722603855564247389538236878682710552855514777811243873118923924323181542656848585973193167859733308878913768997124222623467
b1 = 6691650159000762838310818461581190062553047897575015587337603592580333224793723463850872931945734336439769314392536267909443115859245856541836553263948753

a2 = 501825392150441176175728536671705829555714973361100909579834429968064243697851483241083792599402881866011389914665565694449484329836527749246854277502643
b2 = 1291619760902660387903505043454584215818295063211936290200646344457970633763165896027212915277161704232069970670816281868294804457737375861177780690688002

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
print("b2 = "+str(hex(b2)))

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

