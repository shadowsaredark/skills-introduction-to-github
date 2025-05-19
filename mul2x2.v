`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2025 11:42:20 PM
// Design Name: 
// Module Name: mul2x2
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
module mul2x2(
    input [1:0] a,
    input [1:0] b,
    output [3:0] p
    );
  wire pp0, pp1, pp2, pp3;       // Partial products
    wire sum1, carry1;

    // Partial Products
    assign pp0 = a[0] & b[0];      // Bit 0
    assign pp1 = a[1] & b[0];      // Bit 1
    assign pp2 = a[0] & b[1];      // Bit 1
    assign pp3 = a[1] & b[1];      // Bit 2

    // First level addition (bit 1): Half Adder
    assign sum1   = pp1 ^ pp2;
    assign carry1 = pp1 & pp2;

    // Final product bits
    assign p[0] = pp0;
    assign p[1] = sum1;
    assign p[2] = carry1 ^ pp3;
    assign p[3] = carry1 & pp3;

endmodule
