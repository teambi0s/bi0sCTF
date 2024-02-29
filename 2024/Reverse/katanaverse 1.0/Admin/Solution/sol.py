import numpy as np
import networkx as nx
from numpy import pi, cos, sin, arccos, arctan2

def calc_weight(a, b):
    sum_of_squares = 0
    for i in range(3):
        diff = a[i] - b[i]
        sum_of_squares += diff*diff
    return np.round(10*np.sqrt(sum_of_squares))

def rotate(initial_coords, rotation_matrix):
    return np.dot(rotation_matrix, initial_coords)

def xyz_to_alpha_beta(xyz):
  xyz = np.asarray(xyz)
  r = np.linalg.norm(xyz)
  theta = arccos(xyz[2] / r)
  phi = arctan2(xyz[1], xyz[0])
  alpha = cos(theta / 2)
  beta = np.exp(1j * phi) * sin(theta / 2)
  return alpha, beta

def alpha_beta_to_xyz(alpha, beta):
  r = abs(alpha)**2 + abs(beta)**2
  theta = 2 * arccos(abs(alpha) / np.sqrt(r))
  phi = np.angle(beta / alpha)
  x = r * sin(theta) * cos(phi)
  y = r * sin(theta) * sin(phi)
  z = r * cos(theta)
  return np.array([x, y, z])

def zeroth(coords_xyz):
  a = rotate(coords_xyz, rx_op(np.pi / 4))
  a = rotate(a, ry_op(np.pi / 3))
  a = rotate(a, rz_op(np.pi / 4))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a
  
def first(coords_xyz):
  a = rotate(coords_xyz, ry_op(np.pi / 4))
  a = rotate(a, rz_op(np.pi / 3))
  a = rotate(a, rx_op(np.pi / 3))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a

def second(coords_xyz):
  a = rotate(coords_xyz, rx_op(np.pi / 6))
  a = rotate(a, ry_op(np.pi / 2))
  a = rotate(a, rz_op(np.pi / 4))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a

def third(coords_xyz):
  a = rotate(coords_xyz, ry_op(np.pi / 6))
  a = rotate(a, rx_op(np.pi / 2))
  a = rotate(a, rz_op(np.pi / 6))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a

def fourth(coords_xyz):
  a = rotate(coords_xyz, rx_op(np.pi / 4))
  a = rotate(a, ry_op(np.pi / 3))
  a = rotate(a, rz_op(np.pi / 6))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a

def fifth(coords_xyz):
  a = rotate(coords_xyz, ry_op(np.pi / 2))
  a = rotate(a, rx_op(np.pi))
  a = rotate(a, rz_op(np.pi / 4))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a

def sixth(coords_xyz):
  a = rotate(coords_xyz, rx_op(np.pi / 3))
  a = rotate(a, ry_op(np.pi))
  a = rotate(a, rz_op(np.pi / 3))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a

def seventh(coords_xyz):
  a = rotate(coords_xyz, ry_op(np.pi / 6))
  a = rotate(a, rz_op(np.pi / 4))
  a = rotate(a, rx_op(np.pi / 2))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a

def eigth(coords_xyz):
  a = rotate(coords_xyz, rx_op(np.pi / 6))
  a = rotate(a, ry_op(np.pi))
  a = rotate(a, rz_op(np.pi / 4))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a

def ninth(coords_xyz):
  a = rotate(coords_xyz, ry_op(np.pi / 4))
  a = rotate(a, rx_op(np.pi))
  a = rotate(a, rz_op(np.pi / 3))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a

def tenth(coords_xyz):
  a = rotate(coords_xyz, rx_op(np.pi / 6))
  a = rotate(a, ry_op(np.pi / 3))
  a = rotate(a, rz_op(np.pi / 4))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a

def eleventh(coords_xyz):
  a = rotate(coords_xyz, rx_op(np.pi / 4))
  a = rotate(a, ry_op(np.pi))
  a = rotate(a, rz_op(np.pi / 6))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a

def twelfth(coords_xyz):
  a = rotate(coords_xyz, ry_op(np.pi / 2))
  a = rotate(a, rx_op(np.pi))
  a = rotate(a, rz_op(np.pi / 4))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a

def thirteenth(coords_xyz):
  a = rotate(coords_xyz, rx_op(np.pi / 2))
  a = rotate(a, ry_op(np.pi / 6))
  a = rotate(a, rz_op(np.pi / 3))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a

def fourteenth(coords_xyz):
  a = rotate(coords_xyz, rx_op(np.pi / 3))
  a = rotate(a, ry_op(np.pi / 3))
  a = rotate(a, rz_op(np.pi / 4))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a

def fifteenth(coords_xyz):
  a = rotate(coords_xyz, ry_op(np.pi / 4))
  a = rotate(a, rz_op(np.pi / 6))
  a = rotate(a, rx_op(np.pi / 6))
  a[0] = round(a[0], 5) if abs(a[0]) > 0.00001 else 0
  a[1] = round(a[1], 5) if abs(a[1]) > 0.00001 else 0
  a[2] = round(a[2], 5) if abs(a[2]) > 0.00001 else 0
  return a

def rx_op(theta):
    cos_a = np.cos(theta)
    sin_a = np.sin(theta)
    Rx = np.array([[1, 0, 0],
                   [0, cos_a, -sin_a],
                   [0, sin_a, cos_a]])
    return Rx

def ry_op(theta):
    cos = np.cos(theta)
    sin = np.sin(theta)
    Ry = np.array([[cos, 0, sin],
                   [0, 1, 0],
                   [-sin, 0, cos]])
    return Ry

def rz_op(theta):
    cos = np.cos(theta)
    sin = np.sin(theta)
    Rz = np.array([[cos, -sin, 0],
                   [sin, cos, 0],
                   [0, 0, 1]])
    return Rz

def choice(choi, points):
  if choi == 0:
    return zeroth(points)
  elif choi == 1:
    return first(points)
  elif choi == 2:
    return second(points)
  elif choi == 3:
    return third(points)
  elif choi == 4:
    return fourth(points)
  elif choi == 5:
    return fifth(points)
  elif choi == 6:
    return sixth(points)
  elif choi == 7:
    return seventh(points)
  elif choi == 8:
    return eigth(points)
  elif choi == 9:
    return ninth(points)
  elif choi == 10:
    return tenth(points)
  elif choi == 11:
    return eleventh(points)
  elif choi == 12:
    return twelfth(points)
  elif choi == 13:
    return thirteenth(points)
  elif choi == 14:
    return fourteenth(points)
  elif choi == 15:
    return fifteenth(points)
  
pairs = [[0,2], [0,4], [0,6], [0,8], [0,10], [1,0], [1,3], [1,5], [1,7], [1,9], [1,11], [2,1], [2,4], [2,6], [2,8], [2,10], [3,2], [3,5], [3,7], [3,9], [3,11], [4,3], [4,6], [4,8], [4,10], [5,4], [5,7], [5,9], [5,11], [6,5], [6,8], [6,10], [7,6], [7,9], [7,11], [8,7], [8,10], [9,8], [9,11], [10,9], [11,10]]

rand_arr = [1, 2, 0, 3, 2, 1, 2, 3, 1, 0, 2, 3, 3, 0, 1, 2, 0, 1, 1, 2, 3, 2, 0, 1, 0, 1, 3, 3, 2, 0, 1, 2, 0, 1, 3, 2, 3, 2, 0, 0, 3, 2, 3, 1, 0, 3, 2, 0, 0, 3, 1, 3, 1, 2, 3, 2, 1, 2, 0, 3, 0, 2, 3]

cond_arr = [0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0]

dec_arr = [85, 74, 105, 82, 105, 102, 85, 74, 101, 90, 85, 106, 89, 102, 101, 90, 85, 106, 90, 116, 116, 90, 117, 74, 102, 86, 85, 106, 91, 82, 90, 86, 85, 74, 86, 100, 86, 118, 85, 106, 84, 110]

new_sol = []
new_sol.append([0, 1, 1, 1, 1, 0, 1, 1])

for bug in range(21):

    solutions = new_sol
    new_sol=[]

    print("\nFor ", bug)
    for hat in solutions:
        print("Trying...", hat)
        a = hat
        cond = [cond_arr[bug*3], cond_arr[bug*3+1], cond_arr[bug*3+2]]
        rand = [rand_arr[bug*3], rand_arr[bug*3+1], rand_arr[bug*3+2]]

        res = []

        dec_bytes = [dec_arr[bug*2], dec_arr[bug*2+1]]
        best = ''
        best_sol=[]
        for i in range(2):
            best += bin(dec_bytes[i])[3:]
        best_sol = [int(char) for char in best]

        for q in range(0,2):
            for w in range(0,2):
                for e in range(0,2):
                    for r in range(0,2):
                        for t in range(0,2):
                            for y in range(0,2):
                                for u in range(0,2):
                                    for i in range(0,2):
                                        b = q,w,e,r,t,y,u,i
                                        c = [[0]*8]*6
                                        k=0
                                        for j in rand:
                                            c = [0]*8
                                            c[0] = a[(j+0)]^b[(j+0)]
                                            c[1] = a[(1+j)]^b[(1+j)]
                                            c[2] = a[(2+j)]^b[(2+j)]
                                            c[3] = a[(1+j)]^b[(0+j)]
                                            c[4] = a[(0+j)]^b[(1+j)]
                                            c[5] = a[(2+j)]^b[(1+j)]
                                            c[6] = a[(1+j)]^b[(2+j)]
                                            c[7] = a[(0+j)]^b[(1+j)]^a[(2+j)]
                                            if c[0] ^ c[7] != cond[k]:
                                                k+=1  
                                        if k == 3:
                                            res.append(b)

        for i in range(len(res)):
            classified = []
            final_res = res[i]
            b = res[i]
            for j in range(6):
                c = [0]*8
                c[0] = a[(j+0)]^b[(j+0)]
                c[1] = a[(1+j)]^b[(1+j)]
                c[2] = a[(2+j)]^b[(2+j)]
                c[3] = a[(1+j)]^b[(0+j)]
                c[4] = a[(0+j)]^b[(1+j)]
                c[5] = a[(2+j)]^b[(1+j)]
                c[6] = a[(1+j)]^b[(2+j)]
                c[7] = a[(0+j)]^b[(1+j)]^a[(2+j)]
                classified.append(c)
            op_list = []
            for k in range(6):
                op_list.append(classified[k][0]*8+classified[k][1]*4+classified[k][2]*2+classified[k][3]*1)
                op_list.append(classified[k][4]*1+classified[k][5]*2+classified[k][6]*4+classified[k][7]*8)
    
            points = [[0]*3 for _ in range(12)]

            xyz_in = np.array([0,0,1])
            for j in range(12):
                ant = op_list[j]
                xyz_in = choice(ant, xyz_in)
                points[j] = xyz_in

            elist = [[0] * 3 for _ in range(41)] 

            for j in range(41):
                elist[j][0] = pairs[j][0]
                elist[j][1] = pairs[j][1]
                elist[j][2] = calc_weight(points[pairs[j][0]], points[pairs[j][1]]) 

            n = 12  
            G = nx.Graph()
            G.add_nodes_from(np.arange(0, n, 1))

            G.add_weighted_edges_from(elist)
            
            w = np.zeros([n, n])
            for iy in range(n):
                for j in range(n):
                    temp = G.get_edge_data(iy, j, default=0)
                    if temp != 0:
                        w[iy, j] = temp["weight"]
                
            best_cost_brute = 0
            for b in range(2**n):
                x = [int(t) for t in reversed(list(bin(b)[2:].zfill(n)))]
                cost = 0
                for iy in range(n):
                    for j in range(n):
                        cost = cost + w[iy, j] * x[iy] * (1 - x[j])
                if best_cost_brute < cost:
                    best_cost_brute = cost
                    xbest_brute = x
        
            if xbest_brute == best_sol:
                charac_s = ''.join(str(bit) for bit in final_res)
                if chr(int(charac_s, 2)) in '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ}{':
                    if final_res not in new_sol:
                        new_sol.append(final_res)
                    print("Found: ", final_res, chr(int(charac_s, 2)))

