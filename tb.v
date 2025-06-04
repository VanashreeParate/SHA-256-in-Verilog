`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2025 20:14:28
// Design Name: 
// Module Name: tb
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


module tb();
reg clk;
reg rst;
reg [23:0] data_in;
wire [255:0] digest;

sha_256 uut (clk, rst, data_in, digest); //instantiated module
wire [511:0] msg_block = uut.msg_block;
wire [31:0] word [0:63] = uut.word;
wire [31:0] H [0:7] = uut.H;
wire [31:0] h_1_2 [0:7] = uut.h_1_2;
wire [31:0] h_2_temp [0:7] = uut.h_2_temp;
wire [31:0] h_9_10 [0:7] = uut.h_9_10;
wire [31:0] h_10_temp [0:7] = uut.h_10_temp;

always #34 clk=~clk ; //14,705MHz T=68ns

initial
begin
    clk = 0;
    rst=0;
    data_in = 24'h616263;//abc
    #10;
    rst =1;
    #60 rst=0;
    #704 data_in = 24'h616161; //aaa
    #60 rst=1;
    #60 rst=0;
    
end

endmodule