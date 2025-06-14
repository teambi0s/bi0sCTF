from pwn import *
from z3 import *
from sage.all import *
import json
import ast
from tqdm import trange
from hashlib import sha256
from RMT import R_MT19937_32bit as R_mt

class BreakerRipley32:
    """
    Z3 solver for 32-bit Mersenne Twister with Ripley seeding
    """
    def __init__(self):
        (self.w, self.n, self.m, self.r) = (32, 624, 397, 31)
        self.a = 0x9908B0DF
        (self.u, self.d) = (11, 0xFFFFFFFF)
        (self.s, self.b) = (7, 0x9D2C5680)
        (self.t, self.c) = (15, 0xEFC60000)
        self.l = 18
        self.num_bits = 32
        self.lower_mask = (1 << self.r) - 1
        self.upper_mask = 0x80000000 

    def tamper_state(self, y):
        y = y ^^ (LShR(y, self.u) & self.d)
        y = y ^^ ((y << self.s) & self.b)
        y = y ^^ ((y << self.t) & self.c)
        y = y ^^ LShR(y, self.l)
        return y

    def untamper(self, num):
        def undo_right_shift_xor_and(y, shift, mask):
            res = y
            for _ in range(5): 
                res = y ^^ ((res >> shift) & mask)
            return res

        def undo_left_shift_xor_and(y, shift, mask):
            res = y
            for _ in range(5):
                res = y ^^ ((res << shift) & mask)
            return res

        y = undo_right_shift_xor_and(num, self.l, 0xFFFFFFFF)
        y = undo_left_shift_xor_and(y, self.t, self.c)
        y = undo_left_shift_xor_and(y, self.s, self.b)
        y = undo_right_shift_xor_and(y, self.u, self.d)
        return y

    def twist_state(self, MT):
        n, m, a = self.n, self.m, self.a
        lower_mask, upper_mask = self.lower_mask, self.upper_mask
        new_MT = [BitVec(f"MT_twisted_{i}", 32) for i in range(n)]
        for i in range(n):
            x = (MT[i] & upper_mask) + (MT[(i + 1) % n] & lower_mask)
            xA = LShR(x, 1)
            xA = If(x & 1 == 1, xA ^^ a, xA)
            new_MT[i] = simplify(MT[(i + m) % n] ^^ xA)
        return new_MT

    def get_seed_mt(self, outputs):
        n = self.n
        SEED = BitVec('seed', 32)
        MT = [BitVec(f"MT_init_{i}", 32) for i in range(n)]

        # Ripley seeding (sow and grow seeds)
        num = SEED
        for _ in range(51):
            num = 69069 * num + 1 
        g_prev = num
        constraints = []
        for i in range(n):
            g = 69069 * g_prev + 1
            constraints.append(MT[i] == (g & 0xFFFFFFFF))
            g_prev = g

        MT_twisted = self.twist_state(MT)

        S = Solver()
        S.add(constraints)
        for idx, value in outputs:
            S.add(self.tamper_state(MT_twisted[idx]) == value)

        # Solve for the seed
        if S.check() == sat:
            model = S.model()
            return model[SEED].as_long()
        else:
            return None
            
# Quick and reliable
load("https://raw.githubusercontent.com/josephsurin/lattice-based-cryptanalysis/refs/heads/main/lbc_toolkit/common/babai_cvp.sage")
load("https://raw.githubusercontent.com/josephsurin/lattice-based-cryptanalysis/refs/heads/main/lbc_toolkit/problems/hidden_number_problem.sage")
load("https://raw.githubusercontent.com/josephsurin/lattice-based-cryptanalysis/refs/heads/main/lbc_toolkit/attacks/ecdsa_key_disclosure.sage")

def json_sender(msg):
    json_msg = json.dumps(msg).encode()
    io.sendline(json_msg)

def RNG_decayer():
    print(f"[{neutral("*")}] Restarting enough times to exploit MSM...")
    for _ in trange(375):
        io.recvuntil(routine_pass)
        json_sender(possible_events[3])

def deadcoin():
    print(f"[{neutral("*")}] Deadcoining for RMT values...")
    RMT_vals = []
    for i in range(3):
        io.recvuntil(routine_pass)
        json_sender(possible_events[1])
        io.recvuntil(b'code: ')
        json_sender(int(0))
        io.recvuntil(b'ID: ')
        RMT_vals.append((i, int(io.recvline().decode())))
    return RMT_vals

def partial_nonce_breaker(_and, equation):
    term = BitVec('term', 32)
    res = term ^^ ((term << 16) & _and)
    S = Solver()
    S.add(res == equation)
    if S.check() == sat:
        model = S.model()
        return model[term].as_long()
    else:
        return None

def decrypt_flag(d,ciphertext,iv) -> tuple:
    from Crypto.Cipher import AES
    from Crypto.Util.Padding import unpad
    
    ciphertext=bytes.fromhex(ciphertext)
    iv = bytes.fromhex(iv)
    sha2 = sha256()
    sha2.update(str(d).encode('ascii'))
    key = sha2.digest()[:16]
    cipher = AES.new(key, AES.MODE_CBC, iv)
    plaintext = cipher.decrypt(ciphertext)
    return plaintext.decode()
    
HOST = 'localhost'
PORT = 5000

io = remote(HOST, PORT)

# Idk man I like pretty printing
neutral = lambda text: ''.join(f"{"\033[92m"}{char}{"\033[0m"}" for _, char in enumerate(text))
happy = lambda text: ''.join(f"{"\033[34m"}{char}{"\033[0m"}" for _, char in enumerate(text))

possible_events = [
    {'event': 'get_encrypted_flag'},
    {'event': 'perform_deadcoin'},
    {'event': 'call_the_signer'},
    {'event': 'level_restart'},
    {'event': 'level_quit'}
]

routine_pass = b'JSON format: '

RNG_decayer()
outputs = deadcoin()
print(outputs)
breaker = BreakerRipley32()
recovered_seed = breaker.get_seed_mt(outputs)
print("Recovered seed:", recovered_seed)

MT = R_mt(recovered_seed)
for _ in range(3):
    MT.get_num()

R = []
S = []
B = []
p_Ki = []

msg = "hello world".encode()

cnt = 5
for _ in range(cnt):
    io.recvuntil(routine_pass)
    json_sender(possible_events[2])
    io.recvuntil(b'speak? ')
    io.sendline(msg)
    sign_res = ast.literal_eval(io.recvline().decode())
    R.append(sign_res['r'])
    S.append(sign_res['s'])
    n_gen_const = sign_res['nonce_gen_consts']
    cycles = sign_res['heat_gen']


    ki = []
    for i in cycles:
        for s in range(i):
            MT.get_num()
        pk = MT.get_num()
        ki.append(pk)
    p_Ki.append(ki)

    

    b_buf = []
    for i in range(2):
        _and, equation = n_gen_const[i]
        b = partial_nonce_breaker(_and, equation)
        b_buf.append(b)
    B.append(b_buf)


Kbar = []


for b_i, k_i in zip(B,p_Ki):
    b1,b2 = b_i
    k1,k2 = k_i
    
    Ki = 2^224*(b1 >> 24 & 0xFF) + 2^192*(b1 >> 16 & 0xFF) + 2^160*k1 + 2^152*(b1 >> 8 & 0xFF) + 2^75*(b1 & 0xFF) + 2^33*(b2 >> 24 & 0xFFF) + k2
    Kbar.append(Ki)


xbar = 0
n = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141
Pi = [148,21] # associared with d
Nu =[108,107] # associated with d
zi = sha256()
zi.update(msg)
Z = [int(zi.hexdigest(),16) for _ in range(cnt)]
Mu = [[24,24,69,30]  for _ in range(cnt)]
lambdha = [[232,200,83,45] for _ in range(cnt)]

d = ecdsa_key_disclosure(xbar, n, Z, R, S, Kbar, Pi, Nu, lambdha, Mu)

io.recvuntil(routine_pass)
json_sender(possible_events[0])

rec = ast.literal_eval(io.recvline().decode())

ciphertext = rec["ciphertext"]
iv = rec["iv"]

print(f'[{happy("!")}] FLAG: {decrypt_flag(d, ciphertext, iv)}')
