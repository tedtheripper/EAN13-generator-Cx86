CC=gcc
get_encoding.o: get_encoding.asm
	nasm -f elf64 -g -F dwarf get_encoding.asm
func.o: func.asm
	nasm -f elf64 -g -F dwarf func.asm
main.o: main.c
	$(CC) -m64 -std=c99 -g -c main.c
all: main.o func.o get_encoding.o
	$(CC) -m64 -g -o main main.o func.o get_encoding.o
