# habitude/bonne pratiques: une regle "all" tout en haut

#je récupère la list des .c
C_FILE=$(wildcard *.c)

#je fabrique la liste des .o depuis la liste des .c
OBJ_FILE=$(patsubst %.c, %.o, $(C_FILES))


all:help

help:
  echo "PLease tpe either 'make build' or 'make clean'"

build: helloworld

helloworld:
  gcc -o helloworld main.o lib.o

main.o:
  gcc -c -o main.o main.c

main.o: lib.h

lib.o:
  gcc -c -o lib.o lib.c

clean:
  rm -f *.o helloworld
