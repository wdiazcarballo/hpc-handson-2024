GCC_VER = gcc-10.3.0
FX700_DIR = /cloud_opt/a64fx/non-support/hpc/fx700/$(GCC_VER)

CC      = gcc
ifeq ($(shell uname -m),aarch64)
CC      = $(FX700_DIR)/bin/gcc
endif
ifeq ($(shell uname -m),x86_64)
CC      = $(FX700_DIR)/../../cross/$(GCC_VER)/bin/aarch64-linux-gnu-gcc
endif

CFLAGS  = -O3 -march=armv8.2-a+sve+fp16 -mtune=a64fx
CFLAGS += -fopenmp -I$(FX700_DIR)/include
LDFLAGS = -fopenmp -lm -lgfortran
LDFLAGS+= -L$(FX700_DIR)/lib -L$(FX700_DIR)/lib64 -llapack -lopenblas

test.exe: IterRef.o
	$(CC) -o $@ $< $(LDFLAGS)
IterRef.o: IterRef.c
	$(CC) -c $(CFLAGS) -o $@ $<
clean:
	\rm *.o test.exe

