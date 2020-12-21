set_property SRC_FILE_INFO {cfile:F:/FPGAexperiment1/uart/uart.srcs/constrs_1/new/uart_pin.xdc rfile:../../../uart.srcs/constrs_1/new/uart_pin.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:1 export:INPUT save:INPUT read:READ} [current_design]
/////////////////////////////系统时钟和复位////////////////////////////////////
set_property src_info {type:XDC file:1 line:2 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports clk]
set_property src_info {type:XDC file:1 line:3 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports rst]
set_property src_info {type:XDC file:1 line:5 export:INPUT save:INPUT read:READ} [current_design]
/////////////////////////////串口/////////////////////////////////////////////
set_property src_info {type:XDC file:1 line:6 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict {PACKAGE_PIN N5 IOSTANDARD LVCMOS33} [get_ports rx_pin]
set_property src_info {type:XDC file:1 line:7 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS33} [get_ports tx_pin]
