//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/20 20:55:49
// Design Name: 
// Module Name: vga_display
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


module vga_display(
    input             vga_clk,                  //VGA驱动时钟
    input             sys_rst_n,                //复位信号
    
    input      [ 9:0] pixel_xpos,               //像素点横坐标
    input      [ 9:0] pixel_ypos,               //像素点纵坐标    
    output reg [11:0] pixel_data                //像素点数据
    );    
    
parameter  H_DISP = 10'd640;                    //分辨率——行
parameter  V_DISP = 10'd480;                    //分辨率——列

localparam WHITE  = 12'hFFF;                    //RGB444 白色
localparam BLACK  = 12'h000;                    //RGB444 黑色
localparam RED    = 12'hF00;                    //RGB444 红色
localparam GREEN  = 12'h0F0;                    //RGB444 绿色
localparam BLUE   = 12'h00F;                    //RGB444 蓝色

localparam YELLOW   = 12'hFF0;                  //RGB444 红+绿 黄色
localparam CYAN     = 12'hF0F;                  //RGB444 红+蓝 粉红色
localparam ROYAL    = 12'h0FF;                  //RGB444 绿+蓝 天蓝色

    
//*****************************************************
//**                    main code
//*****************************************************
//根据当前像素点坐标指定当前像素点颜色数据，在屏幕上显示彩条
always @(posedge vga_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n)
        pixel_data <= 12'd0;                                  
    else begin
        if((pixel_xpos >= 0) && (pixel_xpos <= (H_DISP/8)*1))                                              
            pixel_data <= WHITE;                               
        else if((pixel_xpos >= (H_DISP/8)*1) && (pixel_xpos < (H_DISP/8)*2))
            pixel_data <= BLACK;  
        else if((pixel_xpos >= (H_DISP/8)*2) && (pixel_xpos < (H_DISP/8)*3))
            pixel_data <= RED;  
        else if((pixel_xpos >= (H_DISP/8)*3) && (pixel_xpos < (H_DISP/8)*4))
            pixel_data <= GREEN;  
        else if((pixel_xpos >= (H_DISP/8)*4) && (pixel_xpos < (H_DISP/8)*5))
            pixel_data <= BLUE;  
        else if((pixel_xpos >= (H_DISP/8)*5) && (pixel_xpos < (H_DISP/8)*6))
            pixel_data <= YELLOW;  
        else if((pixel_xpos >= (H_DISP/8)*6) && (pixel_xpos < (H_DISP/8)*7))
            pixel_data <= CYAN;  
        else 
            pixel_data <= ROYAL;  
    end
end

endmodule 
