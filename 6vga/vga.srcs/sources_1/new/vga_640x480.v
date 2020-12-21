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

module vga_640x480(clk,rst,hsync,vsync,h_cnt,v_cnt);
    input clk;
    input rst;
    output hsync;
    output vsync;
    output [9:0]h_cnt;
    output [9:0]v_cnt;
    //output[9:0]vga_xpos;
    //output[9:0]vga_ypos;

    parameter h_frontporch=16;
    parameter h_active=96;
    parameter h_backporch=48;
    parameter h_disp=640;
    parameter h_total=800;
    
    parameter v_frontporch=10;
    parameter v_active=2;
    parameter v_backporch=33;
    parameter v_disp=480;
    parameter v_total=525;



    reg hsync;
    reg vsync;
    reg [9:0] h_cnt;
    reg [9:0] v_cnt;



    //行同步，场同步
    always @(posedge clk) begin
        if(!rst) h_cnt<=1;
        else begin
            if(h_cnt<h_total) h_cnt<=h_cnt+1;
            else h_cnt<=1;
        end
    end

    always @(posedge clk) begin
        if(!rst) hsync<=1;
        else begin
            if((h_cnt>h_frontporch+h_disp)&&(h_cnt<=h_frontporch+h_disp+h_active)) hsync<=0;
            else hsync<=1;
        end
    end

    always @(posedge clk) begin
        if(!rst) v_cnt<=1;
        else if(h_cnt==h_total) begin
            if(v_cnt<v_total) v_cnt<=v_cnt+1;
            else v_cnt<=1;
        end
    end

    always @(posedge clk) begin
        if(!rst) vsync<=1;
        else begin
            if((v_cnt>v_frontporch+v_disp)&&(v_cnt<=v_frontporch+v_disp+v_active)) vsync<=0;
            else vsync<=1;
        end
    end

endmodule
