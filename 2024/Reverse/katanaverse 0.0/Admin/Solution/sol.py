import numpy as np
from numpy import pi, cos, sin, arccos, arctan2

op_list = [ [1, 1, 0, 6, 3, 13, 4, 11, 11, 10, 7, 0] ,[5, 10, 11, 2, 7, 8, 12, 4, 8, 9, 2, 10] ,[4, 5, 8, 1, 0, 6, 1, 9, 2, 4, 6, 15] ,[3, 5, 6, 7, 13, 13, 8, 9, 0, 14, 1, 1] ,[1, 15, 3, 13, 4, 11, 11, 4, 6, 1, 14, 14] ,[1, 15, 3, 3, 5, 4, 8, 7, 3, 11, 5, 2] ,[3, 11, 7, 6, 15, 15, 15, 1, 12, 10, 11, 2] ,[3, 5, 4, 3, 11, 12, 6, 9, 14, 8, 12, 10] ,[1, 15, 1, 7, 3, 11, 7, 8, 12, 4, 10, 3] ,[1, 15, 1, 7, 3, 5, 6, 9, 14, 6, 13, 11] ,[1, 15, 3, 3, 5, 4, 10, 3, 5, 10, 11, 2] ,[3, 11, 5, 2, 9, 0, 0, 0, 2, 10, 5, 10] ,[3, 5, 6, 9, 14, 6, 13, 11, 9, 0, 2, 10] ,[1, 15, 1, 7, 3, 5, 4, 13, 10, 13, 4, 11] ,[1, 15, 3, 3, 7, 0, 12, 2, 9, 14, 3, 11] ,[3, 11, 5, 2, 11, 10, 7, 0, 14, 8, 14, 14] ,[3, 5, 6, 9, 12, 2, 9, 14, 3, 11, 7, 6] ,[3, 11, 7, 8, 12, 4, 8, 7, 3, 5, 6, 7] ,[1, 1, 0, 6, 3, 13, 4, 5, 10, 11, 5, 2] ,[1, 1, 0, 6, 3, 3, 7, 14, 13, 3, 9, 6] ,[3, 5, 4, 13, 10, 13, 4, 11, 11, 10, 5, 4] ,[1, 15, 1, 9, 0, 14, 1, 15, 1, 9, 2, 4] ,[7, 0, 14, 6, 13, 5, 10, 11, 5, 2, 9, 14] ,[4, 5, 8, 1, 0, 8, 0, 8, 0, 6, 1, 7]]
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
  

k1n_points = [[[0] * 3 for _ in range(12)] for _ in range(24)]

for i in range(24):
  xyz_in = np.array([0, 0, 1])
  for j in range(12):
    a = op_list[i][j]
    xyz_in = choice(a, xyz_in)
    k1n_points[i][j] = xyz_in

# for i in range(40):
#   for j in range(12):
#     print(f"{i} -- {j} -- X-coordinate: {k1n_points[i][j][0]}")
#     print(f"{i} -- {j} -- Y-coordinate: {k1n_points[i][j][1]}")
#     print(f"{i} -- {j} -- Z-coordinate: {k1n_points[i][j][2]}\n")
    
for i in range(24):
  print('[', end='')
  for j in range(12):
    print(f"[{k1n_points[i][j][0]}, {k1n_points[i][j][1]}, {k1n_points[i][j][2]}], ", end='')
  print('], ', end='')
# print(k1n_points)