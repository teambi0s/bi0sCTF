# from bcc import BPF as bpf
import ctypes as ct
import subprocess
import time
from time import sleep
from sys import exit
import os
import struct

def typing_animation(text, speed=0.01):
    for char in text:
        print(char, end='', flush=True)
        sleep(speed)
    print()


level_2_map = open("part2.txt","r").read()


map_dump = """
 [{
        "key": 0,
        "value": 83
    },{
        "key": 1,
        "value": 108
    },{
        "key": 2,
        "value": 119
    },{
        "key": 3,
        "value": 100
    },{
        "key": 4,
        "value": 105
    },{
        "key": 5,
        "value": 108
    },{
        "key": 6,
        "value": 113
    },{
        "key": 7,
        "value": 124
    }
]"""

def dump_program():
    print("Assembly dump of the program")
    with open("part1.txt","r") as f:
        dmp_1 = f.read()
    print("========================================Asm dump=========================================\n", dmp_1)
    print("========================================End of Assembly dump=============================\n\n")
    print("Here is the map dump")
    time.sleep(1)
    print("========================================MAP DUMP=========================================")
    print(map_dump)
    print("========================================END OF MAP DUMP==================================\n\n")
    choice()

def level_1_inp():
    user_inpt = ""
    while(True):
        file_name = input("Enter the file name you want to open : ")
        user_inp = input("Enter Password: ")
        try:
            assert len(user_inp) == 8
        except AssertionError:
            print("Invalid password length")
            print("It should be 8 character long !!!")
            continue
        break
    enc_arr = [83, 108, 119, 100, 105, 108, 113, 124]
    if file_name == "flag.txt":
        if len(user_inp) != len(enc_arr):
            print("Incorrect password length")
            exit()
        for i in range(len(user_inp)):
            if(ord(user_inp[i]) ^ 5 != enc_arr[i]):
                print("Incorrect Password or flag file\n")
                exit()
    else:
        print("Incorrect filename")
        exit()
    print("""━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┃ ▇▇         ▇▇▇▇▇▇▇▇▇▇  ▇▇      ▇▇    ▇▇▇▇        ▇▇     ┃
┃ ▇▇         ▇▇          ▇▇      ▇▇    ▇▇▇▇      ▇▇▇▇     ┃
┃ ▇▇         ▇▇▇▇▇▇▇▇▇▇  ▇▇      ▇▇            ▇▇  ▇▇     ┃
┃ ▇▇         ▇▇            ▇▇  ▇▇      ▇▇▇▇        ▇▇     ┃
┃ ▇▇▇▇▇▇▇▇▇▇ ▇▇▇▇▇▇▇▇▇▇      ▇▇        ▇▇▇▇    ▇▇▇▇▇▇▇▇▇▇ ┃
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━""")

    print(""" ██████  ██████  ███    ███ ██████  ██      ███████ ████████ ███████ 
██      ██    ██ ████  ████ ██   ██ ██      ██         ██    ██      
██      ██    ██ ██ ████ ██ ██████  ██      █████      ██    █████   
██      ██    ██ ██  ██  ██ ██      ██      ██         ██    ██      
 ██████  ██████  ██      ██ ██      ███████ ███████    ██    ███████\n""")
    os.system("clear")
    typing_animation("Uhhhhhh.... I kinda lost the flag file but I can give you the next level, use that flag\n")
    print("Loading....\n")
    time.sleep(2)
    os.system("clear")
    level_2_setup()


def level_2_setup():
    os.system("clear")
    print("""\033[5m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┃ ▇▇         ▇▇▇▇▇▇▇▇▇▇  ▇▇      ▇▇    ▇▇▇▇    ▇▇▇▇▇▇▇▇▇▇ ┃
┃ ▇▇         ▇▇          ▇▇      ▇▇    ▇▇▇▇            ▇▇ ┃
┃ ▇▇         ▇▇▇▇▇▇▇▇▇▇  ▇▇      ▇▇            ▇▇▇▇▇▇▇▇▇▇ ┃
┃ ▇▇         ▇▇            ▇▇  ▇▇      ▇▇▇▇    ▇▇         ┃
┃ ▇▇▇▇▇▇▇▇▇▇ ▇▇▇▇▇▇▇▇▇▇      ▇▇        ▇▇▇▇    ▇▇▇▇▇▇▇▇▇▇ ┃
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m""")
    print("Loading...")
    time.sleep(2)
    # os.system("clear")
    print("""=============================================PROG_2_OUTPUT=============================================
0x33ae2685,0x230bcdd5,0x4f5ac093,0x3dc3e00a,0xda19d0a1,0x32c52ad0,0xc904ffac,0x3037b842,0x9c7bf31e,0x4b8dfebc,0x33335ba7,0x4c4c9188,0xa555d9a9,0xaa069852,0xa177367f,0x79daa10f,0x29ca035c,0x319fbbc8,0xd51b4a1c,0x4a1b63b6,0x99f5d2f1,0xf35fdd82,0x7e70314f,0x42077d00,0x4f84cb2b,0x4a73846a,0xbbb0581e,0x8c33c34f,0x4eb73143,0xac45de0,0x82592087,0xc02544fa,0x56590be4,0xd2f78e08,0xb2c9d125,0x65e106d8,0x46711844,0xcf16ec7f,0xc85dde46,0x51d873d,0x50319f0f,0x8e5370bd,0x80145a76,0xbdbe90a6,0x3a10947e,0xfaf968c7,0xac700a03,0x47e061be,0xe9e65b90,0xe3c65a80,0xd707d969,0x40e93f77,0x447cf10e,0xbc69c7df,0xd8c669de,0x36c05ccf,0x876411ba,0xb37a6436,0xcdbeac33,0x7ba23db9,0xc18251bd,0x926d7a16,0x9ffb0134,0xc7f9ab96,0xc635711e,0x45b69a8,0x7b0fdd2e,0xf54849a7,0x61e5d839,0x1f12687d,0xb39a4ba1,0xd4fa2f5a,0xc308a7fd,0xcc0f199b,0x6b35768,0xecb39e48,0xb2c9d125,0x65e106d8,0x9e9a0f73,0xc58bdf39,0xa9bb76d1,0xc75ccd7,0x8473c66,0x8a4ed0e5,0xae1dcf9a,0x214f0ed5,0xfb6bf695,0x56e45cc6,0x47e4e2b9,0x8e2107d1,0x5a24b1dc,0x70599ee2,0x6cd313ec,0x4fa221e8,0x6696e856,0x62fde305,0x79958e01,0x1b99f294,0x876fd3a,0x59c1d749,0x0,0x0 
===================================================END================================================
\n""")
    level_2_opt()
    
def level_2_opt():
    choices = 0
    while(True):
        try:        
            print("Choose an option")
            print("1. Generate assembly dump")
            choices = int(input("➾"))
            break
        except ValueError:
            print("Enter a number! ➾")
    if(choices == 1):
        print("Im not feeling generous, here's a part of the code")
        print("========================================Asm dump========================================\n")
        print(level_2_map)
        print("\n========================================END===========================================\n")
        exit()

    if(choices == 2):
        print("NO")
        print("DONT GOT FOR OTHER OPTIONS")
        level_2_opt()
    if(choices == 3):
        print("NUH UH")
        exit()


def choice():
    counter = 0

    while(True):
        try:
            print("▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂")
            choice_no = int(input("█ 1. Generate assembly dump █\n█ 2. cat any file           █\n▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔\n➾ "))
            print("⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼⎼")
            break
        except ValueError:
            print("Enter a number! ➾")
        except EOFError:
            exit()
    
    if (choice_no == 1):
        dump_program()
    
    if (choice_no == 2):
        level_1_inp()
        
    else :
        print("Invalid choice ")
        os.system("clear")
        choice()

if __name__ == "__main__":
    choice()