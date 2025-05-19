`timescale 1ns / 1ps

module mul16x16 (
    input  [15:0] a,
    input  [15:0] b,
    output [31:0] p
);

    // Split into 8-bit segments
    wire [7:0] a_high = a[15:8];
    wire [7:0] a_low  = a[7:0];
    wire [7:0] b_high = b[15:8];
    wire [7:0] b_low  = b[7:0];

    // 8x8 Partial Products
    wire [15:0] pp_hh, pp_lh, pp_hl, pp_ll;

    mul8x8 u_hh (.a(a_high), .b(b_high), .p(pp_hh));
    mul8x8 u_lh (.a(a_low),  .b(b_high), .p(pp_lh));
    mul8x8 u_hl (.a(a_high), .b(b_low),  .p(pp_hl));
    mul8x8 u_ll (.a(a_low),  .b(b_low),  .p(pp_ll));

    // Align and sum partial products combinationally
    wire [31:0] term_ll = {16'b0, pp_ll};                // pp_ll
    wire [31:0] term_lh = {8'b0, pp_lh, 8'b0};           // pp_lh << 8
    wire [31:0] term_hl = {8'b0, pp_hl, 8'b0};           // pp_hl << 8
    wire [31:0] term_hh = {pp_hh, 16'b0};                // pp_hh << 16

    assign p = term_ll + term_lh + term_hl + term_hh;

endmodule
