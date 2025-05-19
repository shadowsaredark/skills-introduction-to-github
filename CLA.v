`timescale 1ns / 1ps


module CLA #(
    parameter DATA_WIDTH = 8
    )
    (   
    input [DATA_WIDTH-1:0] a,
    input [DATA_WIDTH-1:0] b,
    input  cin,
    output [DATA_WIDTH-1:0] sum,
    output cout
    );
    wire [DATA_WIDTH-1:0] g;
    wire [DATA_WIDTH-1:0] p;
    wire [DATA_WIDTH:0]   c;
    
    assign c[0] = cin;
    
    
    genvar i;
    
    generate
     for(i=0;i<DATA_WIDTH;i=i+1) begin
            assign sum[i] = a[i] ^ b[i] ^ c[i];
            assign p[i] = a[i] | b[i];
            assign g[i] = a[i] & b[i];
            assign c[i+1] = g[i] | (p[i] & c[i]);
            end
     endgenerate
     assign cout  = c[DATA_WIDTH];       
endmodule
