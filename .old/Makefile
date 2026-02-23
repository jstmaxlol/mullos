all:
	# assemble bootloader
	nasm -f bin src/boot.asm -o build/boot.bin
	nasm -f elf32 src/boot_s2.asm -o build/boot_s2.o
	# compile kernel
	gcc -m32 -ffreestanding -nostdlib -c src/krn/mkern.c -o build/mkernel.o
	# link
	ld -m elf_i386 -T src/linker.ld -nostdlib -o build/s2.elf build/boot_s2.o build/mkernel.o
	objcopy -O binary build/s2.elf build/s2.bin
	# make .img
	cat build/boot.bin build/s2.bin > build/mullos.img
	# qemu test
	qemu-system-x86_64 -drive format=raw,file=build/mullos.img

clean:
	rm -vf build/*

