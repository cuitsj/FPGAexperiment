//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/20 15:59:13
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
    input clk,
    input rst,
    input rx_pin,
    output reg [7:0] rx_data,
    output reg rx_done
    );

    parameter CLK = 100000000;
    parameter BPS = 9600;
    localparam BPS_CNT = CLK/BPS;

    reg rx_pinr;
    reg rx_pinrr;
    reg rx_flag;
    reg [3:0] rx_cnt;
    reg [15:0] clk_cnt;
    reg [7:0] data_buff;

    wire rx_start;

    assign rx_start = rx_pinrr &(~rx_pinr);

    //输入管脚信号打两拍
    always @(posedge clk) begin
        if (!rst) begin
            rx_pinr <= 0;
            rx_pinrr <= 0;
        end
        else begin
            rx_pinr <= rx_pin;
            rx_pinrr <= rx_pinr;
        end
    end

    //接收过程标志置位
    always @(posedge clk) begin
        if (!rst) rx_flag <= 0;
        else if (rx_start) rx_flag <= 1;
        else if (rx_cnt == 4'd9 && clk_cnt == BPS_CNT/2) rx_flag <= 0;
        else rx_flag <= rx_flag;
    end

    //波特率计数，接收数据位个数计数
    always @(posedge clk) begin
        if (!rst) begin
            clk_cnt <= 0;
            rx_cnt <= 0;
        end
        else if (rx_flag) begin//接收状态，开始计数
            if (clk_cnt == BPS_CNT - 1) begin
                clk_cnt <= 0;
                rx_cnt <= rx_cnt + 1;
            end
            else clk_cnt <= clk_cnt + 1;
        end
        else begin//接收过程结束
            clk_cnt <= 0;
            rx_cnt <= 0;
        end
    end

    //将信号线上的数据存入数据缓存寄存器
    always @(posedge clk) begin
        if (!rst) data_buff <= 0;
        else if (rx_flag) begin
            if (clk_cnt == BPS_CNT/2) begin
                case (rx_cnt)
                    4'd1:data_buff[0] <= rx_pinrr;
                    4'd2:data_buff[1] <= rx_pinrr;
                    4'd3:data_buff[2] <= rx_pinrr;
                    4'd4:data_buff[3] <= rx_pinrr;
                    4'd5:data_buff[4] <= rx_pinrr;
                    4'd6:data_buff[5] <= rx_pinrr;
                    4'd7:data_buff[6] <= rx_pinrr;
                    4'd8:data_buff[7] <= rx_pinrr;
                    default:;
                endcase
            end
            else data_buff <= data_buff;
        end
        else data_buff <= 0;
    end

    //一帧数据缓存完毕，将接收到的数据输出
    always @(posedge clk) begin
        if (!rst) begin
            rx_data <= 0;
            rx_done <= 0;
        end
        else if (rx_cnt == 4'd9) begin
            rx_data <= data_buff;
            rx_done <= 1;
        end
        else begin
            rx_data <= 0;
            rx_done <= 0;
        end
    end
endmodule
