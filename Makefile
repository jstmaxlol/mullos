CC              = gcc
LD              = ld

CFLAGS          = -std=gnu11 -ffreestanding -O2 -Wall -Wextra -m64 \
                  -nostdlib -nostartfiles -I src/kernel/headers
LDFLAGS         = -T linker.ld -nostdlib -static

SRC_DIR         = src/kernel
BUILD_DIR       = build
ISO_DIR         = $(BUILD_DIR)/iso
BOOT_DIR        = $(ISO_DIR)/boot
LIMINE_DIR      = /usr/share/limine

SOURCES         = $(wildcard $(SRC_DIR)/*.c)
OBJECTS         = $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SOURCES))

KERNEL          = $(BUILD_DIR)/kernel.elf
ISO_IMAGE       = $(BUILD_DIR)/mullos.iso

all: $(KERNEL)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(KERNEL): $(OBJECTS)
	$(LD) $(OBJECTS) $(LDFLAGS) -o $(KERNEL)

iso: $(KERNEL)
	rm -vrf $(ISO_DIR)
	mkdir -p $(BOOT_DIR)

	cp $(KERNEL) $(BOOT_DIR)/kernel.elf
	cp limine.conf $(ISO_DIR)/limine.conf

	# copy limine boot files
	cp $(LIMINE_DIR)/limine-bios.sys $(ISO_DIR)/
	cp $(LIMINE_DIR)/limine-bios-cd.bin $(ISO_DIR)/
	cp $(LIMINE_DIR)/limine-uefi-cd.bin $(ISO_DIR)/

	xorriso -as mkisofs \
		-b limine-bios-cd.bin \
		-no-emul-boot \
		-boot-load-size 4 \
		-boot-info-table \
		--efi-boot limine-uefi-cd.bin \
		-efi-boot-part --efi-boot-image \
		--protective-msdos-label \
		$(ISO_DIR) -o $(ISO_IMAGE)

	limine bios-install $(ISO_IMAGE)

run: iso
	qemu-system-x86_64 -cdrom $(ISO_IMAGE)

clean:
	rm -vrf $(BUILD_DIR)
