#!/bin/python3
from pwn import *
from sympy import primerange
import math
import time

host = 'localhost'
port = 5000

factor_dict = {
    2: 14,
    3: 9,
    5: 6,
    7: 5,
    11: 4,
    13: 4,
    17: 4,
    19: 4,
    23: 3,
    29: 3,
    31: 3,
    37: 3,
    41: 3,
    43: 3,
    47: 3,
    53: 3,
    59: 3,
    61: 3,
    67: 3,
    71: 3,
    73: 3,
    79: 3,
    83: 3,
    89: 3,
    97: 3,
}

def main():

    conn = remote(host, port)
    primes = list(primerange(1, 10000))
    for _ in range(10):
        queries = 0
        factors = []
        for i in primes[:25]:
                print(f"sending {i}")
                queries += 1
                conn.sendlineafter(b">> ",b'1')
                conn.sendlineafter(b" Your number : ",str(i).encode())  
                conn.recvuntil(b'Is x divisible by ')
                conn.recvuntil(b'? ')
                if b'Yes' in conn.recvline():
                    j = 2
                    while j <= factor_dict[i]:
                        print(f"sending {i**j}")
                        queries += 1
                        conn.sendlineafter(b">> ",b'1')
                        conn.sendlineafter(b' Your number : ',str(i**j).encode())
                        conn.recvuntil(b'Is x divisible by ')
                        conn.recvuntil(b'? ')
                        if b'Yes' in conn.recvline():
                            j+=1
                        else:
                            break
                    factors.append(i**(j-1))

        big_primes = primes[25:]
        flag = True
        while flag:
            print(f"sending {','.join([str(i) for i in big_primes[:len(big_primes)//2]])}")
            queries += 1
            conn.sendlineafter(b">> ",b'2')
            conn.sendlineafter(b'Your Array : ',','.join([str(i) for i in big_primes[:len(big_primes)//2]]).encode())
            conn.recvuntil(b'Is there a y in [')
            conn.recvuntil(b'] such that gcd(x, y) > 1? ')
            if b'Yes' in conn.recvline():
                big_primes = big_primes[:len(big_primes)//2]
            else:
                big_primes = big_primes[len(big_primes)//2:]
            if len(big_primes) == 1:
                flag = False

        print(f"sending {big_primes[0]}")
        queries += 1
        conn.sendlineafter(b">> ",b'1')
        conn.sendlineafter(b' Your number : ',str(big_primes[0]).encode()) 
        conn.recvuntil(b'Is x divisible by ')
        conn.recvuntil(b'? ')
        if b'Yes' in conn.recvline():
            factors.append(big_primes[0])
        
        print(f"sending {math.prod(factors)}")
        queries += 1
        conn.sendlineafter(b">> ",b'3')
        conn.sendlineafter(b'Your guess : ',str(math.prod(factors)).encode())
        
        print(f"queries: {queries}")
        time.sleep(0.5)
    conn.interactive()

if __name__ == "__main__":
    main()
