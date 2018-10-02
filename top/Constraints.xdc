## Clock and reset
set_property -dict {PACKAGE_PIN AC18    IOSTANDARD LVDS} [get_ports CLK_200MHZ_P]
set_property -dict {IOSTANDARD          LVDS} [get_ports CLK_200MHZ_N]
set_property -dict {PACKAGE_PIN W13     IOSTANDARD LVCMOS18} [get_ports RSTN]

## 7-SEGMENT LED
set_property -dict {PACKAGE_PIN M24     IOSTANDARD LVCMOS33} [get_ports SEGCLK]
set_property -dict {PACKAGE_PIN L24     IOSTANDARD LVCMOS33} [get_ports SEGDT]
set_property -dict {PACKAGE_PIN R18     IOSTANDARD LVCMOS33} [get_ports SEGEN]
set_property -dict {PACKAGE_PIN P19     IOSTANDARD LVCMOS33} [get_ports SEGCLR]

## LED
#set_property -dict {PACKAGE_PIN N26     IOSTANDARD LVCMOS33} [get_ports LEDCLK]
#set_property -dict {PACKAGE_PIN M26     IOSTANDARD LVCMOS33} [get_ports LEDDT]
#set_property -dict {PACKAGE_PIN N24     IOSTANDARD LVCMOS33} [get_ports LEDCLR]
#set_property -dict {PACKAGE_PIN R25     IOSTANDARD LVCMOS33} [get_ports LEDEN]

## Switch
set_property -dict {PACKAGE_PIN AA10    IOSTANDARD LVCMOS15} [get_ports {SW[0]}]
set_property -dict {PACKAGE_PIN AB10    IOSTANDARD LVCMOS15} [get_ports {SW[1]}]
set_property -dict {PACKAGE_PIN AA13    IOSTANDARD LVCMOS15} [get_ports {SW[2]}]
set_property -dict {PACKAGE_PIN AA12    IOSTANDARD LVCMOS15} [get_ports {SW[3]}]
set_property -dict {PACKAGE_PIN Y13     IOSTANDARD LVCMOS15} [get_ports {SW[4]}]
set_property -dict {PACKAGE_PIN Y12     IOSTANDARD LVCMOS15} [get_ports {SW[5]}]
set_property -dict {PACKAGE_PIN AD11    IOSTANDARD LVCMOS15} [get_ports {SW[6]}]
set_property -dict {PACKAGE_PIN AD10    IOSTANDARD LVCMOS15} [get_ports {SW[7]}]
set_property -dict {PACKAGE_PIN AE10    IOSTANDARD LVCMOS15} [get_ports {SW[8]}]
set_property -dict {PACKAGE_PIN AE12    IOSTANDARD LVCMOS15} [get_ports {SW[9]}]
set_property -dict {PACKAGE_PIN AF12    IOSTANDARD LVCMOS15} [get_ports {SW[10]}]
set_property -dict {PACKAGE_PIN AE8     IOSTANDARD LVCMOS15} [get_ports {SW[11]}]
set_property -dict {PACKAGE_PIN AF8     IOSTANDARD LVCMOS15} [get_ports {SW[12]}]
set_property -dict {PACKAGE_PIN AE13    IOSTANDARD LVCMOS15} [get_ports {SW[13]}]
set_property -dict {PACKAGE_PIN AF13    IOSTANDARD LVCMOS15} [get_ports {SW[14]}]
set_property -dict {PACKAGE_PIN AF10    IOSTANDARD LVCMOS15} [get_ports {SW[15]}]

## PS2
set_property -dict {PACKAGE_PIN N18     IOSTANDARD LVCMOS33 PULLUP true} [get_ports PS2_CLK]
set_property -dict {PACKAGE_PIN M19     IOSTANDARD LVCMOS33 PULLUP true} [get_ports PS2_DATA]

# VGA
set_property -dict {PACKAGE_PIN N21 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_R[0]}]
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_R[1]}]
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_R[2]}]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_R[3]}]
set_property -dict {PACKAGE_PIN R22 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_G[0]}]
set_property -dict {PACKAGE_PIN R23 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_G[1]}]
set_property -dict {PACKAGE_PIN T24 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_G[2]}]
set_property -dict {PACKAGE_PIN T25 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_G[3]}]
set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_B[0]}]
set_property -dict {PACKAGE_PIN R20 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_B[1]}]
set_property -dict {PACKAGE_PIN T22 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_B[2]}]
set_property -dict {PACKAGE_PIN T23 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports {VGA_B[3]}]
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports VGA_VS]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports VGA_HS]

# UART
set_property -dict {PACKAGE_PIN L25 IOSTANDARD LVCMOS33 PULLUP true} [get_ports UART_RX]
#set_property -dict {PACKAGE_PIN P24 IOSTANDARD LVCMOS33 DRIVE 16 SLEW FAST PULLUP true} [get_ports UART_TX]
