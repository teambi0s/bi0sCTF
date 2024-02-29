import sys
import requests
import tempfile
import subprocess
from random import randint
from time import sleep
import os

def echo(s: str):
    sys.stdout.write(s)
    sys.stdout.flush()

def PoW(l=23):
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

def readJS():
    echo("JS File size: ")
    size = int(sys.stdin.readline().strip())
    if size > 1024*1024:
        echo("Too large!\n")
        sys.exit(1)
    echo("JS Data: ")
    return sys.stdin.read(size)

def readArchive():
    echo("Exploit archive download url: ")
    url = sys.stdin.readline().rstrip("\n")
    try:
        r = requests.get(url, timeout=10)
        if r.status_code != 200:
            raise Exception()
    except:
        echo("[-] Unable to download exploit archive!\n")
        exit(1)
    return r.content

if __name__ == "__main__":
    if not PoW():
        echo("[-] PoW failed!")
        exit(1)

    jsfile = tempfile.NamedTemporaryFile(mode="w")
    jsfile.write(readJS())
    jsfile.flush()

    archive = tempfile.NamedTemporaryFile(mode="wb")
    archive.write(readArchive())
    archive.flush()

    try:
        echo("[+] Archive placed in /tmp/file\n")
        sleep(4)
        subprocess.Popen(["./run.sh", archive.name, jsfile.name]).wait(timeout=300)
    except:
        echo("[-] Error while running QEMU\n")
        exit(1)

    exit(0)