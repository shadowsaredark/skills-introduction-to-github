`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2025 09:46:42 PM
// Design Name: 
// Module Name: mul8x8
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


module mul8x8 (
    input  [7:0]  a,
    input  [7:0]  b,
    output [15:0] p
);

    // Intermediate partial products
    wire [7:0] pp_hh; // a[7:4] * b[7:4]
    wire [7:0] pp_lh; // a[3:0] * b[7:4]
    wire [7:0] pp_hl; // a[7:4] * b[3:0]
    wire [7:0] pp_ll; // a[3:0] * b[3:0]

    // Intermediate sums
    wire [15:0] sum1, sum2;
    wire carry1, carry2;

    // Instantiate 4x4 multipliers
    mul4x4 u_hh (.a(a[7:4]), .b(b[7:4]), .p(pp_hh)); // Most significant
    mul4x4 u_lh (.a(a[3:0]), .b(b[7:4]), .p(pp_lh));
    mul4x4 u_hl (.a(a[7:4]), .b(b[3:0]), .p(pp_hl));
    mul4x4 u_ll (.a(a[3:0]), .b(b[3:0]), .p(pp_ll)); // Least significant

    // Sum partial products with appropriate shifts:
    // sum1 = (pp_hl << 4) + pp_ll
    // sum2 = (pp_hh << 8) + (pp_lh << 4)
    CLA #(.DATA_WIDTH(16)) cla1 (
        .a({4'b0000, pp_hl, 4'b0000}), 
        .b({8'b00000000, pp_ll}), 
        .cin(1'b0), 
        .sum(sum1), 
        .cout(carry1)
    );

    CLA #(.DATA_WIDTH(16)) cla2 (
        .a({pp_hh, 8'b00000000}), 
        .b({4'b0000, pp_lh, 4'b0000}), 
        .cin(carry1), 
        .sum(sum2), 
        .cout(carry2)
    );

    // Final sum
    CLA #(.DATA_WIDTH(16)) cla3 (
        .a(sum1), 
        .b(sum2), 
        .cin(carry2), 
        .sum(p), 
        .cout() // Final carry ignored for 16-bit product
    );

endmodule

