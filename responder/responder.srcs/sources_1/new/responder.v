//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/16 18:52:34
// Design Name: 
// Module Name: Responder
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


module Responder(
    input clk,
    input rst,
    input [4:0] key,
    output reg [7:0] smg_seg,
    output reg [7:0] smg_bit
    );

    reg [2:0] state;
    reg [4:0] keyr;
    reg [4:0] keyrr;
    reg [4:0] keyp;//记录被按下的按键
    reg [26:0] count;
    reg [16:0] count1;
    reg [3:0] second;
    reg [4:0] dataout;
    reg [4:0] num;

    parameter init = 3'b000,    //初始状态
              start = 3'b001,   //开始抢答
              rec = 3'b010,     //有人抢答
              non = 3'b011,     //无人抢答
              vio = 3'b100;     //违规状态

    //状态转换
    always @(posedge clk) begin
        if (!rst) begin
            state <= init;
            num <= 0;
        end
        else begin
            case (state)
                //初始状态
                init:begin
                    if (keyp[0]) begin
                        state <= start;
                    end
                    else if (keyp[1] || keyp[2] || keyp[3] || keyp[4])begin
                        state <= vio;
                        if (keyp[1]) num <= 5'd1;
                        else if (keyp[2]) num <= 5'd2;
                        else if (keyp[3]) num <= 5'd3;
                        else if (keyp[4]) num <= 5'd4;
                        else num <= num;
                    end
                    else state <= init;
                end
                //违规状态
                vio:begin
                    if (keyp[0]) begin
                        state <= init;
                    end
                    else state <= vio;
                end
                //开始抢答
                start: begin
                    if (keyp[1] || keyp[2] || keyp[3] || keyp[4]) begin
                        state <= rec;
                        if (keyp[1]) num <= 5'd1;
                        else if (keyp[2]) num <= 5'd2;
                        else if (keyp[3]) num <= 5'd3;
                        else if (keyp[4]) num <= 5'd4;
                        else num <= num;
                    end
                    else if (second == 0) begin
                        state <= non;
                    end
                end
                //有人抢答
                rec: begin
                    if (keyp[0]) begin
                        state <= init;
                    end
                    else state <= rec;
                end
                //无人抢答
                non: begin
                    if (keyp[0]) begin
                        state <= init;
                    end
                    else state <= non;
                end
                default:;
            endcase
        end
    end

    //确定每位数码管显示的数值
    always	@(posedge clk) begin
        if (!rst) begin
            dataout <= 5'd17;//不显示
        end
        else begin
            case (smg_bit)
            8'b0000_0001:	begin
                if (state == vio) dataout <= num;
                else if (state == start && second == 4'd10) dataout <= second/10;
                else if (state == rec) dataout <= num;
                else dataout <= 5'd17;
            end
			8'b0000_0010:	begin
                if (state == vio) dataout <= 5'd14;
                else if (state == start) dataout <= second%10;
                else if (state == non) dataout <= 5'd0;
                else dataout <= 5'd17;
            end
			8'b0000_0100:	begin
                if (state == vio) dataout <= 5'd16;
                else dataout <= 5'd17;
            end
            8'b0000_1000:	begin
                if (state == vio) dataout <= 5'd16;
                else dataout <= 5'd17;
            end
			default: dataout <=	5'd17;
		endcase
        end
    end

    //按键检测和消抖
    always @(posedge clk) begin
        if (!rst) begin
            keyr <= 0;
            keyrr <= 0;
            keyp <= 0;
        end
        else begin
            keyr <= key;
            keyrr <= keyr;
            keyp[0] <= ({keyrr[0],keyr[0]}==2'b01)?1:0;
            keyp[1] <= ({keyrr[1],keyr[1]}==2'b01)?1:0;
            keyp[2] <= ({keyrr[2],keyr[2]}==2'b01)?1:0;
            keyp[3] <= ({keyrr[3],keyr[3]}==2'b01)?1:0;
            keyp[4] <= ({keyrr[4],keyr[4]}==2'b01)?1:0;
        end
    end

    //10秒倒计时器
    always @(posedge clk) begin
        if (!rst) begin
            count <= 0;
            second <= 4'd10;
        end
        else if (count == 27'd9999_9999) begin
            count <= 0;
            if (second == 0) second <= 4'd10;
            else if (state == start) second <= second - 1;
            else second <= second;
        end
        else if (state == init) second <= 4'd10; 
        else if (state == start)count <= count + 1;
        else count <= count;
    end

    //数码管动态显示1毫秒间隔
    always @(posedge clk) begin
        if (!rst) begin
            count1 <= 0;
        end
        if (count1 == 17'd99999) begin
            count1 <= 0;
        end
        else count1 <= count1 + 1;
    end

    //数码管位选,只用前三位
    always @(posedge clk) begin
        if (!rst) begin
            smg_bit	<=	8'b0000_0001;
        end
        else if (count1 == 17'd99999) begin
            smg_bit <= {smg_bit[6:0],smg_bit[7]};
        end
        else smg_bit <= smg_bit;
    end

    //数码管段选
    always	@(posedge clk) begin
        if (!rst) begin
		smg_seg	<=	8'h00;//复位不显示
	    end
        else begin//共阴极--高电平选中
            case(dataout)//数码管显示
			5'd0:smg_seg <=	~(8'hc0);//0
			5'd1:smg_seg <=	~(8'hf9);//1
			5'd2:smg_seg <=	~(8'ha4);//2
			5'd3:smg_seg <=	~(8'hb0);//3
			5'd4:smg_seg <=	~(8'h99);//4
			5'd5:smg_seg <=	~(8'h92);//5
			5'd6:smg_seg <=	~(8'h82);//6
			5'd7:smg_seg <=	~(8'hf8);//7
			5'd8:smg_seg <=	~(8'h80);//8
			5'd9:smg_seg <=	~(8'h90);//9
			5'd10:smg_seg <= ~(8'h88);//a
			5'd11:smg_seg <= ~(8'h83);//b
			5'd12:smg_seg <= ~(8'hc6);//c
			5'd13:smg_seg <= ~(8'ha1);//d
			5'd14:smg_seg <= ~(8'h86);//e
			5'd15:smg_seg <= ~(8'h8e);//f
            5'd16:smg_seg <= 8'h50;//r
            5'd17:smg_seg <= 8'h00;//不显示
			default:smg_seg<= 8'h00;//不显示
		    endcase
        end
    end
endmodule
