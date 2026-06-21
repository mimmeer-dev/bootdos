.PHONY: main

main:
	nasm -fbin -o floppy.img src/boot.asm
	qemu-system-i386 -fda floppy.img -monitor stdio