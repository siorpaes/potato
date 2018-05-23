make
head -c8k /dev/zero > zeroes-8k.bin
#Create 8kB image
cat hello.bin zeroes-8k.bin | head -c8k > hello.img
#Send application to bootloader over UART
cat hello.img | pv -L 1000 > /dev/ttyUSB1 

