CC = g++
CFLAGS = -masm=intel -lseccomp
DBGFLAGS = -g -DDEBUG

all: clean
	$(CC) -o kowaiiVm src/kowaiiJitVm.cpp $(CFLAGS)
	$(CC) -o kowaiiVm.dbg src/kowaiiJitVm.cpp $(DBGFLAGS) $(CFLAGS)

clean:
	if [ -f kowaiiVm ]; then rm kowaiiVm; fi;
	if [ -f kowaiiVm.dbg ]; then rm kowaiiVm.dbg; fi;