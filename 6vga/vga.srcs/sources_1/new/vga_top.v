//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/20 18:43:34
// Design Name: 
// Module Name: vga_disp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_top(clk,rst,hsync,vsync,vga_rgb);
input clk;
input rst;

output hsync;
output vsync;
output [11:0] vga_rgb;


wire clk_25m;
wire [9:0] h_cnt;
wire [9:0] v_cnt;
//reg[11:0]vga_data;





    clk_wiz_0 u_clk_wiz_0
    (
    //Clockinports
    .clk_in1(clk),//inputclk_in1
    //Clockoutports
    .clk_out1(clk_25m),//outputclk_out1
    //Statusandcontrolsignals
    .reset(~rst));
	

	vga_640x480 u_vga_640x480(
		.clk(clk_25m),
		.rst(rst),
		.hsync(hsync),
		.vsync(vsync),
		.h_cnt(h_cnt),
		.v_cnt(v_cnt)
		);
		
	vga_disp u_vga_disp(
        .clk(clk_25m),
        .rst(rst),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .vga_rgb(vga_rgb)
	);


endmodule


