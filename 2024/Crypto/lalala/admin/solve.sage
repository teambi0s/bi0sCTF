from collections.abc import Sequence
import math
import operator
from typing import List, Tuple
from subprocess import check_output
from re import findall

def flatter(M):
    z = "[[" + "]\n[".join(" ".join(map(str, row)) for row in M) + "]]"
    ret = check_output(["flatter"], input=z.encode())
    return matrix(M.nrows(), M.ncols(), map(int, findall(b"-?\\d+", ret)))

def _process_linear_equations(equations, vars, guesses) -> List[Tuple[List[int], int, int]]:
    result = []
    for rel, m in equations:
        op = rel.operator()
        expr = (rel - rel.rhs()).lhs().expand()
        coeffs = []
        for var in vars:
            coeff = expr.coefficient(var)
            coeffs.append(int(coeff) % m)
        const = expr.subs({var: guesses[var] for var in vars})
        const = int(const) % m
        result.append((coeffs, const, m))
    return result


def solve_linear_mod(equations, bounds, **lll_args):
    vars = list(bounds)
    guesses = {}
    var_scale = {}
    for var in vars:
        bound = bounds[var]
        if isinstance(bound, Sequence):
            if len(bound) == 2:
                xmin, xmax = map(int, bound)
                guess = (xmax - xmin) // 2 + xmin
            elif len(bound) == 3:
                xmin, guess, xmax = map(int, bound)
            else:
                raise TypeError("Bounds must be integers, 2-tuples or 3-tuples")
        else:
            xmin = 0
            xmax = int(bound)
            guess = xmax // 2
        if not xmin <= guess <= xmax:
            raise ValueError(f"Bound for variable {var} is invalid ({xmin=} {guess=} {xmax=})")
        var_scale[var] = max(xmax - guess, guess - xmin, 1)
        guesses[var] = guess
    var_bits = math.log2(int(prod(var_scale.values()))) + len(vars)
    mod_bits = math.log2(int(prod(m for rel, m in equations)))
    equation_coeffs = _process_linear_equations(equations, vars, guesses)
    is_inhom = any(const != 0 for coeffs, const, m in equation_coeffs)
    NR = len(equation_coeffs)
    NV = len(vars)
    if is_inhom:
        NV += 1
    B = matrix(ZZ, NR + NV, NR + NV)
    S = max(var_scale.values())
    eqS = S << (NR + NV + 1)
    if var_bits > mod_bits:
        eqS <<= int((var_bits - mod_bits) / NR) + 1
    col_scales = []
    for ri, (coeffs, const, m) in enumerate(equation_coeffs):
        for vi, c in enumerate(coeffs):
            B[NR + vi, ri] = c
        if is_inhom:
            B[NR + NV - 1, ri] = const
        col_scales.append(eqS)
        B[ri, ri] = m
    for vi, var in enumerate(vars):
        col_scales.append(S // var_scale[var])
        B[NR + vi, NR + vi] = 1
    if is_inhom:
        col_scales.append(S)
        B[NR + NV - 1, -1] = 1
    for i, s in enumerate(col_scales):
        B[:, i] *= s
    B = flatter(B) #B.LLL(**lll_args)
    for i, s in enumerate(col_scales):
        B[:, i] /= s
    for i in range(B.nrows()):
        if sum(x < 0 for x in B[i, :]) > sum(x > 0 for x in B[i, :]):
            B[i, :] *= -1
        if is_inhom and B[i, -1] < 0:
            B[i, :] *= -1
    for row in B:
        if any(x != 0 for x in row[:NR]):
            continue
        if is_inhom:
            if row[-1] != 1:
                continue
        res = {}
        for vi, var in enumerate(vars):
            res[var] = row[NR + vi] + guesses[var]
        return res

def solve_nonlinear_mod(equations, bounds, p):
    linearised_equations = []
    linearised_bounds = {}
    for e in equations:
        d = e.polynomial(ZZ).dict()
        variables = e.variables()
        new_equation = 0
        for t, coeff in d.items():
            const = True
            try:
                _ = list(t)
            except:
                t = [t]
            v = ""
            b = 1
            for j, i in enumerate(t):
                if i != 0:
                    v += str(variables[j]) + "__" + str(i) + "___"
                    b *= bounds[variables[j]] ** i
                    const = False
            if const:
                new_equation += coeff
                continue
            v = var(v)
            linearised_bounds[v] = b
            new_equation += coeff * v
        linearised_equations.append((new_equation == 0, p)) 
    sol = solve_linear_mod(linearised_equations, linearised_bounds)
    eqs = []
    for x, v in sol.items():
        ss = ""
        t = str(x).split('___')[:-1]
        for i, s in enumerate(t):
            ss += s.replace('__', '**')
            if i != len(t)-1:
                ss += "*"
        exec(f"eqs.append({ss} == {v})")
    return list(solve(eqs, list(bounds.keys()), solution_dict=True, algorithm='sympy', domain='real')[0].values())

def main():
    from out import p, output
    xs = [var(f'x_{i}') for i in range(10)]
    bounds = {x: 2**32 for x in xs}
    equations = []
    for i in range(0, len(output), 4):
        aa = output[i]
        bb = output[i+1]
        cc = output[i+2]
        lhs = sum([a + xs[b]^2 * xs[c]^3 for a, b, c in zip(aa, bb, cc)])
        rhs = output[i+3]
        equations.append(lhs - rhs)
    sol = solve_nonlinear_mod(equations, bounds, p)
    flag = "".join([chr(int(i) % 1000) for i in sol])
    print("bi0sctf{%s}" % flag)

if __name__ == "__main__":
    main()
