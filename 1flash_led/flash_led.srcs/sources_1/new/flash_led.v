//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/16 16:43:04
// Design Name: 
// Module Name: flash_led
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


module flash_led(
    input clk,
    input rst,
    output [7:0] led
    );

    reg [7:0] led_buff;
    reg [22:0] cnt;
    reg move_flag;

    always @(posedge clk) begin
        if (!rst) begin
            move_flag <= 0;
            cnt <= 0;
        end
        else if (cnt == 23'h7fffff) begin
            move_flag <= 1;
            cnt <= 0;
        end
        else begin
            move_flag <= 0;
            cnt <= cnt + 1;
        end
    end

    always @(posedge clk) begin
        if (!rst) led_buff <= 8'b0000_0001;
        else if (move_flag) begin
            led_buff <= {led_buff[6:0],led_buff[7]};
        end
        else led_buff <= led_buff;
    end

    assign led = led_buff;
endmodule
