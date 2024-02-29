from Crypto.Util.number import *
import itertools
from sage.rings.polynomial.multi_polynomial_sequence import PolynomialSequence
from tqdm import tqdm

def solve_system_gb(H, f, timeout=5):
    vs = list(f.variables())
    H_ = PolynomialSequence([], H[0].parent().change_ring(QQ))
    for h in tqdm(H):
        H_.append(h)
        I = H_.ideal()
        roots = []

        alarm(timeout)
        try:
            for root in I.variety(ring=ZZ):
                root = tuple(H[0].parent().base_ring()(root[var]) for var in vs)
                roots.append(root)
            cancel_alarm()
            if roots != []:
                return roots
        except:
            cancel_alarm()      

def coppersmith(f, bounds, m, d):
    if d is None:
        d = f.degree()

    R = f.base_ring()
    N = R.cardinality()
    f_ = (f // f.lc()).change_ring(ZZ)
    f = f.change_ring(ZZ)
    l = f.lm()

    M = []
    for k in range(m+1):
        M_k = set()
        T = set((f ^ (m-k)).monomials())
        for mon in (f^m).monomials():
            if mon//l^k in T: 
                for extra in itertools.product(range(d), repeat=f.nvariables()):
                    g = mon * prod(map(power, f.variables(), extra))
                    M_k.add(g)
        M.append(M_k)
    M.append(set())

    shifts = PolynomialSequence([], f.parent())
    for k in range(m+1):
        for mon in M[k] - M[k+1]:
            g = mon//l^k * f_^k * N^(m-k)
            shifts.append(g)

    B, monomials = shifts.coefficient_matrix()
    monomials = vector(monomials)

    factors = [monomial(*bounds) for monomial in monomials]
    for i, factor in enumerate(factors):
        B.rescale_col(i, factor)

    print("LLL...")
    B = B.dense_matrix().LLL()
    print("LLL done")

    B = B.change_ring(QQ)
    for i, factor in enumerate(factors):
        B.rescale_col(i, 1/factor)
    B = B.change_ring(ZZ)

    H = PolynomialSequence([h for h in B*monomials if not h.is_zero()])
    return solve_system_gb(H, f)

n = 13588728652719624755959883276683763133718032506385075564663911572182122683301137849695983901955409352570565954387309667773401321714456342417045969608223003274884588192404087467681912193490842964059556524020070120310323930195454952260589778875740130941386109889075203869687321923491643408665507068588775784988078288075734265698139186318796736818313573197531378070122258446846208696332202140441601055183195303569747035132295102566133393090514109468599210157777972423137199252708312341156832737997619441957665736148319038440282486060886586224131974679312528053652031230440066166198113855072834035367567388441662394921517
c = 7060838742565811829053558838657804279560845154018091084158194272242803343929257245220709122923033772911542382343773476464462744720309804214665483545776864536554160598105614284148492704321209780195710704395654076907393829026429576058565918764797151566768444714762765178980092544794628672937881382544636805227077720169176946129920142293086900071813356620614543192022828873063643117868270870962617888384354361974190741650616048081060091900625145189833527870538922263654770794491259583457490475874562534779132633901804342550348074225239826562480855270209799871618945586788242205776542517623475113537574232969491066289349
p_high = 914008410449727213564879221428424249291351166169082040257173225209300987827116859791069006794049057028194309080727806930559540622366140212043574
u_low = 233711553660002890828408402929574055694919789676036615130193612611783600781851865414087175789069599573385415793271613481055557735270487304894489126945877209821010875514064660591650207399293638328583774864637538897214896592130226433845320032466980448406433179399820207629371214346685408858
q_high = n // (p_high<<545)

PR.<x, y> = PolynomialRing(Zmod(n), 2)
qq = q_high + x
uu = y * 2**955 + u_low
f = uu*qq**2 - qq  
bounds= (2**545, 2**(1021-955))
q_low, u_high = coppersmith(f, bounds, m=2, d=3)[0]
q = int(qq(x=q_low))
print(long_to_bytes(int(pow(c, pow(65537, -1, (n//q-1)*(q-1)), n))))
