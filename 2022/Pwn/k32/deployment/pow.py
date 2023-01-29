#!/bin/python3

import requests
from string import ascii_lowercase, ascii_uppercase, digits
from random import choices
from time import sleep
import os
import sys
import hashlib

def write(x):
    sys.stdout.write(x)
    sys.stdout.flush()

def readline():
    return sys.stdin.readline().rstrip("\n")

def PoW():
    x = os.urandom(16)
    target = hashlib.md5(x).hexdigest()
    write(f"MD5(X = {x[:13].hex()}+{'?'*6}) = " + target + "\n")
    try:
        write("X : ")
        if bytes.fromhex(readline()) == x:
            return
        else:
            write("[-] PoW failed!\n")
            exit()
    except:
        write("[-] PoW failed!\n")
        exit()


def randstr(k):
    return ''.join(choices(ascii_lowercase+ascii_uppercase+digits, k=k))


def get_exp():
    write("Exploit binary download link: ")
    uri = readline()

    try:
        if not uri.startswith("http"):
            raise Exception("Invalid URL!")
        exp = requests.get(uri)
        if exp.status_code != 200:
            print(exp.status_code)
            raise Exception("Not found!")
        else:
            exp = exp.content
    except:
        write("[-] Invalid URL!")
        exit()

    workdir = "/tmp/%s" % randstr(8)
    os.mkdir(workdir)
    open(workdir+"/exploit","wb+").write(exp)

    write("\n")
    write("[+] Exploit downloaded! Will be available at /exploit inside QEMU\n")
    write("\n")
    sleep(6)

    return workdir


def cleanup():
    count = 0
    for _ in os.listdir("/tmp"):
        count += 1
    if count > 50:
        os.system("rm -rf /tmp/*")

def run_vm(workdir):
    try:
        os.chdir(workdir)
        os.mkdir("rootfs")
        os.system("cd rootfs && cat /pwn/rootfs.cpio | cpio --extract")
        os.system("cp exploit rootfs/exploit")
        os.system("chmod 0777 rootfs/exploit")
        os.system("cd rootfs && find . | cpio -o -H newc > ../rootfs.cpio")
        os.system("rm -rf rootfs")
        os.chdir("/pwn")
        os.system("./run.sh %s/rootfs.cpio && rm -r %s" % (workdir,workdir))
        os.system(f"rm -rf {workdir}")
        write("Bye!\n")
        exit()
    except:
        os.system(f"rm -rf {workdir}")
        write("[-] Error occured, bye!\n")
        exit()


if __name__ == "__main__":
    PoW()
    cleanup()
    workdir = get_exp()
    run_vm(workdir)
