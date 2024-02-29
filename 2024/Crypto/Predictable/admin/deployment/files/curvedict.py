def curves(s):
    if s == 'secp256k1':
        p = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f
        a = 0
        b = 7
        Gx = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798
        Gy = 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8
        n = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141
    elif s == 'secp224r1':
        p = 0xffffffffffffffffffffffffffffffff000000000000000000000001
        a = 0xfffffffffffffffffffffffffffffffefffffffffffffffffffffffe
        b = 0xb4050a850c04b3abf54132565044b0b7d7bfd8ba270b39432355ffb4
        Gx, Gy = (0xb70e0cbd6bb4bf7f321390b94a03c1d356c21122343280d6115c1d21, 0xbd376388b5f723fb4c22dfe6cd4375a05a07476444d5819985007e34)
        n = 0xffffffffffffffffffffffffffff16a2e0b8f03e13dd29455c5c2a3d
    elif s == 'secp192r1':
        p = 0xfffffffffffffffffffffffffffffffeffffffffffffffff
        a = 0xfffffffffffffffffffffffffffffffefffffffffffffffc
        b = 0x64210519e59c80e70fa7e9ab72243049feb8deecc146b9b1
        Gx, Gy = (0x188da80eb03090f67cbf20eb43a18800f4ff0afd82ff1012, 0x07192b95ffc8da78631011ed6b24cdd573f977a11e794811)
        n = 0xffffffffffffffffffffffff99def836146bc9b1b4d22831
    return (s,p,a,b,Gx,Gy,n)