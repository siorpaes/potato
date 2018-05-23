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

TARGET_CFLAGS +=  -march=rv32i -Wall -O0 -fomit-frame-pointer \
	-ffreestanding -fno-builtin -I../.. -I../../libsoc -std=gnu99 \
	-Wall -Werror=implicit-function-declaration
TARGET_LDFLAGS += -march=rv32i -nostartfiles -L../libsoc \
	-Wl,-m,elf32lriscv --specs=nosys.specs -Wl,-T../potato.ld \
	-Wl,--gc-sections

OBJECTS := main.o start.o

all: crashme.coe

crashme.elf: $(OBJECTS)
	$(TARGET_LD) -o crashme.elf $(TARGET_LDFLAGS) $(OBJECTS)
	$(TARGET_SIZE) crashme.elf

crashme.bin: crashme.elf
	$(TARGET_OBJCOPY) -j .text -j .data -O binary crashme.elf crashme.bin

crashme.coe: crashme.bin
	echo "memory_initialization_radix=16;" > crashme.coe
	echo "memory_initialization_vector=" >> crashme.coe
	$(HEXDUMP) -v -e '1/4 "%08x\n"' crashme.bin >> crashme.coe
	echo ";" >> crashme.coe

clean:
	-$(RM) $(OBJECTS)
	-$(RM) crashme.elf crashme.bin crashme.coe

# Object file rules:

main.o: main.c ../../potato.h
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

start.o: ../start.S
	$(TARGET_CC) -c -o $@ $(TARGET_CFLAGS) $<

