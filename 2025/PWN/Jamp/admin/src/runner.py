#!/bin/python3

from pwn import *

def showRes(byteData):
    decoded = ""
    for i in range (len(byteData)):
        decoded += chr(byteData[i])
    print(decoded)

def runPgm(fname):
    # TESTING EXPLOIT   
    context.log_level = "WARNING"
    p = process(["./JAMP",fname],raw=True)
    p.interactive(prompt="")

def readFile(nbytes : int):
    fl = b""
    i = 0 
    while(i < nbytes):
        byt = sys.stdin.buffer.read(1)
        fl += byt
        i += 1
    return fl
    
def main():
    sz = int(input("[RUNNER] Enter File Size : "))
    if(sz > 0x5000):
        print("[RUNNER] BYE : File Size too Long")
        exit(0)
        
    data = readFile(sz)
    with tempfile.NamedTemporaryFile('wb') as f:
            f.write(data)
            f.flush()
            pid = os.fork()
            if(pid == 0):
                print("[RUNNER] RUNNING JAMP ...")
                runPgm(f.name)
            else:
                status = os.wait()
                print("[RUNNER] BYE BYE !! ('v')/")
                if(os.path.isfile(f.name)):
                    os.remove(f.name)
                exit(0)

if __name__ == '__main__':
    main()
