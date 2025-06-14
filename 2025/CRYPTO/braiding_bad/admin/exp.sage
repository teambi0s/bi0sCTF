import ast
import hashlib
from Crypto.Util.number import long_to_bytes

n = 100
Bn = BraidGroup(n)
gs = Bn.gens()
K = 32

def parse_output(output_str):
    lines = output_str.strip().split('\n')
    data = {}
    for line in lines:
        key, value = line.split(': ', 1)
        if key in ['p', 'q', 'c1']:
            word_list = ast.literal_eval(value)
            data[key] = Bn(word_list)
        elif key == 'c2':
            data['c2'] = int(value)
    return data

output_str = """
p: [50, 25, 40, 98, 35, 87, 54, 16, 65, 60, 95, 20, 4, 79, 69, 15, 53, 26, 92, 87, 48, 56, 99, 83, 2, 56, 47, 59, 42, 3, 19, 53]
q: [5, 24, 6, 21, 6, 28, 20, 48, 15, 18, 18, 8, 47, 22, 22, 3, 14, 40, 18, 26, 4, 31, 11, 16, 8, 46, 45, 23, 17, 39, 24, 21, 50, 25, 40, 98, 35, 87, 54, 16, 65, 60, 95, 20, 4, 79, 69, 15, 53, 26, 92, 87, 48, 56, 99, 83, 2, 56, 47, 59, 42, 3, 19, 53, -21, -24, -39, -17, -23, -45, -46, -8, -16, -11, -31, -4, -26, -18, -40, -14, -3, -22, -22, -47, -8, -18, -18, -15, -48, -20, -28, -6, -21, -6, -24, -5]
c1: [93, 84, 92, 90, 63, 63, 76, 60, 61, 57, 99, 62, 55, 91, 95, 62, 59, 54, 91, 69, 55, 60, 96, 74, 78, 55, 78, 64, 61, 54, 76, 84, 50, 25, 40, 98, 35, 87, 54, 16, 65, 60, 95, 20, 4, 79, 69, 15, 53, 26, 92, 87, 48, 56, 99, 83, 2, 56, 47, 59, 42, 3, 19, 53, -84, -76, -54, -61, -64, -78, -55, -78, -74, -96, -60, -55, -69, -91, -54, -59, -62, -95, -91, -55, -62, -99, -57, -61, -60, -76, -63, -63, -90, -92, -84, -93]
c2: 2315157014596884429538745310505697576231247890652617038454441871904638642633138761681911931668903937398814215580589949726790160298882443329224130590117763020425392822361299940434853674756207376179949432149288134358028

"""
output_data = parse_output(output_str)
u = output_data['p']
v = output_data['q']
w = output_data['c1']
d = output_data['c2']

## ------------------
## Attack
## ------------------

factors = []
for i in u.Tietze():
	factors.append(i - 1)
print(f"factors: {factors}")

x1 = gs[0] / gs[0]
x2 = gs[0] / gs[0]
cnt = 0
for i in factors:
	if i < (n // 2) - 1:
		x1 *= gs[i]
	elif i >= (n // 2) + 1:
		x2 *= gs[i]
	else:
		cnt += 1


z = gs[n // 2 - 1]^cnt

if x1 * x2 * z == u:
	print("we can attack")
else:
	print("we cant attack")
	exit(0)
 
r1 = v * z^-1 * x2^-1
r2 = x1^-1 * w * z^-1
r = r1 * r2 * z

h = hashlib.sha512(str(prod(r.right_normal_form())).encode()).digest()

dd = list(long_to_bytes(d).decode())
xx = []
for i in range(len(h)):
	xx.append(chr(ord(dd[i]) ^^ h[i]))
message = "".join(xx).encode("utf-8")
print(f"message: {message}")
