# The Potato Processor Software Components
# (c) Kristian Klomsten Skordal 2015 <kristian.skordal@wafflemail.net>
# Report bugs and issues on <https://github.com/skordal/potato/issues>

.PHONY: all clean

TARGET_PREFIX ?= riscv32-unknown-elf
TARGET_CC := $(TARGET_PREFIX)-gcc
TARGET_LD := $(TARGET_PREFIX)-gcc
TARGET_SIZE := $(TARGET_PREFIX)-size
TARGET_OBJCOPY := $(TARGET_PREFIX)-objcopy
HEXDUMP ?= hexdump

TARGET_CFLAGS +=  -march=rv32i -Wall -Os -fomit-frame-pointer \
	-ffreestanding -fno-builtin -I../.. -I../../libsoc -std=gnu99 \
	-Wall -Werror=implicit-function-declaration
TARGET_LDFLAGS += -march=rv32i -nostartfiles -L../libsoc \
	-Wl,-m,elf32lriscv --specs=nosys.specs -Wl,-T../potato.ld \
	-Wl,--gc-sections

OBJECTS := main.o start.o

all: ssd.coe

ssd.elf: $(OBJECTS)
	$(TARGET_LD) -o ssd.elf $(TARGET_LDFLAGS) $(OBJECTS)
	$(TARGET_SIZE) ssd.elf

ssd.bin: ssd.elf
	$(TARGET_OBJCOPY) -j .text -j .data -O binary ssd.elf ssd.bin

ssd.coe: ssd.bin
	echo "memory_initialization_radix=16;" > ssd.coe
	echo "memory_initialization_vector=" >> ssd.coe
	for i in $$(seq 0 63); do echo 00000013 >> ssd.coe; done
	$(HEXDUMP) -v -e '1/4 "%08x\n"' ssd.bin >> ssd.coe
	echo ";" >> ssd.coe

clean:
	-$(RM) $(OBJECTS)
	-$(RM) ssd.elf ssd.bin ssd.coe

# Object file rules:

main.o: main.c ../../potato.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

start.o: ../start.S
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

