from time import time, sleep
from curvedict import curves
import random
from flag import flag
import sys

print("Choose your version [1/2]")
mul = 1
try:
    ver = int(input("> "))
    if ver == 1:
        mul = 10
    elif ver == 2:
        mul = 1
    else:
        raise Exception
except:
    print("Error! Defaulting to version 2")
print("Computing parameters...")

def double_and_add(P, k, slow=False):
    Q = P.copy()
    R = None
    progress = 0.0
    unit = 1.0 / k.bit_length()
    while k > 0:
        if k & 1 == 1:
            if slow:
                sleep(0.3*mul)
            R = Q if R is None else R + Q
        else:
            if slow:
                sleep(0.05*mul)
        Q = Q + Q
        if slow:
            print("{:.2f}%".format(progress*100), end='\r')
        progress += unit
        k >>= 1
    return R

class Curve:
    def __init__(self, p, a, b, n):
        self.p = p
        self.a = a
        self.b = b
        self.n = n
    
    def lift_x(self, x):
        y2 = (x*x*x + self.a*x + self.b) % self.p
        y = pow(y2, (self.p+1)//4, self.p)
        if (y*y) % self.p != y2:
            raise ValueError("Point does not lie on the curve")
        return Point(x, y, self)
    
    def random_point(self):
        while True:
            x = random.randrange(1, self.p)
            try:
                return self.lift_x(x)
            except ValueError:
                continue

class Point:
    def __init__(self, x, y, curve):
        self.x = x
        self.y = y
        self.curve = curve

    def xy(self):
        return (self.x, self.y)
    
    def __add__(self, other):
        if self.curve != other.curve:
            raise ValueError("Points are not on the same curve")
        if self == other:
            return self.double()
        if self.x == other.x:
            return self.curve.lift_x(0)
        l = ((other.y - self.y) * pow(other.x - self.x, self.curve.p - 2, self.curve.p)) % self.curve.p
        x = (l*l - self.x - other.x) % self.curve.p
        y = (l * (self.x - x) - self.y) % self.curve.p
        return Point(x, y, self.curve)

    def double(self):
        l = ((3*self.x*self.x + self.curve.a) * pow(2*self.y, self.curve.p - 2, self.curve.p)) % self.curve.p
        x = (l*l - 2*self.x) % self.curve.p
        y = (l * (self.x - x) - self.y) % self.curve.p
        return Point(x, y, self.curve)
    
    def __mul__(self, other):
        return double_and_add(self, other)
    
    def __rmul__(self, other):
        return double_and_add(self, other, slow=True)
    
    def __neg__(self):
        return Point(self.x, -self.y, self.curve)
    
    def __str__(self):
        return f'({self.x}, {self.y})'
    
    def __repr__(self):
        return f'({self.x}, {self.y})'
    
    def __eq__(self, other):
        return self.x == other.x and self.y == other.y
    
    def __ne__(self, other):
        return self.x != other.x or self.y != other.y
    
    def copy(self):
        return Point(self.x, self.y, self.curve)

class PRNG:
    def __init__(self, curve, seed=None):
        self.curve = curve
        if seed is None:
            self.seed = random.randint(1, self.curve.n - 1)
        else:
            self.seed = seed % self.curve.n
        self.P = self.curve.random_point()
        self.Q = random.randint(1, self.curve.n - 1) * self.P

    def next(self):
        self.seed = (self.P * self.seed).x
        r = (self.Q * self.seed).x
        return r & (2**(8 * 30) - 1)
    
def main():
    name, p, a, b, Gx, Gy, n = curves(random.choice(['secp256k1', 'secp192r1']))
    curve = Curve(p, a, b, n)
    prng = PRNG(curve)
    print(f"Curve: {name}")
    print(prng.P)
    print(prng.Q)
    print("1. Get a random number\n2. Predict\n3. Exit\n")
    while True:
        op = input("➤ ")
        if op == '1':
            print(prng.next())
        elif op == '2':
            try:
                prediction = int(input("Enter your prediction: "))
                if prediction == prng.next():
                    print("You got it!")
                    print(flag)
                else:
                    print("Better luck next time!")
                    sys.exit()
            except ValueError:
                print("Invalid input")
        elif op == '3':
            print("Bye!")
            sys.exit()
        else:
            print("Invalid option")

if __name__=='__main__':
    main()