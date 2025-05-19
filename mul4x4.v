`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2025 01:31:06 AM
// Design Name: 
// Module Name: mul4x4
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




module mul4x4 #(parameter N = 4)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [2*N-1:0] p
);
    wire [3:0] pp_ah_bh, pp_al_bh, pp_ah_bl, pp_al_bl;
    wire [7:0] shifted_pp1, shifted_pp2, shifted_pp3, shifted_pp4;
    wire [7:0] sum1, sum2;
    wire c1, c2;

    // Partial product generation
    mul2x2 u1(.a(a[3:2]), .b(b[3:2]), .p(pp_ah_bh));
    mul2x2 u2(.a(a[1:0]), .b(b[3:2]), .p(pp_al_bh));
    mul2x2 u3(.a(a[3:2]), .b(b[1:0]), .p(pp_ah_bl));
    mul2x2 u4(.a(a[1:0]), .b(b[1:0]), .p(pp_al_bl));

    // Shift partial products
    assign shifted_pp1 = {pp_ah_bh, 4'b0000};
    assign shifted_pp2 = {2'b00, pp_al_bh, 2'b00};
    assign shifted_pp3 = {2'b00, pp_ah_bl, 2'b00};
    assign shifted_pp4 = {4'b0000, pp_al_bl};

    // Add partial products
    CLA #(.DATA_WIDTH(8)) cla1(.a(shifted_pp3), .b(shifted_pp4), .cin(1'b0), .sum(sum1), .cout(c1));
    CLA #(.DATA_WIDTH(8)) cla2(.a(shifted_pp1), .b(shifted_pp2), .cin(c1), .sum(sum2), .cout(c2));
    CLA #(.DATA_WIDTH(8)) cla3(.a(sum1), .b(sum2), .cin(c2), .sum(p), .cout());

endmodule

    


	