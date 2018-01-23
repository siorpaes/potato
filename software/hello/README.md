make
head -c8k /dev/zero > zeroes-8k.bin
head -c256 /dev/zero > zeroes-256.bin
#Prepend 256 bytes to image
cat zeroes-256.bin hello.bin zeroes-8k.bin | head -c8k > hello.img
#Send application to bootloader over UART
cat hello.img | pv -L 1000 > /dev/ttyUSB1 

