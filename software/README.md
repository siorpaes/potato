A very trivial bootloader has been created so to ease software development and testing.
The bootloader (pre-built image can be found in "images" folder) emits a welcome message
over serial (@115200, 8N1) and waits for a 8kB binary image to be sent over UART.
Once the image has been received, the booloader jumps in the new application entry
point 0xffffc200.
The bootloader and application layouts had to be modified as follows in order to
implement this mechanism:


           Original configuration                       Bootloader                               Application             
    +-------------------------------+        +-------------------------------+       +-------------------------------+
    |                               |        |                               |       |                               |
    |                               |        |                               |       |                               |
    |                               |        |              RAM              |       |              RAM              |
    |                               |        | 0xffffe000                    |       |                               |
    |              RAM              |        ---------------------------------       ---------------------------------
    |                               |        |                               |       |                               |
    |                               |        |                               |       |                               |
    |                               |        |           Reserved            |       |              ROM              |
    | 0xffffc000                    |        |                               |       |                               |
    +-------------------------------+        +-------------------------------+       +-------------------------------+
    |                               |        |                               |       |            /    /    /        |
    |                               |        |                               |       |           /    /    /         |
    |                               |        |                               |       |          /    /    /          |
    |                               |        |                               |       |         /    /    /           |
    |              ROM              |        |              ROM              |       |        /    /    /            |
    |                               |        |                               |       |       /    /    /             |
    |                               |        |                               |       |      /    /    /              |
    |                               |        |                               |       |     /    /    /               |
    | 0xffff8000                    |        |                               |       |    -    -    -                |
    +-------------------------------+        +-------------------------------+       +-------------------------------+

See README file in "hello" folder for instructions on how to build application binary image.

You can simulate processor with
riscv32-unknown-elf-run --memory-region 0xffff8000,0x4000 --memory-region 0xffffc000,0x4000 application.elf

