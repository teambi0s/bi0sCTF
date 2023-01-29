from hashlib import md5
from Crypto.Util.number import long_to_bytes, bytes_to_long
from sage.all import *

class IIter:
    def __init__(self, m, n):
        self.m = m
        self.n = n
        self.arr = [0 for _ in range(n)]
        self.sum = 0
        self.stop = False
    
    def __iter__(self):
        return self

    def __next__(self):
        if self.stop:
            raise StopIteration
        ret = tuple(self.arr)
        self.stop = True
        for i in range(self.n - 1, -1, -1):
            if self.sum == self.m or self.arr[i] == self.m:
                self.sum -= self.arr[i]
                self.arr[i] = 0
                continue
            
            self.arr[i] += 1
            self.sum += 1
            self.stop = False
            break
        return ret

def coppersmith(f, bounds, m=1, t=1):
    n = f.nvariables()
    N = f.base_ring().cardinality()
    f /= f.coefficients().pop(0) #monic
    f = f.change_ring(ZZ)
    x = f.parent().objgens()[1] 

    g = []
    monomials = []
    Xmul = []
    for ii in IIter(m, n):
        k = ii[0]
        g_tmp = f**k * N**max(t-k, 0)
        monomial = x[0]**k
        Xmul_tmp = bounds[0]**k
        for j in range(1, n):
            g_tmp *= x[j]**ii[j]
            monomial *= x[j]**ii[j]
            Xmul_tmp *= bounds[j]**ii[j]
        g.append(g_tmp)
        monomials.append(monomial)
        Xmul.append(Xmul_tmp)

    B = Matrix(ZZ, len(g), len(g))
    for i in range(B.nrows()):
        for j in range(i + 1):
            if j == 0:
                B[i,j] = g[i].constant_coefficient()
            else:
                v = g[i].monomial_coefficient(monomials[j])
                B[i,j] = v * Xmul[j]

    print("LLL...")
    B = B.LLL(algorithm='NTL:LLL_XD')
    print("LLL finished")

    ###############################################

    print("polynomial reconstruction...")

    h = []
    for i in range(B.nrows()):
        h_tmp = 0
        for j in range(B.ncols()):
            if j == 0:
                h_tmp += B[i, j]
            else:
                assert B[i,j] % Xmul[j] == 0
                v = ZZ(B[i,j] // Xmul[j])
                h_tmp += v * monomials[j]
        h.append(h_tmp)

    x_ = [ var(f'x{i}') for i in range(n) ]
    for ii in Combinations(range(len(h)), k=n):
        f = symbolic_expression([ h[i](x) for i in ii ]).function(x_)
        jac = jacobian(f, x_)
        v = vector([ t // 2 for t in bounds ])
        for _ in range(100): #1000
            kwargs = {f'x{i}': v[i] for i in range(n)}
            tmp = v - jac(**kwargs).inverse() * f(**kwargs)
            v = vector(float(d) for d in tmp)
        v = [ int(_.round()) for _ in v ]
        if h[0](v) == 0:
            return v

    return []

N = 0xb4a8f1786f16b0ad10a2b5c4fdb020a192e963cf61eb3adb6eb55c41c41430a7313c158164b717516ae1f11e8f7b2df85b0d1843a519fd016894623384781eeed8e75f9bd38608d3fa734190ccde2b454e7de484b1600872b4fad839265656067b003c3f33c77345e8f55aa33234ac1b1e4d83d2f487ea1a042d4bdea3748bd3

_p  = "e078e75b3313660ec08eefcdfe98ca82ecea4f3483ce9055?????????05fa57d82f??????????525966d8eca5d968b96ca03e60f1b0a13cbd??????????ac39b"

c = 0
l = []
b = 0
bounds = []
for i, h in enumerate(_p.split("?")[::-1]):
    if h != '':
        bounds.append(2**b)
        b = 4
        c += len(h)*4
        l.append(c)
    else:
        b += 4
    c += 4
l = l[:-1]
bounds = bounds[1:]
xs = [f"x{i}" for i in range(len(l))]
PR = PolynomialRing(Zmod(N), len(l), xs)
f = int(_p.replace("?", "0"), 16) + sum([2**i * PR.objgens()[1][n] for n, (i, x) in enumerate(zip(l, xs))])

roots = coppersmith(f, bounds, m=6)
print(roots)
# replaace roots with question marks
p1 = 0xe078e75b3313660ec08eefcdfe98ca82ecea4f3483ce90559b4a7569505fa57d82f98805c4f60525966d8eca5d968b96ca03e60f1b0a13cbdfe9fb5fa60ac39b
p2 = N // p1


 
m1 = b'I have written these words in code, made only for Your eyes. Please take them, and read them right away!'
m2 = b'Angling may be said to be so like the mathematics, that it can never be fully learnt.'
m3 = b'sterkte met hierdie hoender kak uitdaging!aaaaaaaa'


h1 = bytes_to_long(md5(m1).digest())
h2 = bytes_to_long(md5(m2).digest())
h3 = bytes_to_long(md5(m3).digest())

def ec_attack(e1r1, e1s1, e1r2, e1s2, e1r3, e1s3,p,a,b,G,q):
    E = EllipticCurve(GF(p), [a,b])
    sigs = [
        (h1, e1r1, e1s1),
        (h2, e1r2, e1s2),
        (h3, e1r3, e1s3),
    ]


    B = 2**128

    def construct_lattice():
        basis = []
        for i in range(len(sigs)):
            v = [0]*(len(sigs)+2)
            v[i] = q
            basis.append(v)
        vt = [0]*(len(sigs) + 2)
        va = [0]*(len(sigs) + 2)
        vt[-2] = B/q
        va[-1] = B

        i = 0
        for h, r, s in sigs:
            sinv = pow(s, -1, q)
            vt[i] = int(sinv*r)
            va[i] = int(sinv*h)
            i += 1
        basis.append(vt)
        basis.append(va)
        return Matrix(QQ, basis)

    def attack(sigs):
        M = construct_lattice()
        sol = M.LLL()[1]
        x = [(sigs[i][2]*Mod(k, q) - sigs[i][0])*pow(sigs[i][1], -1, q) for i, k in enumerate(sol[:-2])]
        assert all([xi == x[0] for xi in x])
        return x[0]

    d = attack(sigs)
    print(long_to_bytes(int(d)))


e1r1, e1s1 = (5051332418360426299438249536323789596251474691400319092838172175931425018842346509427396606900962794354024287379836547167503908548792151312954210544115071, 10032206514924016838856336723041759969445417383936557630193511239979139545645920606511319693861179563627896968791501576267428665195052454255685842217054825)
e1r2, e1s2 = (7367233834107410167070447701435369728517158919261865759856225260071222185890195949537555184905462799936869111538217925850979300070936653396024874666140577, 9186044310596108788238094149558118405740247799591526332840332131589645279105604023280688037009483506107552379280353245601321805971298862032671171737059291)
e1r3, e1s3 = (2437458108691329301870554409326500899458310231118397409836884319260016569071109209642400271681250892936182389474091645033172941570579913798171647700815182, 3585195115228150174302076604895169290726608236025362015950168239864957345117982931593150583185627805905130557114007228097815060571526866480144648832097456)

e2r1, e2s1 = (8056168363692876486554591605382309427678297391287086448017085750947883058393024701471618113609759983809483867384535157348297360304525822232824476994223032, 5617047663418455079810000042363020440254775049947388819993102944726978851997127970019773566489439022896549774075081565430024992216051523880153755245617411)
e2r2, e2s2 = (9146410452410617028784321903588367031059136652833877918247133938549705357965913809626170701147801077971273087633181318067731824735022761162312618595569753, 2852634056596651143792385718038101008487152231889314220815529045476417375371150853052985639462751506014945742144502029605784263331354545040926820648722808)
e2r3, e2s3 = (2015739224635319802520951199163823784879309252667369152216276601266535246271854158400114480630782246465076186505456833652555265374828858268496137575039753, 1488026601559322103960737500281336200095974624022398530960258513979329552508514300785835631422104041931809009654461855617815996883658775135932913630047475)

a1 = 284714395592149985031071990064722603855564247389538236878682710552855514777811243873118923924323181542656848585973193167859733308878913768997124222623467
b1 = 6691650159000762838310818461581190062553047897575015587337603592580333224793723463850872931945734336439769314392536267909443115859245856541836553263948753

a2 = 501825392150441176175728536671705829555714973361100909579834429968064243697851483241083792599402881866011389914665565694449484329836527749246854277502643
b2 = 1291619760902660387903505043454584215818295063211936290200646344457970633763165896027212915277161704232069970670816281868294804457737375861177780690688002

g1 = 2013900655880801394301932124541532957055873092184807974244791201173073873430583423201811343848166837511621243766087891082508992352198637601420395625191527
g2 = 9133643327953235299057835301736694905103266155388717552464057338789621564626214137183651462439552354223717069640511352515215754704110615697102812193902133

o1 = 11756567260683217973317821468013902925071857221209186747934466797087880003950056062657934676411779626195749253116443260159222430077031406604031496483294819
o2 = 10790881175634558072269092254265802368362184550725174949593446030728701377842120947468767689818768068635638355158161266058040366019788593081905254490911663


de1 = ec_attack(e1r1, e1s1, e1r2, e1s2, e1r3, e1s3,p1,a1,b1,g1,o1)
de2 = ec_attack(e2r1, e2s1, e2r2, e2s2, e2r3, e2s3,p2,a2,b2,g2,o2)
