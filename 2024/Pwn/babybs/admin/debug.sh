gdb \
-ex 'set architecture i8086' \
-ex 'target remote localhost:1234' \
-ex 'b *0x7C00' \
-ex 'display /8i ($cs*16)+$pc' \
-ex 'display /gx 0x7c1b' \
-ex 'display /gx 0x7c09' \
-ex 'display /i 0x7c1b' 
