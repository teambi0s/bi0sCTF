
# ============================================
# CREATE AN ~OK~OK INITRAMFS FOR QEMU TO USE 
# ===========================================

cd "$1"
    
    rm -rf initrd
    mkdir initrd
    cd initrd

        mkdir -p bin dev proc sys sbin tmp usr/bin usr/sbin etc root ctf
        cp "$2" ./ctf/exploit
        chmod +x ./ctf/exploit
        cp ../kernel/mailinglist.ko ./root/
        cp ../scripts/busybox bin/
        cp ../scripts/init .
        chmod +x init
        ln -s busybox bin/sh
        cat ../../../flag.txt > root/flag
        find . | cpio -o -H newc > ../initrd.cpio

    cd ..

    gzip -f initrd.cpio
    mv initrd.cpio.gz kernel/
cd .. 