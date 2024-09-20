SRC = mpihello.c
OBJ = mpihello.o
CC  = cc
CFLAGS = -O2

mpihello: mpihello.o
	$(CC) -o mpihello $(OBJ)


mpihello.o: mpihello.c
	$(CC) -o $(OBJ) -c $(SRC) $(CFLAGS)

clean:
	rm -rf mpihello $(OBJ)
