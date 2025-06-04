`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2025 20:13:43
// Design Name: 
// Module Name: sha_256
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


module sha_256(clk, rst, data_in, digest);
input clk;
input rst;
input [23:0] data_in;
output reg [255:0] digest;

reg [511:0] msg_block; //message block of 512 bits
reg [31:0] word [0:63]; //64 words of 32 bits each
reg [31:0] H [0:7]; //final hash values
reg [31:0] h_1_2 [0:7]; //initial hash values
integer i;

//stage 1 : msg_block and W0 to W15
always@(posedge clk)
begin
    if(rst)
    begin
        msg_block <= {data_in, 1'b1, {423{1'b0}}, 64'd24}; //msg block initialised
        h_1_2[0] = 32'h6a09e667;
        h_1_2[1] = 32'hbb67ae85;
        h_1_2[2] = 32'h3c6ef372;
        h_1_2[3] = 32'ha54ff53a;
        h_1_2[4] = 32'h510e527f;
        h_1_2[5] = 32'h9b05688c;
        h_1_2[6] = 32'h1f83d9ab;
        h_1_2[7] = 32'h5be0cd19;
        
    end
    else
    begin
        for(i=0; i<16; i=i+1)
        begin
            word[i] <= msg_block[511 - (32*i) -:32]; //fixed slicing
        end
    end
end

integer i_2, j_2;
reg [31:0] h_2_temp [0:7]; 
reg [31:0] T1_2, T2_2;
reg [31:0] h_2_3 [0:7];
//stage 2 : W16 to W22 & Round 0 to 6
always@(posedge clk)
begin
    if(rst)
    begin
        for(i_2=16; i_2<23; i_2=i_2+1)
        begin
            word[i_2] <= 0;
        end
    end
    else
    begin
        for(j_2=0; j_2<8; j_2=j_2+1) //storing intermediate hash values in temporary register
            h_2_temp[j_2] = h_1_2[j_2];
        for(i_2=16; i_2<23; i_2=i_2+1) //calculating Word
        begin
            word[i_2] = lowercase_sigma_1_output(word[i_2-2]) + word[i_2-7] + lowercase_sigma_0_output(word[i_2-15]) + word[i_2-16];
        end
        for(j_2=0; j_2<7; j_2=j_2+1) //calculation of rounds
        begin
            T1_2 = h_2_temp[7] + uppercase_sigma_1_output(h_2_temp[4]) + choice_output(h_2_temp[4], h_2_temp[5], h_2_temp[6]) + get_K(j_2) + word[j_2];
            T2_2 = uppercase_sigma_0_output(h_2_temp[0]) + majority_output(h_2_temp[0], h_2_temp[1], h_2_temp[2]);
            h_2_temp[7] = h_2_temp[6];
            h_2_temp[6] = h_2_temp[5];
            h_2_temp[5] = h_2_temp[4];
            h_2_temp[4] = h_2_temp[3] + T1_2;
            h_2_temp[3] = h_2_temp[2];
            h_2_temp[2] = h_2_temp[1];
            h_2_temp[1] = h_2_temp[0];
            h_2_temp[0] = T1_2 + T2_2;
        end
        for(j_2=0; j_2<8; j_2=j_2+1) //calculated passed to next stage
            h_2_3[j_2] <= h_2_temp[j_2];
    end
end

integer i_3, j_3;
reg [31:0] h_3_temp [0:7]; 
reg [31:0] T1_3, T2_3;
reg [31:0] h_3_4 [0:7];
//stage 3 : W23 to W29 & Round 7 to 13
always@(posedge clk)
begin
    if(rst)
    begin
        for(i_3=23; i_3<30; i_3=i_3+1)
        begin
            word[i_3] <= 0;
        end
    end
    else
    begin
        for(j_3=0; j_3<8; j_3=j_3+1) //storing intermediate hash values in temporary register
            h_3_temp[j_3] = h_2_3[j_3];
        for(i_3=23; i_3<30; i_3=i_3+1) //calculating Word
        begin
            word[i_3] = lowercase_sigma_1_output(word[i_3-2]) + word[i_3-7] + lowercase_sigma_0_output(word[i_3-15]) + word[i_3-16];
        end
        for(j_3=7; j_3<14; j_3=j_3+1)
        begin
            T1_3 = h_3_temp[7] + uppercase_sigma_1_output(h_3_temp[4]) + choice_output(h_3_temp[4], h_3_temp[5], h_3_temp[6]) + get_K(j_3) + word[j_3];
            T2_3 = uppercase_sigma_0_output(h_3_temp[0]) + majority_output(h_3_temp[0], h_3_temp[1], h_3_temp[2]);
            h_3_temp[7] = h_3_temp[6];
            h_3_temp[6] = h_3_temp[5];
            h_3_temp[5] = h_3_temp[4];
            h_3_temp[4] = h_3_temp[3] + T1_3;
            h_3_temp[3] = h_3_temp[2];
            h_3_temp[2] = h_3_temp[1];
            h_3_temp[1] = h_3_temp[0];
            h_3_temp[0] = T1_3 + T2_3;
        end
        for(j_3=0; j_3<8; j_3=j_3+1) //storing calculated passed to next stage
            h_3_4[j_3] <= h_3_temp[j_3];
    end
end

integer i_4, j_4;
reg [31:0] h_4_temp [0:7]; 
reg [31:0] T1_4, T2_4;
reg [31:0] h_4_5 [0:7];
//stage 4 : W30 to W36 & Round 14 to 20
always@(posedge clk)
begin
    if(rst)
    begin
        for(i_4=30; i_4<37; i_4=i_4+1)
        begin
            word[i_4] <= 0;
        end
    end
    else
    begin
        for(j_4=0; j_4<8; j_4=j_4+1) //storing intermediate hash values in temporary register
            h_4_temp[j_4] = h_3_4[j_4];
        for(i_4=30; i_4<37; i_4=i_4+1) //calculating Word
        begin
            word[i_4] = lowercase_sigma_1_output(word[i_4-2]) + word[i_4-7] + lowercase_sigma_0_output(word[i_4-15]) + word[i_4-16];
        end
        for(j_4=14; j_4<21; j_4=j_4+1)
        begin
            T1_4 = h_4_temp[7] + uppercase_sigma_1_output(h_4_temp[4]) + choice_output(h_4_temp[4], h_4_temp[5], h_4_temp[6]) + get_K(j_4) + word[j_4];
            T2_4 = uppercase_sigma_0_output(h_4_temp[0]) + majority_output(h_4_temp[0], h_4_temp[1], h_4_temp[2]);
            h_4_temp[7] = h_4_temp[6];
            h_4_temp[6] = h_4_temp[5];
            h_4_temp[5] = h_4_temp[4];
            h_4_temp[4] = h_4_temp[3] + T1_4;
            h_4_temp[3] = h_4_temp[2];
            h_4_temp[2] = h_4_temp[1];
            h_4_temp[1] = h_4_temp[0];
            h_4_temp[0] = T1_4 + T2_4;
        end
        for(j_4=0; j_4<8; j_4=j_4+1) //storing calculated passed to next stage
            h_4_5[j_4] <= h_4_temp[j_4];
    end
end

integer i_5, j_5;
reg [31:0] h_5_temp [0:7]; 
reg [31:0] T1_5, T2_5;
reg [31:0] h_5_6 [0:7];
//stage 5 : W37 to W43 & Round 21 to 27
always@(posedge clk)
begin
    if(rst)
    begin
        for(i_5=37; i_5<44; i_5=i_5+1)
        begin
            word[i_5] <= 0;
        end
    end
    else
    begin
        for(j_5=0; j_5<8; j_5=j_5+1) //storing intermediate hash values in temporary register
            h_5_temp[j_5] = h_4_5[j_5];
        for(i_5=37; i_5<44; i_5=i_5+1) //calculating Word
        begin
            word[i_5] = lowercase_sigma_1_output(word[i_5-2]) + word[i_5-7] + lowercase_sigma_0_output(word[i_5-15]) + word[i_5-16];
        end
        for(j_5=21; j_5<28; j_5=j_5+1)
        begin
            T1_5 = h_5_temp[7] + uppercase_sigma_1_output(h_5_temp[4]) + choice_output(h_5_temp[4], h_5_temp[5], h_5_temp[6]) + get_K(j_5) + word[j_5];
            T2_5 = uppercase_sigma_0_output(h_5_temp[0]) + majority_output(h_5_temp[0], h_5_temp[1], h_5_temp[2]);
            h_5_temp[7] = h_5_temp[6];
            h_5_temp[6] = h_5_temp[5];
            h_5_temp[5] = h_5_temp[4];
            h_5_temp[4] = h_5_temp[3] + T1_5;
            h_5_temp[3] = h_5_temp[2];
            h_5_temp[2] = h_5_temp[1];
            h_5_temp[1] = h_5_temp[0];
            h_5_temp[0] = T1_5 + T2_5;
        end
        for(j_5=0; j_5<8; j_5=j_5+1) //storing calculated passed to next stage
            h_5_6[j_5] <= h_5_temp[j_5];
    end
end

integer i_6, j_6;
reg [31:0] h_6_temp [0:7]; 
reg [31:0] T1_6, T2_6;
reg [31:0] h_6_7 [0:7];
//stage 6 : W44 to W50 & Round 28 to 34
always@(posedge clk)
begin
    if(rst)
    begin
        for(i_6=44; i_6<51; i_6=i_6+1)
        begin
            word[i_6] <= 0;
        end
    end
    else
    begin
        for(j_6=0; j_6<8; j_6=j_6+1) //storing intermediate hash values in temporary register
            h_6_temp[j_6] = h_5_6[j_6];
        for(i_6=44; i_6<51; i_6=i_6+1) //calculating Word
        begin
            word[i_6] = lowercase_sigma_1_output(word[i_6-2]) + word[i_6-7] + lowercase_sigma_0_output(word[i_6-15]) + word[i_6-16];
        end
        for(j_6=28; j_6<35; j_6=j_6+1)
        begin
            T1_6 = h_6_temp[7] + uppercase_sigma_1_output(h_6_temp[4]) + choice_output(h_6_temp[4], h_6_temp[5], h_6_temp[6]) + get_K(j_6) + word[j_6];
            T2_6 = uppercase_sigma_0_output(h_6_temp[0]) + majority_output(h_6_temp[0], h_6_temp[1], h_6_temp[2]);
            h_6_temp[7] = h_6_temp[6];
            h_6_temp[6] = h_6_temp[5];
            h_6_temp[5] = h_6_temp[4];
            h_6_temp[4] = h_6_temp[3] + T1_6;
            h_6_temp[3] = h_6_temp[2];
            h_6_temp[2] = h_6_temp[1];
            h_6_temp[1] = h_6_temp[0];
            h_6_temp[0] = T1_6 + T2_6;
        end
        for(j_6=0; j_6<8; j_6=j_6+1) //storing calculated passed to next stage
            h_6_7[j_6] <= h_6_temp[j_6];
    end
end

integer i_7, j_7;
reg [31:0] h_7_temp [0:7]; 
reg [31:0] T1_7, T2_7;
reg [31:0] h_7_8 [0:7];
//stage 7 : W51 to W57 & Round 35 to 41
always@(posedge clk)
begin
    if(rst)
    begin
        for(i_7=51; i_7<58; i_7=i_7+1)
        begin
            word[i_7] <= 0;
        end
    end
    else
    begin
        for(j_7=0; j_7<8; j_7=j_7+1) //storing intermediate hash values in temporary register
            h_7_temp[j_7] = h_6_7[j_7];
        for(i_7=51; i_7<58; i_7=i_7+1) //calculating Word
        begin
            word[i_7] = lowercase_sigma_1_output(word[i_7-2]) + word[i_7-7] + lowercase_sigma_0_output(word[i_7-15]) + word[i_7-16];
        end
        for(j_7=35; j_7<42; j_7=j_7+1)
        begin
            T1_7 = h_7_temp[7] + uppercase_sigma_1_output(h_7_temp[4]) + choice_output(h_7_temp[4], h_7_temp[5], h_7_temp[6]) + get_K(j_7) + word[j_7];
            T2_7 = uppercase_sigma_0_output(h_7_temp[0]) + majority_output(h_7_temp[0], h_7_temp[1], h_7_temp[2]);
            h_7_temp[7] = h_7_temp[6];
            h_7_temp[6] = h_7_temp[5];
            h_7_temp[5] = h_7_temp[4];
            h_7_temp[4] = h_7_temp[3] + T1_7;
            h_7_temp[3] = h_7_temp[2];
            h_7_temp[2] = h_7_temp[1];
            h_7_temp[1] = h_7_temp[0];
            h_7_temp[0] = T1_7 + T2_7;
        end
        for(j_7=0; j_7<8; j_7=j_7+1) //storing calculated passed to next stage
            h_7_8[j_7] <= h_7_temp[j_7];
    end
end

integer i_8, j_8;
reg [31:0] h_8_temp [0:7]; 
reg [31:0] T1_8, T2_8;
reg [31:0] h_8_9 [0:7];
//stage 8 : W58 to W63 & Round 42 to 48
always@(posedge clk)
begin
    if(rst)
    begin
        for(i_8=58; i_8<64; i_8=i_8+1)
        begin
            word[i_8] <= 0;
        end
    end
    else
    begin
        for(j_8=0; j_8<8; j_8=j_8+1) //storing intermediate hash values in temporary register
            h_8_temp[j_8] = h_7_8[j_8];
        for(i_8=58; i_8<64; i_8=i_8+1) //calculating Word
        begin
            word[i_8] = lowercase_sigma_1_output(word[i_8-2]) + word[i_8-7] + lowercase_sigma_0_output(word[i_8-15]) + word[i_8-16];
        end
        for(j_8=42; j_8<49; j_8=j_8+1)
        begin
            T1_8 = h_8_temp[7] + uppercase_sigma_1_output(h_8_temp[4]) + choice_output(h_8_temp[4], h_8_temp[5], h_8_temp[6]) + get_K(j_8) + word[j_8];
            T2_8 = uppercase_sigma_0_output(h_8_temp[0]) + majority_output(h_8_temp[0], h_8_temp[1], h_8_temp[2]);
            h_8_temp[7] = h_8_temp[6];
            h_8_temp[6] = h_8_temp[5];
            h_8_temp[5] = h_8_temp[4];
            h_8_temp[4] = h_8_temp[3] + T1_8;
            h_8_temp[3] = h_8_temp[2];
            h_8_temp[2] = h_8_temp[1];
            h_8_temp[1] = h_8_temp[0];
            h_8_temp[0] = T1_8 + T2_8;
        end
        for(j_8=0; j_8<8; j_8=j_8+1) //storing calculated passed to next stage
            h_8_9[j_8] <= h_8_temp[j_8];
    end
end

integer j_9;
reg [31:0] h_9_temp [0:7]; 
reg [31:0] T1_9, T2_9;
reg [31:0] h_9_10 [0:7];
//stage 9 : Round 49 to 55
always@(posedge clk)
begin
    if(rst)
    begin
//        for(i_8=58; i_8<64; i_8=i_8+1)
//        begin
//            word[i_8] <= 0;
//        end
    end
    else
    begin
        for(j_9=0; j_9<8; j_9=j_9+1) //storing intermediate hash values in temporary register
            h_9_temp[j_9] = h_8_9[j_9];
//        for(i_8=58; i_8<64; i_8=i_8+1) //calculating Word
//        begin
//            word[i_8] = lowercase_sigma_1_output(word[i_8-2]) + word[i_8-7] + lowercase_sigma_0_output(word[i_8-15]) + word[i_8-16];
//        end
        for(j_9=49; j_9<56; j_9=j_9+1)
        begin
            T1_9 = h_9_temp[7] + uppercase_sigma_1_output(h_9_temp[4]) + choice_output(h_9_temp[4], h_9_temp[5], h_9_temp[6]) + get_K(j_9) + word[j_9];
            T2_9 = uppercase_sigma_0_output(h_9_temp[0]) + majority_output(h_9_temp[0], h_9_temp[1], h_9_temp[2]);
            h_9_temp[7] = h_9_temp[6];
            h_9_temp[6] = h_9_temp[5];
            h_9_temp[5] = h_9_temp[4];
            h_9_temp[4] = h_9_temp[3] + T1_9;
            h_9_temp[3] = h_9_temp[2];
            h_9_temp[2] = h_9_temp[1];
            h_9_temp[1] = h_9_temp[0];
            h_9_temp[0] = T1_9 + T2_9;
        end
        for(j_9=0; j_9<8; j_9=j_9+1) //storing calculated passed to next stage
            h_9_10[j_9] <= h_9_temp[j_9];
    end
end

integer j_10;
reg [31:0] h_10_temp [0:7]; 
reg [31:0] T1_10, T2_10;
//reg [31:0] h_9_10 [0:7];
//stage 10 : Round 56 to 63
always@(posedge clk)
begin
    if(rst)
    begin
//        for(i_8=58; i_8<64; i_8=i_8+1)
//        begin
//            word[i_8] <= 0;
//        end
    end
    else
    begin
        for(j_10=0; j_10<8; j_10=j_10+1) //storing intermediate hash values in temporary register
            h_10_temp[j_10] = h_9_10[j_10];
//        for(i_8=58; i_8<64; i_8=i_8+1) //calculating Word
//        begin
//            word[i_8] = lowercase_sigma_1_output(word[i_8-2]) + word[i_8-7] + lowercase_sigma_0_output(word[i_8-15]) + word[i_8-16];
//        end
        for(j_10=56; j_10<64; j_10=j_10+1)
        begin
            T1_10 = h_10_temp[7] + uppercase_sigma_1_output(h_10_temp[4]) + choice_output(h_10_temp[4], h_10_temp[5], h_10_temp[6]) + get_K(j_10) + word[j_10];
            T2_10 = uppercase_sigma_0_output(h_10_temp[0]) + majority_output(h_10_temp[0], h_10_temp[1], h_10_temp[2]);
            h_10_temp[7] = h_10_temp[6];
            h_10_temp[6] = h_10_temp[5];
            h_10_temp[5] = h_10_temp[4];
            h_10_temp[4] = h_10_temp[3] + T1_10;
            h_10_temp[3] = h_10_temp[2];
            h_10_temp[2] = h_10_temp[1];
            h_10_temp[1] = h_10_temp[0];
            h_10_temp[0] = T1_10 + T2_10;
        end
//        for(j_9=0; j_9<8; j_9=j_9+1) //storing calculated passed to next stage
//            h_9_10[j_9] <= h_9_temp[j_9];
        H[0] <= h_10_temp[0] + 32'h6a09e667;
        H[1] <= h_10_temp[1] + 32'hbb67ae85;
        H[2] <= h_10_temp[2] + 32'h3c6ef372;
        H[3] <= h_10_temp[3] + 32'ha54ff53a;
        H[4] <= h_10_temp[4] + 32'h510e527f;
        H[5] <= h_10_temp[5] + 32'h9b05688c;
        H[6] <= h_10_temp[6] + 32'h1f83d9ab;
        H[7] <= h_10_temp[7] + 32'h5be0cd19;
        
        digest <= {H[0],H[1],H[2],H[3],H[4],H[5],H[6],H[7]}; //final digest
    end
end






// Function in SHA-256
function [31:0] choice_output(input [31:0] x,input [31:0] y,input [31:0] z);
    choice_output = (x & y) ^ ((~x) & z);
endfunction

function [31:0] majority_output(input [31:0] x,input [31:0] y,input [31:0] z);
    majority_output = (x & y) ^ (y & z) ^ (z & x);
endfunction

function [31:0] lowercase_sigma_0_output(input [31:0] x);
    lowercase_sigma_0_output = {x[6:0], x[31:7]} ^ {x[17:0], x[31:18]} ^ (x >> 3);
//    ?0(x)=ROTR7(x)?ROTR18(x)?SHR3(x)
endfunction

function [31:0] lowercase_sigma_1_output(input [31:0] x);
    lowercase_sigma_1_output = {x[16:0], x[31:17]} ^ {x[18:0], x[31:19]} ^ (x >> 10);
//    ?1(x)=ROTR17(x)?ROTR19(x)?SHR10(x)
endfunction

function [31:0] uppercase_sigma_0_output(input [31:0] x);
    uppercase_sigma_0_output = {x[1:0], x[31:2]} ^ {x[12:0], x[31:13]} ^ {x[21:0], x[31:22]};
//    ?0(x) = ROTR2(x)?ROTR13(x)?ROTR22(x)
endfunction

function [31:0] uppercase_sigma_1_output(input [31:0] x);
    uppercase_sigma_1_output = {x[5:0], x[31:6]} ^ {x[10:0], x[31:11]} ^ {x[24:0], x[31:25]};
//    ?1(x) = ROTR6(x)?ROTR11(x)?ROTR25(x) 
endfunction

function automatic [31:0] get_K;
        input [5:0] index;
            case(index)
                6'd0:  get_K = 32'h428a2f98;
                6'd1:  get_K = 32'h71374491;
                6'd2:  get_K = 32'hb5c0fbcf;
                6'd3:  get_K = 32'he9b5dba5;
                6'd4:  get_K = 32'h3956c25b;
                6'd5:  get_K = 32'h59f111f1;
                6'd6:  get_K = 32'h923f82a4;
                6'd7:  get_K = 32'hab1c5ed5;
                6'd8:  get_K = 32'hd807aa98;
                6'd9:  get_K = 32'h12835b01;
                6'd10: get_K = 32'h243185be;
                6'd11: get_K = 32'h550c7dc3;
                6'd12: get_K = 32'h72be5d74;
                6'd13: get_K = 32'h80deb1fe;
                6'd14: get_K = 32'h9bdc06a7;
                6'd15: get_K = 32'hc19bf174;
                6'd16: get_K = 32'he49b69c1;
                6'd17: get_K = 32'hefbe4786;
                6'd18: get_K = 32'h0fc19dc6;
                6'd19: get_K = 32'h240ca1cc;
                6'd20: get_K = 32'h2de92c6f;
                6'd21: get_K = 32'h4a7484aa;
                6'd22: get_K = 32'h5cb0a9dc;
                6'd23: get_K = 32'h76f988da;
                6'd24: get_K = 32'h983e5152;
                6'd25: get_K = 32'ha831c66d;
                6'd26: get_K = 32'hb00327c8;
                6'd27: get_K = 32'hbf597fc7;
                6'd28: get_K = 32'hc6e00bf3;
                6'd29: get_K = 32'hd5a79147;
                6'd30: get_K = 32'h06ca6351;
                6'd31: get_K = 32'h14292967;
                6'd32: get_K = 32'h27b70a85;
                6'd33: get_K = 32'h2e1b2138;
                6'd34: get_K = 32'h4d2c6dfc;
                6'd35: get_K = 32'h53380d13;
                6'd36: get_K = 32'h650a7354;
                6'd37: get_K = 32'h766a0abb;
                6'd38: get_K = 32'h81c2c92e;
                6'd39: get_K = 32'h92722c85;
                6'd40: get_K = 32'ha2bfe8a1;
                6'd41: get_K = 32'ha81a664b;
                6'd42: get_K = 32'hc24b8b70;
                6'd43: get_K = 32'hc76c51a3;
                6'd44: get_K = 32'hd192e819;
                6'd45: get_K = 32'hd6990624;
                6'd46: get_K = 32'hf40e3585;
                6'd47: get_K = 32'h106aa070;
                6'd48: get_K = 32'h19a4c116;
                6'd49: get_K = 32'h1e376c08;
                6'd50: get_K = 32'h2748774c;
                6'd51: get_K = 32'h34b0bcb5;
                6'd52: get_K = 32'h391c0cb3;
                6'd53: get_K = 32'h4ed8aa4a;
                6'd54: get_K = 32'h5b9cca4f;
                6'd55: get_K = 32'h682e6ff3;
                6'd56: get_K = 32'h748f82ee;
                6'd57: get_K = 32'h78a5636f;
                6'd58: get_K = 32'h84c87814;
                6'd59: get_K = 32'h8cc70208;
                6'd60: get_K = 32'h90befffa;
                6'd61: get_K = 32'ha4506ceb;
                6'd62: get_K = 32'hbef9a3f7;
                6'd63: get_K = 32'hc67178f2;
                default: get_K = 32'h00000000;
            endcase
endfunction


endmodule