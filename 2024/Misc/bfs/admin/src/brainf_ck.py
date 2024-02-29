#!/bin/python3

from time import *
import sys
import os
import random

TAPESIZE = 30000
# ALLOCATING TAPE
tape = [0 for i in range (TAPESIZE)]
# SETTING AN INSTRUCTION PTR
dp   = 0
pc   = 0

fakeflag = "fake{flag_for_testing_your_algos}"
flag = ""
flag1 = ""
flag2 = ""
flag3 = ""
curbyt = 0
loc  = 0
entry = 0
rand = 0
tapevis = 0
lvl3dp = 0

loopstack = []
lv2checkr = []
lv2loctrk = []
markstack = []

def banner():
    os.system("clear")
    print(
        '''
▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
\u258f  ___ ___    _   ___ _  _ ___                                 \u258f
\u258f | _ ) _ \  /_\ |_ _| \| | __|/\_                             \u258f|-
\u258f | _ \   / / _ \ | || .` | _|>  <                             \u258f||
\u258f |___/_|_\/_/ \_\___|_|\_|_|  \/                              \u258f||
\u258f  ___ ___  ___   ___ ___    _   __  __ __  __ ___ _  _  ___   \u258f||
\u258f | _ \ _ \/ _ \ / __| _ \  /_\ |  \/  |  \/  |_ _| \| |/ __|  \u258f||
\u258f |  _/   / (_) | (_ |   / / _ \| |\/| | |\/| || || .` | (_ |  \u258f||
\u258f |_| |_|_\\\___/ \___|_|_\/_/ \_\_|  |_|_|  |_|___|_|\_|\___|  \u258f|-
\u258f                                                              \u258f
▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔'''
    )

    
# BASIC CHECKS FOR OOB ARRAY ACCESS
def checkdp():
    if (dp < 0 or dp > (TAPESIZE-1)):
        print("               [ERROR]                ")
        print("----DATA-POINTER-WENT-OUT-THE-TAPE----")
        sleep(0.1)
        print("           ---------------            ")
        print("=========== E X I T I N G ============")
        print("           ---------------            ")
        exit(-1)

def parantherr():
    print("               [ERROR]                ")
    print("-------UNMATCHED-LOOP-OPERATOR--------")
    sleep(0.1)
    print("           ---------------            ")
    print("=========== E X I T I N G ============")
    print("           ---------------            ")
    exit(-1)

# SETUP RANDOM EQUATION
def generate_sum(sum,n):
    l = []
    num = sum
    for i in range (n):
        x = random.randint(3,255)
        num = num - x
        l.append(x)
    if(num < 0):
        num = num + 0x100
    l.append(num)
    return l

def generate_dif(sum,n):
    l = []
    num = sum
    for i in range (n):
        x = random.randint(3,255)
        num = (num + x) & 0xff
        l.append(x)
    if(num < 0):
        num = num + 0x100
    l.append(num)
    return l

def findmatch(code,pc,p):
    tmp = []
    offset = 1 if p == "[" else -1
    idx = pc + offset
    ptype = {"[":"]","]":"["}
    while(idx < len(code) and idx >= 0):
        if(code[idx] == p):
            tmp.append(idx)
        if(code[idx] == ptype[p]):
            if(len(tmp)):
                tmp.pop(-1)
            else:
                return idx
        idx += offset
    return parantherr()

# READING IN THE CODE WHICH IS TO BE RUN
def readincode(nbytes : int):
    code = ""
    flag = 1
    while(flag):
        ins = sys.stdin.read(1)
        if(type(ins) == bytes):
            ins = ins.decode()
        code += ins
        if "\n" in code: flag = 0
    end = code.find("\n")
    return code[0:end]

def readflag():
    banner()
    global flag,flag1,flag2,flag3
    flag = os.environ['FLAG'] + " "
    print("▍[+] FLAG HAS BEEN READ IN :")
    flag1 = flag[0:len(flag)//3]
    flag2 = flag[len(flag)//3:int((len(flag)//3)*2)]
    flag3 = flag[int((len(flag)//3)*2)::]
    print(f"▍[+] THE FLAG PARTS ARE OF THE FOLLOWING LENGTH : {len(flag1)} {len(flag2)} {len(flag3)}")
    print("▍[+] YOU DO NOT HAVE TO WORRY ABOUT THE USUAL '.' AND ',' INSTRUCTIONS")
    print("▍    WE HAVE REMOVED THEM FOR YOU")
    print("----------------------------------------------------------------")
    return flag

def set_rand():
    global rand
    rand = int.from_bytes(os.urandom(8),byteorder="little")
    return rand

def placenreset(flag):
    global tape,curbyt,loc,loopstack,dp,fakeflag,entry
    tape = [0 for i in range (TAPESIZE)]
    if(tapevis != 1):
        dp  = random.randint(0,30000)
    else: # DEBUG MODE FUNCTIONS
        dp = 0
        loc = random.randint(0,0x100)
        print(f"▍ YOU HAVE BEEN DROPPED A BYTE OF THE FAKE FLAG AT > [{loc}]",flush=True)
        tape[loc] = ord(fakeflag[curbyt])
        loopstack=[]
        return
    if(tapevis != 1):
        try:
            l1 = random.randint(dp + 0x100,30000) 
            l2 = random.randint(0,dp + 0x100) 
            loc = l1 if abs(l1-dp) > abs(l2-dp) else l2
        except:
            loc = random.randint(0,dp)
        entry = dp
        print(f"▍ THERE IS A BYTE OF THE FLAG DROPPED AT INDEX OF TAPE > [{loc}]",flush=True)
        tape[loc] = ord(flag[curbyt])
        loopstack=[]
    
def lvl2bytemangler():
    global lv2checkr,tape,lv2loctrk,markstack,dp
    dp  = random.randint(0,30000)
    lv2checkr = []
    markstack = []
    for i in range (len(flag2)):
        lv2checkr.append(random.randint(40,255))
    tape = [0 for i in range (TAPESIZE)]
    for i in range (len(lv2checkr)):
        l = random.randint(0,30000)
        lv2loctrk.append(l)
        tape[l] = lv2checkr[i]
    print("")
    print(f"▍ THE BYTES ARE TO BE MARKED IN THE INDEXES IN THE FOLLOWING ORDER -")
    print("▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭▭")
    for i in range (len(lv2loctrk)):
        print(f"[{lv2loctrk[i]}]",end=" ")
    print("\n")

def lvl2bytechecker():
    global dp
    print("\n▍ marked bytes :",markstack)
    if(len(markstack) < len(lv2loctrk)):
        print("\n▍ YOUR TRY HAS ENDED IN A FAILURE THERE ARE MORE BYTES TO MARK [EXITING]")
        exit(1337)
    if(len(markstack) > len(lv2checkr)):
        print("\n▍ THERE ARE UNNECESSARY MARKINGS [EXITING]")
        exit(1337)
    for i in range (len(markstack)):
        if((markstack[i]) != (lv2loctrk[i])):
            print("\n▍ YOU HAVE UNMATCHED ENTRIES IN YOUR MARKINGS [EXITING]")
            exit(1337)
    print("▍ YOU HAVE SUCCESFULLY COMPLETED THE LEVEL HERE TAKE THIS --")
    print(f"▍ 2ND THIRD OF THE FLAG >> {flag2}" )

def debug():
    global tapevis
    if(tapevis == 0):
        return
    os.system("clear")
    print("")
    print("▕",end="")
    for i in range (51):
        print("▔▔",end="")
    print("▔▏")
    if(dp>=5):
        print("▕  ",end="")
        for i in range (10):
            if(tapevis != 3):
                if(i-5==0):
                    print((f"\033[1;31m[\033[0m{dp+i-5}\033[1;31m]\033[0m".center(29," "))," ",end="")
                    continue
                else: print((f"[{dp+i-5}]".center(7," "))," ",end="")
            if(tapevis == 3):
                    if(lvl3dp+i-5 == dp):
                        print((f"\033[1;31m[\033[0m{lvl3dp+i-5}\033[1;31m]\033[0m".center(29," "))," ",end="")
                        continue
                    else: print((f"[{lvl3dp+i-5}]".center(7," "))," ",end="")
        print(" <<  {dp}  ▏")
        print("▕ -",end="")
        for i in range (10):
            print("---------",end="")
        print("           ▏")
        print("▕ |",end="")
        if(tapevis == 1):
            for i in range (10):
                if(dp+i-5==loc):
                    print(((f"\033[1;31mX\033[0m").center(18," ")),"|",end="")
                    continue
                if(i-5==0):
                    print(((f"\033[1;31m{tape[dp+i-5]}\033[0m").center(18," ")),"|",end="")
                    continue
                print((f"{tape[dp+i-5]}".center(7," ")),"|",end="")
        elif (tapevis == 3):
           for i in range (lvl3dp-5,lvl3dp+5):
                if(i==loc):
                    print(((f"\033[1;31mX\033[0m").center(18," ")),"|",end="")
                    continue
                if(i==dp):
                    print(((f"\033[1;31m?\033[0m").center(18," ")),"|",end="")
                    continue
                print((f"*".center(7," ")),"|",end="")
        else:
            for i in range (10):
                if(tapevis == 2 and dp+i-5==entry):
                    print(((f"\033[1;31m{tape[entry]}\033[0m").center(18," ")),"|",end="")
                    continue
                if(dp+i-5==loc):
                    print(((f"\033[1;31mX\033[0m").center(18," ")),"|",end="")
                    continue
                if(i-5==0):
                    print(((f"\033[1;31m?\033[0m").center(18," ")),"|",end="")
                    continue
                print((f"?".center(7," ")),"|",end="")
        print(" << {tape} ▏")
        print("▕  ",end="")
        for i in range (50):
            print("  ",end="")
        print(" ▏")
        print(" ",end="")
        for i in range (51):
            print("▔▔",end="")
        print("▔")
        sleep(0.1)
    else:
        print("▕  ",end="")
        for i in range (10):
            if(i==dp):
                print((f"\033[1;31m[\033[0m{dp}\033[1;31m]\033[0m".center(29," "))," ",end="")
                continue
            print((f"[{i}]".center(7," "))," ",end="")
        print(" <<  {dp}  ▏")
        print("▕ -",end="")
        for i in range (10):
            print("---------",end="")
        print("           ▏")
        print("▕ |",end="")
        if(tapevis == 1):
            for i in range (10):
                if(i==loc):
                    print(((f"\033[1;31mX\033[0m").center(18," ")),"|",end="")
                    continue
                if(i==dp):
                    print(((f"\033[1;31m{tape[dp]}\033[0m").center(18," ")),"|",end="")
                    continue
                print((f"{tape[i]}".center(7," ")),"|",end="")
        else:
            for i in range (10):
                if(tapevis == 2 and i==entry):
                    print(((f"\033[1;31m{tape[entry]}\033[0m").center(18," ")),"|",end="")
                    continue
                if(i==loc):
                    print(((f"\033[1;31mX\033[0m").center(18," ")),"|",end="")
                    continue
                if(i==dp):
                    print(((f"\033[1;31m?\033[0m").center(18," ")),"|",end="")
                    continue
                print((f"?".center(7," ")),"|",end="")
        print(" << {tape} ▏")
        print("▕  ",end="")
        for i in range (50):
            print("  ",end="")
        print(" ▏")
        print(" ",end="")
        for i in range (51):
            print("▔▔",end="")
        print("▔")
        sleep(0.1)

def run(code):
    global pc,dp
    pc = 0
    while (pc != len(code)):
        debug()
        if(code[pc] == ">"):
            dp += 1
            checkdp()
            pc += 1
            continue
        if(code[pc] == "<"):
            dp -= 1
            checkdp()
            pc += 1
            continue
        if(code[pc] == "+"):
            tape[dp] = (tape[dp] + 1) % 0x100
            pc += 1
            continue
        if(code[pc] == "-"):
            tape[dp] = (tape[dp] - 1) % 0x100
            pc += 1
            continue
        if(code[pc] == "["):
            if(tape[dp] == 0):
                idx = findmatch(code,pc,"[")
                pc = idx + 1
                continue
            else:
                loopstack.append(pc)
                pc += 1
                continue
        if(code[pc] == "]"):
            if(tape[dp] != 0):
                if(len(loopstack)):
                    pc = loopstack.pop(-1)
                    continue
            else:
                if(len(loopstack)):
                    loopstack.pop(-1)
                else:
                    parantherr()
                pc += 1
                continue
        if(code[pc] == "."):
            markstack.append(dp)
            pc += 1
            continue
        else:
            pc += 1
            continue
def test():
    global curbyt
    global tapevis
    global fakeflag
    curbyt = 0
    while (curbyt < len(flag1)):
        print("▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁")
        print("▌     NEXT BYTE      ▐")
        print("▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔")
        placenreset(fakeflag)
        print("▍ INPUT YOUR CODE : ",end="",flush=True)
        code = readincode(0xff)
        set_rand()
        run(code)
        debug()
        print('''\n┏▏ RESULT :         ''')
        print("┃▏ DATA POINTER AT -",dp)
        print(f"┗▏ THIS IS YOUR ONE BYTE -- [{((tape[entry]))}]")
        print("▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁")
        curbyt += 1

def level1():
    global curbyt
    global tapevis
    global flag1
    curbyt = 0
    print('''DO YOU WANT TO VIEW THE TAPE IN THIS RUN ?  
 ✦  ▏ YES - Y                     
 ✦  ▏ NO  - N                   
▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
          
Your choice : ''',end="")
    d = input()

    while (curbyt < len(flag1)):
        tapevis = 2 if "Y" in d else 0
        print("▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁")
        print("▌     NEXT BYTE      ▐")
        print("▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔")
        placenreset(flag1)
        # tapevis = 1
        print("▍ DATA POINTER IS AT :",dp)
        print(f"▍ THE BYTE AT THE CURRENT DATA POINTER - {dp} - WILL BE SHOWN TO YOU AFTER PROGRAM EXECUTION")
        print("▍ READING IN CODE OF NO OF BYTES -",35)
        print("▍ INPUT YOUR CODE : ",end="",flush=True)
        code = readincode(32)
        set_rand()
        run(code)
        tapevis = 2
        debug()
        print('''\n┏▏ RESULT :         ''')
        print("┃▏ DATA POINTER AT -",dp)
        print(f"┗▏ THIS IS YOUR ONE BYTE -- [{((tape[entry]))}]")
        print("▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁")
        curbyt += 1

def level2():
    global curbyt
    global tapevis
    global flag1
    curbyt = 0
    print('''DO YOU WANT TO VIEW THE TAPE IN THIS RUN ?  
 ✦  ▏ YES - Y                     
 ✦  ▏ NO  - N                   
▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
          
Your choice : ''',end="")
    d = input()
    print("\n\033[1;30m――CHALLENGE SUMMARY――――――――――――――――――――――\033[0m")
    print("▍ YOU HAVE TO SHOW THE RESPECTIVE INDEXES \n▍ IN THE CORRECT ORDER SPECIFIED")
    print("▍ ON DOING THAT THE SECOND PART OF THE FLAG WILL BE SHOWN ")
    print("▍ USING THE . INSTRUCTION [UNLIKE THE USUAL BRAINF**K] WILL SHOW BYTES IF THE ORDER MATCHES")
    print("▍ THE BYTES YOU SHOW WILL ONLY BE SHOWN IN THE END OF PROGRAM RUN")
    print("")
    print("▍ [+] YOU DONT NEED TO KEEP THE BYTES AT THE LOCATIONS TO BE INTACT TO RECIEVE THE FLAG")
    print("▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁")
    tapevis = 3 if "Y" in d else 0
    lvl2bytemangler()
    print("▍ DATA POINTER IS AT : ",dp)
    print("▍ READING IN CODE OF NO OF BYTES MAXIMUM 0x350")
    print("▍ INPUT YOUR CODE : ",end="",flush=True)
    code = readincode(0x350)
    set_rand()
    run(code)
    tapevis = 3
    lvl2bytechecker()
    debug()
    print('''\n┏▏ RESULT :         ''')
    print("┃▏ DATA POINTER AT -",dp)
    print(f"┗▏ THIS IS YOUR ONE BYTE -- [{((tape[entry]))}]")
    print("▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁")
    curbyt += 1

def level3():
    global curbyt
    global flag3
    global tapevis
    global dp
    global lvl3dp
    print("\n▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔")
    print("▍ THE FRAME OF THE TAPE IN WHICH YOU INITIALLY LAND ON IS VISIBLE AFTER EXECUTION OF CODE")
    print("▍ LEAK THE FLAG SOMEHOW\n")
    curbyt = 0
    tapevis = 0
    while (curbyt < len(flag3)):
        placenreset(flag3)
        lvl3dp = dp
        print(f"▍ THE DATA POINTER WILL INITIALLY BE AT [{dp}]")
        print("▍ INPUT YOUR CODE : ",end="",flush=True)
        code = readincode(150)
        set_rand()
        tapevis = 0
        run(code)
        tapevis = 3
        debug()
        curbyt += 1

def main():
    global curbyt
    global tapevis
    readflag()
    print('''DO YOU WANT TO TEST OUT THE TAPE ?  
 ✦  ▏ YES - Y                     
 ✦  ▏ NO  - N                     
▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
          
Your choice : ''',end="")
    d = input()
    print("")
    tapevis = 1 if "Y" in d else 0
    if(tapevis == 1):
        test()
        return 
    else:
        level1()
        print("▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁")
        print("▌      LEVEL-1 COMPLETED       ▐")
        print("▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔")
        print("HOPING YOU GOT THE FIRST FLAG FRAGMENT")
        level2()
        print("▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁")
        print("▌      LEVEL-2 COMPLETED       ▐")
        print("▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔")
        print(f"-> {flag2} <-")
        print("HOPING YOU GOT THE SECOND FLAG FRAGMENT")
        level3()
        print("▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁")
        print("▌      LEVEL-3 COMPLETED       ▐")
        print("▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔")
        print("CONGRATS OR NOT, DEPENDING ON IF YOU GOT THE LAST FRAGMENT")
    print("")
    return

if __name__== \
    "__main__":
    main()
