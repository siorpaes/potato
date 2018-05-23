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

OBJECTS := main.o start.o ssd.o

all: spi.coe

spi.elf: $(OBJECTS)
	$(TARGET_LD) -o spi.elf $(TARGET_LDFLAGS) $(OBJECTS)
	$(TARGET_SIZE) spi.elf

spi.bin: spi.elf
	$(TARGET_OBJCOPY) -j .text -j .data -O binary spi.elf spi.bin

spi.coe: spi.bin
	echo "memory_initialization_radix=16;" > spi.coe
	echo "memory_initialization_vector=" >> spi.coe
	$(HEXDUMP) -v -e '1/4 "%08x\n"' spi.bin >> spi.coe
	echo ";" >> spi.coe

clean:
	-$(RM) $(OBJECTS)
	-$(RM) spi.elf spi.bin spi.coe

# Object file rules:

main.o: main.c ../../potato.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

start.o: ../start.S
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

ssd.o: ../../libsoc/ssd.c
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

