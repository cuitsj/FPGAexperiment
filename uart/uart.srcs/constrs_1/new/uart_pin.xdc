/////////////////////////////系统时钟和复位////////////////////////////////////
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports clk]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports rst]

/////////////////////////////串口/////////////////////////////////////////////
set_property -dict {PACKAGE_PIN N5 IOSTANDARD LVCMOS33} [get_ports rx_pin]
set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS33} [get_ports tx_pin]