//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/18 18:47:35
// Design Name: 
// Module Name: FIR_filter
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

module FIR_filter
               (
                clk,
                clk_enable,
                reset,
                filter_in,
                filter_out
                );

  input   clk; 
  input   clk_enable; 
  input   reset; 
  input   signed [15:0] filter_in; //sfix16_En15
  output  signed [33:0] filter_out; //sfix34_En32

////////////////////////////////////////////////////////////////
//Module Architecture: filter
////////////////////////////////////////////////////////////////
  // Local Functions
  // Type Definitions
  // Constants
  parameter signed [15:0] coeff1 = 16'b0000001101111110; //sfix16_En17
  parameter signed [15:0] coeff2 = 16'b0000101010000101; //sfix16_En17
  parameter signed [15:0] coeff3 = 16'b0001111111001011; //sfix16_En17
  parameter signed [15:0] coeff4 = 16'b0011111111100100; //sfix16_En17
  parameter signed [15:0] coeff5 = 16'b0101110110000100; //sfix16_En17
  parameter signed [15:0] coeff6 = 16'b0110100110010101; //sfix16_En17
  parameter signed [15:0] coeff7 = 16'b0101110110000100; //sfix16_En17
  parameter signed [15:0] coeff8 = 16'b0011111111100100; //sfix16_En17
  parameter signed [15:0] coeff9 = 16'b0001111111001011; //sfix16_En17
  parameter signed [15:0] coeff10 = 16'b0000101010000101; //sfix16_En17
  parameter signed [15:0] coeff11 = 16'b0000001101111110; //sfix16_En17

  // Signals
  reg  signed [15:0] delay_pipeline [0:10] ; // sfix16_En15
  wire signed [30:0] product11; // sfix31_En32
  wire signed [31:0] mul_temp; // sfix32_En32
  wire signed [30:0] product10; // sfix31_En32
  wire signed [31:0] mul_temp_1; // sfix32_En32
  wire signed [30:0] product9; // sfix31_En32
  wire signed [31:0] mul_temp_2; // sfix32_En32
  wire signed [30:0] product8; // sfix31_En32
  wire signed [31:0] mul_temp_3; // sfix32_En32
  wire signed [30:0] product7; // sfix31_En32
  wire signed [31:0] mul_temp_4; // sfix32_En32
  wire signed [30:0] product6; // sfix31_En32
  wire signed [31:0] mul_temp_5; // sfix32_En32
  wire signed [30:0] product5; // sfix31_En32
  wire signed [31:0] mul_temp_6; // sfix32_En32
  wire signed [30:0] product4; // sfix31_En32
  wire signed [31:0] mul_temp_7; // sfix32_En32
  wire signed [30:0] product3; // sfix31_En32
  wire signed [31:0] mul_temp_8; // sfix32_En32
  wire signed [30:0] product2; // sfix31_En32
  wire signed [31:0] mul_temp_9; // sfix32_En32
  wire signed [33:0] product1_cast; // sfix34_En32
  wire signed [30:0] product1; // sfix31_En32
  wire signed [31:0] mul_temp_10; // sfix32_En32
  wire signed [33:0] sum1; // sfix34_En32
  wire signed [33:0] add_signext; // sfix34_En32
  wire signed [33:0] add_signext_1; // sfix34_En32
  wire signed [34:0] add_temp; // sfix35_En32
  wire signed [33:0] sum2; // sfix34_En32
  wire signed [33:0] add_signext_2; // sfix34_En32
  wire signed [33:0] add_signext_3; // sfix34_En32
  wire signed [34:0] add_temp_1; // sfix35_En32
  wire signed [33:0] sum3; // sfix34_En32
  wire signed [33:0] add_signext_4; // sfix34_En32
  wire signed [33:0] add_signext_5; // sfix34_En32
  wire signed [34:0] add_temp_2; // sfix35_En32
  wire signed [33:0] sum4; // sfix34_En32
  wire signed [33:0] add_signext_6; // sfix34_En32
  wire signed [33:0] add_signext_7; // sfix34_En32
  wire signed [34:0] add_temp_3; // sfix35_En32
  wire signed [33:0] sum5; // sfix34_En32
  wire signed [33:0] add_signext_8; // sfix34_En32
  wire signed [33:0] add_signext_9; // sfix34_En32
  wire signed [34:0] add_temp_4; // sfix35_En32
  wire signed [33:0] sum6; // sfix34_En32
  wire signed [33:0] add_signext_10; // sfix34_En32
  wire signed [33:0] add_signext_11; // sfix34_En32
  wire signed [34:0] add_temp_5; // sfix35_En32
  wire signed [33:0] sum7; // sfix34_En32
  wire signed [33:0] add_signext_12; // sfix34_En32
  wire signed [33:0] add_signext_13; // sfix34_En32
  wire signed [34:0] add_temp_6; // sfix35_En32
  wire signed [33:0] sum8; // sfix34_En32
  wire signed [33:0] add_signext_14; // sfix34_En32
  wire signed [33:0] add_signext_15; // sfix34_En32
  wire signed [34:0] add_temp_7; // sfix35_En32
  wire signed [33:0] sum9; // sfix34_En32
  wire signed [33:0] add_signext_16; // sfix34_En32
  wire signed [33:0] add_signext_17; // sfix34_En32
  wire signed [34:0] add_temp_8; // sfix35_En32
  wire signed [33:0] sum10; // sfix34_En32
  wire signed [33:0] add_signext_18; // sfix34_En32
  wire signed [33:0] add_signext_19; // sfix34_En32
  wire signed [34:0] add_temp_9; // sfix35_En32
  reg  signed [33:0] output_register; // sfix34_En32

  // Block Statements
  always @( posedge clk or posedge reset)
    begin: Delay_Pipeline_process
      if (reset == 1'b1) begin
        delay_pipeline[0] <= 0;
        delay_pipeline[1] <= 0;
        delay_pipeline[2] <= 0;
        delay_pipeline[3] <= 0;
        delay_pipeline[4] <= 0;
        delay_pipeline[5] <= 0;
        delay_pipeline[6] <= 0;
        delay_pipeline[7] <= 0;
        delay_pipeline[8] <= 0;
        delay_pipeline[9] <= 0;
        delay_pipeline[10] <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          delay_pipeline[0] <= filter_in;
          delay_pipeline[1] <= delay_pipeline[0];
          delay_pipeline[2] <= delay_pipeline[1];
          delay_pipeline[3] <= delay_pipeline[2];
          delay_pipeline[4] <= delay_pipeline[3];
          delay_pipeline[5] <= delay_pipeline[4];
          delay_pipeline[6] <= delay_pipeline[5];
          delay_pipeline[7] <= delay_pipeline[6];
          delay_pipeline[8] <= delay_pipeline[7];
          delay_pipeline[9] <= delay_pipeline[8];
          delay_pipeline[10] <= delay_pipeline[9];
        end
      end
    end // Delay_Pipeline_process


  assign mul_temp = delay_pipeline[10] * coeff11;
  assign product11 = mul_temp[30:0];

  assign mul_temp_1 = delay_pipeline[9] * coeff10;
  assign product10 = mul_temp_1[30:0];

  assign mul_temp_2 = delay_pipeline[8] * coeff9;
  assign product9 = mul_temp_2[30:0];

  assign mul_temp_3 = delay_pipeline[7] * coeff8;
  assign product8 = mul_temp_3[30:0];

  assign mul_temp_4 = delay_pipeline[6] * coeff7;
  assign product7 = mul_temp_4[30:0];

  assign mul_temp_5 = delay_pipeline[5] * coeff6;
  assign product6 = mul_temp_5[30:0];

  assign mul_temp_6 = delay_pipeline[4] * coeff5;
  assign product5 = mul_temp_6[30:0];

  assign mul_temp_7 = delay_pipeline[3] * coeff4;
  assign product4 = mul_temp_7[30:0];

  assign mul_temp_8 = delay_pipeline[2] * coeff3;
  assign product3 = mul_temp_8[30:0];

  assign mul_temp_9 = delay_pipeline[1] * coeff2;
  assign product2 = mul_temp_9[30:0];

  assign product1_cast = $signed({{3{product1[30]}}, product1});

  assign mul_temp_10 = delay_pipeline[0] * coeff1;
  assign product1 = mul_temp_10[30:0];

  assign add_signext = product1_cast;
  assign add_signext_1 = $signed({{3{product2[30]}}, product2});
  assign add_temp = add_signext + add_signext_1;
  assign sum1 = add_temp[33:0];

  assign add_signext_2 = sum1;
  assign add_signext_3 = $signed({{3{product3[30]}}, product3});
  assign add_temp_1 = add_signext_2 + add_signext_3;
  assign sum2 = add_temp_1[33:0];

  assign add_signext_4 = sum2;
  assign add_signext_5 = $signed({{3{product4[30]}}, product4});
  assign add_temp_2 = add_signext_4 + add_signext_5;
  assign sum3 = add_temp_2[33:0];

  assign add_signext_6 = sum3;
  assign add_signext_7 = $signed({{3{product5[30]}}, product5});
  assign add_temp_3 = add_signext_6 + add_signext_7;
  assign sum4 = add_temp_3[33:0];

  assign add_signext_8 = sum4;
  assign add_signext_9 = $signed({{3{product6[30]}}, product6});
  assign add_temp_4 = add_signext_8 + add_signext_9;
  assign sum5 = add_temp_4[33:0];

  assign add_signext_10 = sum5;
  assign add_signext_11 = $signed({{3{product7[30]}}, product7});
  assign add_temp_5 = add_signext_10 + add_signext_11;
  assign sum6 = add_temp_5[33:0];

  assign add_signext_12 = sum6;
  assign add_signext_13 = $signed({{3{product8[30]}}, product8});
  assign add_temp_6 = add_signext_12 + add_signext_13;
  assign sum7 = add_temp_6[33:0];

  assign add_signext_14 = sum7;
  assign add_signext_15 = $signed({{3{product9[30]}}, product9});
  assign add_temp_7 = add_signext_14 + add_signext_15;
  assign sum8 = add_temp_7[33:0];

  assign add_signext_16 = sum8;
  assign add_signext_17 = $signed({{3{product10[30]}}, product10});
  assign add_temp_8 = add_signext_16 + add_signext_17;
  assign sum9 = add_temp_8[33:0];

  assign add_signext_18 = sum9;
  assign add_signext_19 = $signed({{3{product11[30]}}, product11});
  assign add_temp_9 = add_signext_18 + add_signext_19;
  assign sum10 = add_temp_9[33:0];

  always @ (posedge clk or posedge reset)
    begin: Output_Register_process
      if (reset == 1'b1) begin
        output_register <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          output_register <= sum10;
        end
      end
    end // Output_Register_process

  // Assignment Statements
  assign filter_out = output_register;
endmodule  // filter

