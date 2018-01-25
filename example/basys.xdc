# The Potato Processor - A simple processor for FPGAs
# (c) Kristian Klomsten Skordal 2016 <kristian.skordal@wafflemail.net>
# Report bugs and issues on <https://github.com/skordal/potato/issues>

# Set operating conditions to improve temperature estimation:
set_operating_conditions -airflow 0
set_operating_conditions -heatsink low

# Clock signal:
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports {clk}];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk}];

# Reset button:
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports {reset_n}];

# GPIOs (Buttons):
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports {gpio_pins[0]}];
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {gpio_pins[1]}];
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33} [get_ports {gpio_pins[2]}];
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports {gpio_pins[3]}];

# GPIO (Switches):
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {gpio_pins[4]}];
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {gpio_pins[5]}];
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {gpio_pins[6]}];
set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33} [get_ports {gpio_pins[7]}];

# GPIOs (LEDs):
set_property -dict {PACKAGE_PIN U16  IOSTANDARD LVCMOS33} [get_ports {gpio_pins[8]}];
set_property -dict {PACKAGE_PIN E19  IOSTANDARD LVCMOS33} [get_ports {gpio_pins[9]}];
set_property -dict {PACKAGE_PIN U19  IOSTANDARD LVCMOS33} [get_ports {gpio_pins[10]}];
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports {gpio_pins[11]}];

# UART0:
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports {uart0_txd}];
set_property -dict {PACKAGE_PIN B18  IOSTANDARD LVCMOS33} [get_ports {uart0_rxd}];

# UART1 (pin 5 and 6 on JA, to match the pins on the PMOD-GPS):
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports {uart1_txd}];
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports {uart1_rxd}];

##7 segment display
set_property PACKAGE_PIN W7 [get_ports {segments[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segments[6]}]
set_property PACKAGE_PIN W6 [get_ports {segments[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segments[5]}]
set_property PACKAGE_PIN U8 [get_ports {segments[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segments[4]}]
set_property PACKAGE_PIN V8 [get_ports {segments[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segments[3]}]
set_property PACKAGE_PIN U5 [get_ports {segments[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segments[2]}]
set_property PACKAGE_PIN V5 [get_ports {segments[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segments[1]}]
set_property PACKAGE_PIN U7 [get_ports {segments[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {segments[0]}]

#set_property PACKAGE_PIN V7 [get_ports dp]
#set_property IOSTANDARD LVCMOS33 [get_ports dp]

set_property PACKAGE_PIN U2 [get_ports {anodes[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes[0]}]
set_property PACKAGE_PIN U4 [get_ports {anodes[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes[1]}]
set_property PACKAGE_PIN V4 [get_ports {anodes[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes[2]}]
set_property PACKAGE_PIN W4 [get_ports {anodes[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes[3]}]
