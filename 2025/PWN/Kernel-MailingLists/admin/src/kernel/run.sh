qemu-system-x86_64 \
    -m 128M \
    -smp 2 \
    -kernel kernel/bzImage \
    -initrd kernel/initrd.cpio.gz \
    -snapshot -monitor /dev/null -nographic -no-reboot \
    -append "console=ttyS0 kaslr kpti=1 panic=1 slab_nomerge panic_on_oops=1" \
    -cpu qemu64,+smep,+smap