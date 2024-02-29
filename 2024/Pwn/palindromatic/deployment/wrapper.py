import sys
import requests
import tempfile
import subprocess
from random import randint,choices
from time import sleep
import string

def echo(s: str):
    sys.stdout.write(s)
    sys.stdout.flush()

def PoW(l=20):
    x = randint(2**(l-1), 2**l)
    g = randint(2**16, 2**18)
    p = 13066599629066242837866432762953247484957727495367990531898423457215621371972536879396943780920715025663601432044420507847680185816504728360166754093930541
    target = pow(g, x, p)
    print(f"{g}^x mod {p} == {target}")
    try:
        solution = int(input("x: "))
        if solution == x:
            return True
        else:
            return False
    except:
        return False

if __name__ == "__main__":
    if not PoW():
        echo("[-] PoW failed!")
        exit(1)

    echo("Enter exploit download url: ")
    url = sys.stdin.readline().rstrip("\n")
    
    try:
        r = requests.get(url, timeout=10)
        if r.status_code != 200:
            raise Exception()
    except:
        echo("[-] Unable to download exploit!\n")
        exit(1)

    fname = "/files/"+''.join(choices(string.ascii_lowercase, k=8))
    with open(fname, "wb") as tmpf:
        tmpf.write(r.content)
        try:
            echo("[+] Exploit placed in /bin/pwn\n")
            sleep(4)
            subprocess.Popen(["./run.sh", fname]).wait(timeout=60)
        except:
            echo("[-] Error while running QEMU\n")
            exit(1)

    exit(0)