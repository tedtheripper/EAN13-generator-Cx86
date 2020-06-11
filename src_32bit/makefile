CC=gcc
main.o: main.c
	$(CC) -m32 -g -std=c99 -c main.c
func.o: func.asm
	nasm -f elf32 -g -F dwarf func.asm
get_encoding.o: get_encoding.asm
	nasm -f elf32 -g -F dwarf get_encoding.asm
all: main.o func.o get_encoding.o
	$(CC) -m32 -g -o main main.o func.o get_encoding.o
