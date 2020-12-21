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


module uart_top(
    input clk,
    input rst,
    input rx_pin,
    output tx_pin
    );

    parameter CLK = 100000000;
    parameter BPS = 115200;

    wire tx_en;
    wire [7:0] data;

    uart_rx #(
        .CLK(CLK),
        .BPS(BPS)) 
    u_uart_rx(
        .clk(clk),
        .rst(rst),
        .rx_pin(rx_pin),
        .rx_data(data),
        .rx_done(tx_en)
    );

    uart_tx #(
        .CLK(CLK),
        .BPS(BPS))
    u_uart_tx(
        .clk(clk),
        .rst(rst),
        .tx_en(tx_en),
        .tx_data(data),
        .tx_pin(tx_pin)
    );
endmodule