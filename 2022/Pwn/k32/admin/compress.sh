#!/bin/sh
gcc -o exploit -static $1
sudo mv ./exploit ./rootfs
cd rootfs
sudo chmod +x exploit
sudo find . | sudo cpio -o -H newc > ../rootfs.cpio