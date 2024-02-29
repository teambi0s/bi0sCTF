obj-m += palindromatic.o

all:
	make -C /home/k1r4/work/projects/kchall/linux M=$(PWD) modules

clean:
	rm -f .*.cmd
	rm -f *.ko
	rm -f *.o
	rm -f *.mod*
	rm -f Module.symvers
	rm -f modules.order