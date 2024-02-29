from time import time
from pwn import remote
from icecream import ic
import sys
import os
if len(sys.argv) == 1:
    ic.disable()
def clear():
    os.system('cls' if os.name == 'nt' else 'clear')

def print_qr(matrix):
    for y in range(37):
        for x in range(37):
            if matrix[y][x]:
                print('\033[40m  \033[0m', end='')
            else:
                print('\033[47m  \033[0m', end='')
        print()
        
def print_qr_with_player(matrix, posx, posy):
    for y in range(37):
        for x in range(37):
            if x == posx and y == posy:
                print('\033[41m  \033[0m', end='')
            elif matrix[y][x]:
                print('\033[40m  \033[0m', end='')
            else:
                print('\033[47m  \033[0m', end='')
        print()

def interact(move):
    global io
    io.sendline(move.encode())
    response = io.recvuntil(b'> ')
    ic(response)
    if response.startswith(b'Invalid'):
        return -1
    elif response.startswith(b'You'):
        return 2
    elif response.startswith(b'Jumped'):
        return 1
    elif response.startswith(b'Moved'):
        return 0
    
start = time()
io = remote('localhost', 1337)
print(io.recvuntil(b'> ').decode())
# These two while loops take you to the top-right corner of the maze (QR Code) 
while interact('w') != interact('W'):
    pass
assert interact('w') == interact('W')
while interact('a') != interact('A'):
    pass
assert interact('a') == interact('A')
mat = [[0 for _ in range(37)] for _ in range(37)]
state = 0
direction = 'd'
try:
    for i in range(36):
        for j in range(36):
            response = interact(direction)
            if response == 0: # Moved
                if direction == 'd':
                    mat[i][j] = state
                else:
                    mat[i][34-j] = state
            elif response == 2: # Wall, jump and change state
                response = interact(direction.upper())
                assert response == 1
                state ^= 1
                if direction == 'd':
                    mat[i][j] = state
                else:
                    mat[i][34-j] = state
            clear()
            print_qr(mat)
        response = interact('s')
        if response == 2:
            interact('S')
            state ^= 1
            if i != 36:
                if direction == 'd':
                    mat[i][j] = state
                else:
                    mat[i][34-j] = state
        direction = 'a' if direction == 'd' else 'd'
        clear()
        print_qr(mat)
except EOFError:
    print('EOF')
except AssertionError:
    print("Something went wrong")
    sys.exit(1)
        
print_qr(mat)
end = time()
print(f'Time taken: {end-start} seconds')