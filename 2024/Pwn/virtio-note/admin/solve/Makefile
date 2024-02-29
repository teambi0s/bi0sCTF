obj-m += virtio-note.o

all:
	make -C ../src/linux M=$(PWD) modules
	musl-gcc -o exploit exploit.c -no-pie -static

clean:
	rm -f .*.cmd
	rm -f *.ko
	rm -f *.o
	rm -f *.mod*
	rm -f Module.symvers
	rm -f modules.order
	rm -f exploit