//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/18 20:16:36
// Design Name: 
// Module Name: timer
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

module timer(
    input   clk,
    input   rst,
    input [4:0] key,
    output reg [7:0] Lsmg_seg,
    output reg [7:0] Rsmg_seg,
    output reg [7:0] smg_bit
    );


    reg [4:0] keyr;
    reg [4:0] keyrr;
    reg [4:0] keyp;//记录被按下的按键

    reg [19:0]  cnt;  
    reg [3:0] second_001;
    reg [3:0] second_01;
    reg [3:0] second_1;
    reg [3:0] second_10;
    reg [3:0] minute_1;
    reg [3:0] minute_10;
    reg [3:0] hour_1;
    reg [3:0] hour_10;

    reg [16:0] cnt1;
    reg [3:0] Ldataout;
    reg [3:0] Rdataout;

    reg [1:0] state;
    reg [3:0] time_bit;
    reg [25:0] cnt2;
    reg [0:0] reve;

    parameter  on = 2'b01,off = 2'b10;

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
            keyp[0] <= ({keyrr[0],keyr[0]}==2'b01)?1:0;//打开关闭调整时间
            keyp[1] <= ({keyrr[1],keyr[1]}==2'b01)?1:0;//减
            keyp[2] <= ({keyrr[2],keyr[2]}==2'b01)?1:0;//右移一位
            keyp[3] <= ({keyrr[3],keyr[3]}==2'b01)?1:0;//左移一位
            keyp[4] <= ({keyrr[4],keyr[4]}==2'b01)?1:0;//加
        end
    end

    //时间调整状态机
    always @(posedge clk) begin
        if (!rst) begin
            state <= off;
            time_bit <= 0;
        end
        else begin
            case (state)
            off: begin
                if (keyp[0]) state <= on;
                else state <= off;
            end
            on: begin
               if (keyp[0]) state <= off;
               else if (keyp[2]) time_bit <= time_bit + 1;
               else if (keyp[3]) time_bit <= time_bit - 1;
               else state <= on;
            end
            endcase
        end
    end
    
    //计数10毫秒
    always @(posedge clk) begin
        if (!rst) begin
            cnt <= 20'd0;
        end
        else if (cnt == 20'd999_999)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end

    //计时0.01秒
    always @(posedge clk) begin
        if (!rst) second_001 <= 4'd0;
        else if (cnt == 20'd999_999 && second_001 == 4'd9 || (state == on && second_001 == 4'd9 && time_bit == 3'd7 && keyp[4])) second_001 <= 0;
        else if (second_001 == 4'd0 && state == on && time_bit == 3'd7 && keyp[1]) second_001 <= 4'd9;
        else if (cnt == 20'd999_999 || (state == on && time_bit == 3'd7 && keyp[4])) second_001 <= second_001 + 1;
        else if (state == on && time_bit == 3'd7 && keyp[1]) second_001 <= second_001 - 1;
        else second_001 <= second_001; 
    end

    //计时0.1秒
    always @(posedge clk) begin
        if (!rst) second_01 <= 4'd0;
        else if (cnt == 20'd999_999 && second_001 == 4'd9 && second_01 == 4'd9 || (state == on && second_01 == 4'd9 && time_bit == 3'd6 && keyp[4])) second_01 <= 0;
        else if (second_01 == 4'd0 && state == on && time_bit == 3'd6 && keyp[1]) second_01 <= 4'd9;
        else if (cnt == 20'd999_999 && second_001 == 4'd9 || (state == on && time_bit == 3'd6 && keyp[4])) second_01 <= second_01 + 1;
        else if (state == on && time_bit == 3'd6 && keyp[1]) second_01 <= second_01 - 1;
        else second_01 <= second_01; 
    end

    //计时1秒
    always @(posedge clk) begin
        if (!rst) second_1 <= 4'd0;
        else if (cnt == 20'd999_999 && second_001 == 4'd9 && second_01 == 4'd9 && second_1 == 4'd9 || (state == on && second_1 == 4'd9 && time_bit == 3'd5 && keyp[4]))second_1 <= 0;
        else if (second_1 == 4'd0 && state == on && time_bit == 3'd5 && keyp[1]) second_1 <= 4'd9;
        else if (cnt == 20'd999_999 && second_01 == 4'd9 && second_001 == 4'd9 || (state == on && time_bit == 3'd5 && keyp[4]))second_1 <= second_1 + 1;
        else if (state == on && time_bit == 3'd5 && keyp[1]) second_1 <= second_1 - 1;
        else second_1 <= second_1; 
    end

    //计时10秒
    always @(posedge clk) begin
        if (!rst) second_10 <= 4'd0;
        else if (cnt == 20'd999_999 && second_001 == 4'd9 && second_01 == 4'd9 && second_1 == 4'd9 && second_10 == 4'd5 || (state == on && second_10 == 4'd5 && time_bit == 3'd4 && keyp[4]))second_10 <= 0;
        else if (second_10 == 4'd0 && state == on && time_bit == 3'd4 && keyp[1]) second_10 <= 4'd5;
        else if (cnt == 20'd999_999 && second_1 == 4'd9 && second_01 == 4'd9 && second_001 == 4'd9 || (state == on && time_bit == 3'd4 && keyp[4]))second_10 <= second_10 + 1;
        else if (state == on && time_bit == 3'd4 && keyp[1]) second_10 <= second_10 - 1;
        else second_10 <= second_10;
    end

    //计时1分
    always @(posedge clk) begin
        if (!rst) minute_1 <= 4'd0;
        else if (cnt == 20'd999_999 && second_001 == 4'd9 && second_01 == 4'd9 && second_1 == 4'd9 && second_10 == 4'd5 && minute_1 == 4'd9 || (state == on && minute_1 == 4'd9 && time_bit == 3'd3 && keyp[4]))minute_1 <= 0;
        else if (minute_1 == 4'd0 && state == on && time_bit == 3'd3 && keyp[1]) minute_1 <= 4'd9;
        else if (cnt == 20'd999_999 && second_10 == 4'd5 && second_1 == 4'd9 && second_01 == 4'd9 && second_001 == 4'd9 || (state == on && time_bit == 3'd3 && keyp[4]))minute_1 <= minute_1 + 1;
        else if (state == on && time_bit == 3'd3 && keyp[1]) minute_1 <= minute_1 - 1;
        else minute_1 <= minute_1;
    end

    //计时60分
    always @(posedge clk) begin
        if (!rst) minute_10 <= 4'd0;
        else if (cnt == 20'd999_999 && second_001 == 4'd9 && second_01 == 4'd9 && second_1 == 4'd9 && second_10 == 4'd5 && minute_1 == 4'd9 && minute_10 == 4'd5 || (state == on && minute_10 == 4'd5 && time_bit == 3'd2 && keyp[4]))minute_10 <= 0;
        else if (minute_10 == 4'd0 && state == on && time_bit == 3'd2 && keyp[1]) minute_10 <= 4'd5;
        else if (cnt == 20'd999_999 && minute_1 == 4'd9 && second_10 == 4'd5 && second_1 == 4'd9 && second_01 == 4'd9 && second_001 == 4'd9 || (state == on && time_bit == 3'd2 && keyp[4]))minute_10 <= minute_10 + 1;
        else if (state == on && time_bit == 3'd2 && keyp[1]) minute_10 <= minute_10 - 1;
        else minute_10 <= minute_10;
    end

    //计时1小时
    always @(posedge clk) begin
        if (!rst) hour_1 <= 4'd0;
        else if ((cnt == 20'd999_999 && second_001 == 4'd9 && second_01 == 4'd9 && second_1 == 4'd9 && second_10 == 4'd5 && minute_1 == 4'd9 && minute_10 == 4'd5 && ((hour_1 == 4'd9 && (hour_10 == 4'd0 || hour_10 == 4'd1)) || (hour_1 == 4'd3 && hour_10 == 4'd2))) || (((hour_1 == 4'd9 && (hour_10 == 4'd0 || hour_10 == 4'd1)) || (hour_1 == 4'd3 && hour_10 == 4'd2)) && state == on && time_bit == 3'd1 && keyp[4]))hour_1 <= 0;
        else if ((hour_1 == 4'd0 && (hour_10 == 4'd0 || hour_10 == 4'd1)) && state == on && time_bit == 3'd1 && keyp[1]) hour_1 <= 4'd9;
        else if ((hour_1 == 4'd0 && hour_10 == 4'd2) && state == on && time_bit == 3'd1 && keyp[1]) hour_1 <= 4'd3;
        else if (cnt == 20'd999_999 && minute_10 == 4'd5 && minute_1 == 4'd9 && second_10 == 4'd5 && second_1 == 4'd9 && second_01 == 4'd9 && second_001 == 4'd9 || (state == on && time_bit == 3'd1 && keyp[4]))hour_1 <= hour_1 + 1;
        else if (state == on && time_bit == 3'd1 && keyp[1]) hour_1 <= hour_1 - 1;
        else hour_1 <= hour_1;
    end

    //计时10小时
    always @(posedge clk) begin
        if (!rst) hour_10 <= 4'd0;
        else if (cnt == 20'd999_999 && second_001 == 4'd9 && second_01 == 4'd9 && second_1 == 4'd9 && second_10 == 4'd5 && minute_1 == 4'd9 && minute_10 == 4'd5 && hour_1 == 4'd3 && hour_10 == 4'd2 || (state == on && hour_10 == 4'd2 && time_bit == 3'd0 && keyp[4]))hour_10 <= 0;
        else if (hour_10 == 4'd0 && state == on && time_bit == 3'd0 && keyp[1]) hour_10 <= 4'd2;
        else if (cnt == 20'd999_999 && hour_1 == 4'd9 && minute_10 == 4'd5 && minute_1 == 4'd9 && second_10 == 4'd5 && second_1 == 4'd9 && second_01 == 4'd9 && second_001 == 4'd9 || (state == on && time_bit == 3'd0 && keyp[4]))hour_10 <= hour_10 + 1;
        else if (state == on && time_bit == 3'd0 && keyp[1]) hour_10 <= hour_10 - 1;
        else hour_10 <= hour_10;
    end

     //确定每位数码管显示的数值
    always	@(posedge clk) begin
        if (!rst) begin
            Ldataout <= 4'd0;//不显示
            Rdataout <= 4'd0;//不显示
        end
        else begin
            case (smg_bit)
            8'b0000_0001:	Ldataout	<=	hour_10;
            8'b0000_0010:	Ldataout	<=	hour_1;
            8'b0000_0100:	Ldataout	<=	minute_10;
            8'b0000_1000:	Ldataout	<=	minute_1;

            8'b0001_0000:	Rdataout	<=	second_10;
            8'b0010_0000:	Rdataout	<=	second_1;
            8'b0100_0000:	Rdataout	<=	second_01;
            8'b1000_0000:	Rdataout	<=	second_001;
            default: begin
                Ldataout <= 4'd0;//不显示
                Rdataout <=	4'd0;
            end
		endcase
        end
    end

    


     //数码管动态显示1毫秒间隔
    always @(posedge clk) begin
        if (!rst) begin
            cnt1 <= 0;
        end
        if (cnt1 == 17'd99999) begin
            cnt1 <= 0;
        end
        else cnt1 <= cnt1 + 1;
    end

    //调整时间是一位数码管闪烁定时0.5秒
    always @(posedge clk) begin
        if (!rst) begin
            cnt2 <= 0;
            reve <= 0;
        end
        if (cnt2 == 26'd4999_9999) begin
            cnt2 <= 0;
            if (state == on) begin
                reve <= ~reve;
            end
        end
        else cnt2 <= cnt2 + 1;
    end

    //数码管位选,只用前三位
    always @(posedge clk) begin
        if (!rst) begin
            smg_bit	<=	8'b0000_0001;
        end
        else if (cnt1 == 17'd99999 && state == on && smg_bit[time_bit-1] == 1 && reve == 0) smg_bit <= {smg_bit[5:0],smg_bit[7],smg_bit[6]};
        else if (cnt1 == 17'd99999 && state == on) smg_bit <= {smg_bit[6:0],smg_bit[7]};
        else if (cnt1 == 17'd99999 && state == off) smg_bit <= {smg_bit[6:0],smg_bit[7]};
        else smg_bit <= smg_bit;
    end

    //左边四位数码管段选
    always	@(posedge clk) begin
        if (!rst) begin
		    Lsmg_seg	<=	8'h00;//复位不显示
	    end
        else begin//共阴极--高电平选中
            case(Ldataout)//数码管显示
			4'h0: begin
                if (smg_bit == 8'b0000_0010 || smg_bit == 8'b0000_1000) Lsmg_seg <=	(~(8'hc0))|(8'h80);//0
                else Lsmg_seg <=	~(8'hc0);
            end
			4'h1: begin
                if (smg_bit == 8'b0000_0010 || smg_bit == 8'b0000_1000) Lsmg_seg <=	(~(8'hf9))|(8'h80);//0
                else Lsmg_seg <=	~(8'hf9);
            end
			4'h2: begin
                if (smg_bit == 8'b0000_0010 || smg_bit == 8'b0000_1000) Lsmg_seg <=	(~(8'ha4))|(8'h80);//0
                else Lsmg_seg		<=	~(8'ha4);//2
            end
			4'h3: begin
                if (smg_bit == 8'b0000_0010 || smg_bit == 8'b0000_1000) Lsmg_seg <=	(~(8'hb0))|(8'h80);//0
                else Lsmg_seg		<=	~(8'hb0);//3
            end
            
			4'h4: begin
                if (smg_bit == 8'b0000_0010 || smg_bit == 8'b0000_1000) Lsmg_seg <=	(~(8'h99))|(8'h80);//0
                else Lsmg_seg		<=	~(8'h99);//4
            end
            
			4'h5: begin
                if (smg_bit == 8'b0000_0010 || smg_bit == 8'b0000_1000) Lsmg_seg <=	(~(8'h92))|(8'h80);//0
                else Lsmg_seg		<=	~(8'h92);//5
            end
			4'h6: begin
                if (smg_bit == 8'b0000_0010 || smg_bit == 8'b0000_1000) Lsmg_seg <=	(~(8'h82))|(8'h80);//0
                else Lsmg_seg		<=	~(8'h82);//6
            end
            
			4'h7: begin
                if (smg_bit == 8'b0000_0010 || smg_bit == 8'b0000_1000) Lsmg_seg <=	(~(8'hf8))|(8'h80);//0
                else Lsmg_seg		<=	~(8'hf8);//7
            end
            
			4'h8: begin
                if (smg_bit == 8'b0000_0010 || smg_bit == 8'b0000_1000) Lsmg_seg <=	(~(8'h80))|(8'h80);//0
                else Lsmg_seg		<=	~(8'h80);//8
            end
            
			4'h9: begin
                if (smg_bit == 8'b0000_0010 || smg_bit == 8'b0000_1000) Lsmg_seg <=	(~(8'h90))|(8'h80);//0
                else Lsmg_seg		<=	~(8'h90);//9
            end 
			4'ha:Lsmg_seg		<=	~(8'h88);//a
			4'hb:Lsmg_seg		<=	~(8'h83);//b
			4'hc:Lsmg_seg		<=	~(8'hc6);//c
			4'hd:Lsmg_seg		<=	~(8'ha1);//d
			4'he:Lsmg_seg		<=	~(8'h86);//e
			4'hf:Lsmg_seg		<=	~(8'h8e);//f
			default:Lsmg_seg<=	8'h80;//.
		    endcase
        end
    end

    //右边四位数码管段选
    always	@(posedge clk) begin
        if (!rst) begin
		    Rsmg_seg	<=	8'h00;//复位不显示
	    end
        else begin//共阴极--高电平选中
            case(Rdataout)//数码管显示
            4'h0: begin
                if (smg_bit == 8'b0010_0000) Rsmg_seg <=	(~(8'hc0))|(8'h80);//0
                else Rsmg_seg <=	~(8'hc0);
            end
			4'h1: begin
                if (smg_bit == 8'b0010_0000) Rsmg_seg <=	(~(8'hf9))|(8'h80);//0
                else Rsmg_seg <=	~(8'hf9);
            end
			4'h2: begin
                if (smg_bit == 8'b0010_0000) Rsmg_seg <=	(~(8'ha4))|(8'h80);//0
                else Rsmg_seg		<=	~(8'ha4);//2
            end
			4'h3: begin
                if (smg_bit == 8'b0010_0000) Rsmg_seg <=	(~(8'hb0))|(8'h80);//0
                else Rsmg_seg		<=	~(8'hb0);//3
            end
            
			4'h4: begin
                if (smg_bit == 8'b0010_0000) Rsmg_seg <=	(~(8'h99))|(8'h80);//0
                else Rsmg_seg		<=	~(8'h99);//4
            end
            
			4'h5: begin
                if (smg_bit == 8'b0010_0000) Rsmg_seg <=	(~(8'h92))|(8'h80);//0
                else Rsmg_seg		<=	~(8'h92);//5
            end
			4'h6: begin
                if (smg_bit == 8'b0010_0000) Rsmg_seg <=	(~(8'h82))|(8'h80);//0
                else Rsmg_seg		<=	~(8'h82);//6
            end
            
			4'h7: begin
                if (smg_bit == 8'b0010_0000) Rsmg_seg <=	(~(8'hf8))|(8'h80);//0
                else Rsmg_seg		<=	~(8'hf8);//7
            end
            
			4'h8: begin
                if (smg_bit == 8'b0010_0000) Rsmg_seg <=	(~(8'h80))|(8'h80);//0
                else Rsmg_seg		<=	~(8'h80);//8
            end
            
			4'h9: begin
                if (smg_bit == 8'b0010_0000) Rsmg_seg <=	(~(8'h90))|(8'h80);//0
                else Rsmg_seg		<=	~(8'h90);//9
            end 
			4'ha:Rsmg_seg		<=	~(8'h88);//a
			4'hb:Rsmg_seg		<=	~(8'h83);//b
			4'hc:Rsmg_seg		<=	~(8'hc6);//c
			4'hd:Rsmg_seg		<=	~(8'ha1);//d
			4'he:Rsmg_seg		<=	~(8'h86);//e
			4'hf:Rsmg_seg		<=	~(8'h8e);//f
			default:Rsmg_seg<=	8'h80;//.
		    endcase
        end
    end

endmodule
