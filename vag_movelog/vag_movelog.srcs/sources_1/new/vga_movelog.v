//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/20 21:27:32
// Design Name: 
// Module Name: vga_movelog_top
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

module vga_movelog_top(clk,rst_n,hsync,vsync,vga_r,vga_g,vga_b);
	input clk;
	input rst_n;

	output hsync;
	output vsync;
	output[3:0]vga_r;
	output[3:0]vga_g;
	output[3:0]vga_b;

	wire rst;
	assign rst=~rst_n;

	wire pclk;
	wire valid;
	wire[9:0]h_cnt;
	wire[9:0]v_cnt;
	reg[11:0]vga_data;

	reg[13:0]rom_addr;
	wire[11:0]douta;

	wire logo_area;
	reg[9:0]logo_x;
	reg[9:0]logo_y;
	parameter[9:0]logo_length=10'b0010101001;//169
	parameter[9:0]logo_hight=10'b0001001110;//78

	reg[7:0]speed_cnt;
	wire speed_ctrl;

	reg[3:0]flag_edge;

	clk_wiz_0 u_clk_wiz_0
	(
		//Clockinports
		.clk_in1(clk),//inputclk_in1
		//Clockoutports
		.clk_out1(pclk),//outputclk_out1
		//Statusandcontrolsignals
		.reset(rst)
	);

	
	blk_mem_gen_0 u1(
		.clka(pclk),//inputwireclka
		.ena(1),
		.addra(rom_addr),//inputwire[13:0]addra
		.douta(douta)//outputwire[11:0]douta
	);

	vga_640x480 u2(
		.pclk(pclk),
		.reset(rst),
		.hsync(hsync),
		.vsync(vsync),
		.valid(valid),
		.h_cnt(h_cnt),
		.v_cnt(v_cnt)
	);

	assign logo_area = ((v_cnt>=logo_y)&(v_cnt<=logo_y+logo_hight-1)&(h_cnt>=logo_x)&(h_cnt<=logo_x+logo_length-1))?1'b1:1'b0;


	always @(posedge pclk) begin:logo_display
		if(rst==1'b1)
			vga_data<=0;
		else begin
			if(valid==1'b1) begin
				if(logo_area==1'b1) begin
					rom_addr<=rom_addr+1;
					vga_data<=douta;
				end
				else begin
					rom_addr<=rom_addr;
					vga_data<=0;
				end
			end
			else begin
				vga_data<=12'b111111111111;
				if(v_cnt==0) rom_addr<=14'b00000000000000;
			end
		end
	end

	assign vga_r=vga_data[11:8];
	assign vga_g=vga_data[7:4];
	assign vga_b=vga_data[3:0];


	always@(posedge pclk) begin:speed_control
		if(rst==1'b1) speed_cnt<=8'h00;
		else begin
			if((v_cnt[5]==1'b1)&(h_cnt==1)) speed_cnt<=speed_cnt+8'h01;
		end
	end


	debounce u3(.sig_in(speed_cnt[5]),.clk(pclk),.sig_out(speed_ctrl));


	always @(posedge pclk) begin:logo_move

		reg [1:0] flag_add_sub;

		if(rst==1'b1) begin
			flag_add_sub=2'b01;
			logo_x<=10'b0110101110;
			logo_y<=10'b0000110010;
		end
		else begin
			if(speed_ctrl==1'b1) begin
				if(logo_x==1) begin
					if(logo_y==1) begin
						flag_edge<=4'h1;
						flag_add_sub=2'b00;
					end
					else if(logo_y==480-logo_hight) begin
						flag_edge<=4'h2;
						flag_add_sub=2'b01;
					end
					else begin
						flag_edge<=4'h3;
						flag_add_sub[1]=(~flag_add_sub[1]);
					end
				end
				else if(logo_x==640-logo_length) begin
					if(logo_y==1) begin
						flag_edge<=4'h4;
						flag_add_sub=2'b10;
					end
					else if(logo_y==480-logo_hight) begin
						flag_edge<=4'h5;
						flag_add_sub=2'b11;
					end
					else begin
						flag_edge<=4'h6;
						flag_add_sub[1]=(~flag_add_sub[1]);
					end
				end
				else if(logo_y==1) begin
					flag_edge<=4'h7;
					flag_add_sub[0]=(~flag_add_sub[0]);
				end
				else if(logo_y==480-logo_hight) begin
					flag_edge<=4'h8;
					flag_add_sub[0]=(~flag_add_sub[0]);
				end
				else begin
					flag_edge<=4'h9;
					flag_add_sub=flag_add_sub;
				end

				case(flag_add_sub)
					2'b00: begin
						logo_x<=logo_x+10'b0000000001;
						logo_y<=logo_y+10'b0000000001;
					end
					2'b01: begin
						logo_x<=logo_x+10'b0000000001;
						logo_y<=logo_y-10'b0000000001;
					end
					2'b10: begin
						logo_x<=logo_x-10'b0000000001;
						logo_y<=logo_y+10'b0000000001;
					end
					2'b11: begin
						logo_x<=logo_x-10'b0000000001;
						logo_y<=logo_y-10'b0000000001;
					end
					default: begin
						logo_x<=logo_x+10'b0000000001;
						logo_y<=logo_y+10'b0000000001;
					end
				endcase
			end
		end
	end
	
endmodule

