from qrcode import *
import random
import os
try:
    flag = os.environ['FLAG'].encode()
except KeyError:
    flag = b'bi0sctf{fake_flag_for_testing}'
import sys

def getmatrix(flag):
    code = QRCode(version=1, error_correction=ERROR_CORRECT_L)
    code.add_data(flag)
    code.make()
    return code.get_matrix()

while len(getmatrix(flag)) < 37:
    flag += b'a'

def print_qr(matrix):
    for y in range(37):
        for x in range(37):
            if matrix[y][x]:
                print('\033[40m  \033[0m', end='')
            else:
                print('\033[47m  \033[0m', end='')
        print()

def make_move(move):
    '''
    Validates the move and makes necessary updates
    Return -1 if move is invalid
    If move is a lowercase wasd, check if player can move in that direction (same state), then make the move
    If move is an uppercase WASD, check if the player can move in that direction (different state, call it a jump) then make that move
    If the player can't make either move (edge of the wall), return 2
    '''
    global MAZE, posx, posy, state
    if move == 'w':
        if posy == 0:
            return 2
        if MAZE[posy-1][posx] == state:
            posy -= 1
        else:
            return 2
    elif move == 'a':
        if posx == 0:
            return 2
        if MAZE[posy][posx-1] == state:
            posx -= 1
        else:
            return 2
    elif move == 's':
        if posy == height-1:
            return 2
        if MAZE[posy+1][posx] == state:
            posy += 1
        else:
            return 2
    elif move == 'd':
        if posx == width-1:
            return 2
        if MAZE[posy][posx+1] == state:
            posx += 1
        else:
            return 2
    elif move == 'W':
        if posy == 0:
            return 2
        if MAZE[posy-1][posx] != state:
            posy -= 1
            state = MAZE[posy][posx]
            return 1
        else:
            return 2
    elif move == 'A':
        if posx == 0:
            return 2
        if MAZE[posy][posx-1] != state:
            posx -= 1
            state = MAZE[posy][posx]
            return 1
        else:
            return 2
    elif move == 'S':
        if posy == height-1:
            return 2
        if MAZE[posy+1][posx] != state:
            posy += 1
            state = MAZE[posy][posx]
            return 1
        else:
            return 2
    elif move == 'D':
        if posx == width-1:
            return 2
        if MAZE[posy][posx+1] != state:
            posx += 1
            state = MAZE[posy][posx]
            return 1
        else:
            return 2
    else:
        return -1
    return 0
        

mat = getmatrix(flag)
MAZE = [[1 if mat[x][y] else 0 for x in range(37)] for y in range(37)]
height = len(MAZE)
width = len(MAZE[0])
posx, posy = random.randint(0, width-1), random.randint(0, height-1)
state = MAZE[posy][posx]
# Main game loop
if len(sys.argv) > 1:
    if sys.argv[1] == 'DEBUG':
        print_qr(MAZE)
print("""Welcome to The Far Lands! You're free to explore. 
You can move around using wasd (lowercase). 
If you hit a wall, you can jump over them using WASD (uppercase). 
You can't jump if there's no wall in front of you. 
Lastly, you're placed in a random position in the maze. 
Do your best to figure out it's secrets!
""")
for _ in range(2000, 0, -1):
    move = input(f"{str(_).zfill(4)}> ")
    result = make_move(move)
    if result == -1:
        print("Invalid move!")
    elif result == 2:
        print("You can't move there!")
    elif result == 1:
        print("Jumped over a wall!")
    else:
        print("Moved!")