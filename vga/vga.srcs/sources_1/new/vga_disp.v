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


module vga_disp(clk,rst,vga_rgb,h_cnt,v_cnt);
     input clk;
     input rst;
     input[9:0]h_cnt;
     input[9:0]v_cnt;
     output[11:0]vga_rgb;


     reg[11:0]vga_data;
     wire[9:0]vga_xpos;
     wire[9:0]vga_ypos;
     //wire[9:0]h_cnt;
     //wire[9:0]v_cnt;

     parameter red=12'hF00;
     parameter green=12'h0F0;
     parameter blue=12'h00F;
     parameter white=12'hFFF;
     parameter black=12'h000;

     parameter yellow=12'hFF0;
     parameter cyan=12'hF0F;
     parameter royal=12'hF0F;

     parameter h_disp=640;
     parameter v_disp=480;

     always @(posedge clk) begin
          if(!rst) vga_data<=12'h0;
          else begin
               if(vga_xpos>=0&&vga_xpos<(h_disp>>3)) vga_data<=red;
               else if(vga_xpos>=(h_disp>>3)*1&&vga_xpos<(h_disp>>3)*2) vga_data<=green;
               else if(vga_xpos>=(h_disp>>3)*2&&vga_xpos<(h_disp>>3)*3) vga_data<=blue;
               else if(vga_xpos>=(h_disp>>3)*3&&vga_xpos<(h_disp>>3)*4) vga_data<=white;
               else if(vga_xpos>=(h_disp>>3)*4&&vga_xpos<(h_disp>>3)*5) vga_data<=black;
               else if(vga_xpos>=(h_disp>>3)*5&&vga_xpos<(h_disp>>3)*6) vga_data<=yellow;
               else if(vga_xpos>=(h_disp>>3)*6&&vga_xpos<(h_disp>>3)*7) vga_data<=cyan;
               else if(vga_xpos>=(h_disp<<3)*7&&vga_xpos<(h_disp<<3)*8) vga_data<=royal;
          end
     end

     assign vga_xpos=(h_cnt<h_disp)?(h_cnt[9:0]):10'd0;
     assign vga_ypos=(v_cnt<v_disp)?(v_cnt[9:0]):10'd0;
     assign vga_rgb=((h_cnt<h_disp)&&(v_cnt<v_disp))?vga_data:12'd0;

endmodule

