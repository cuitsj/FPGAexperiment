`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/20 17:28:10
// Design Name: 
// Module Name: sim_uart_tx
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


module sim_uart_tx;

// uart_tx Parameters
parameter PERIOD = 10       ;
parameter CLK  = 100000000;
parameter BPS  = 115200     ;

// uart_tx Inputs
reg   clk                                  = 0 ;
reg   rst                                  = 0 ;
reg   tx_en                                = 0 ;
reg   [7:0]  tx_data                       = 0 ;

// uart_tx Outputs
wire  tx_pin                               ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst  =  1;
end

uart_tx #(
    .CLK ( CLK ),
    .BPS ( BPS ))
 u_uart_tx (
    .clk                     ( clk            ),
    .rst                     ( rst            ),
    .tx_en                   ( tx_en          ),
    .tx_data                 ( tx_data  [7:0] ),

    .tx_pin                  ( tx_pin         )
);

initial
begin
    #55 tx_data = 8'b0101_1111;
    #10 tx_en = 1;
    #10 tx_en = 0;
    $finish;
end

endmodule
