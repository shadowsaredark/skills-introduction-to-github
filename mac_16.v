    `timescale 1ns / 1ps
    
    module mac16 (
        input         clk,
        input         rst_n,
        input  [15:0] a,     // multiplicand
        input  [15:0] b,     // multiplier
        input  [31:0] acc,   // accumulator input (delayed 2 cycles internally)
        output reg [31:0] out // result output
    );
    
        // ----------------------------
        // Stage 1: Multiply a * b
        // ----------------------------
        wire [31:0] prod;
    
        mul16x16 mul_inst (
            .a(a),
            .b(b),
            .p(prod)  // this output is pipelined inside mul16x16
        );
    
        // ----------------------------
        // Stage 2: Buffer product
        // ----------------------------
        reg [31:0] reg_prod;
    
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n)
                reg_prod <= 0;
            else
                reg_prod <= prod;  // Stage 2 latch
        end
    
        // ----------------------------
        // Stage 3: Add to delayed acc
        // ----------------------------
        // Delay acc by 2 cycles to match reg_prod
        reg [31:0] acc_d1, acc_d2;
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                acc_d1 <= 0;
                acc_d2 <= 0;
            end else begin
                acc_d1 <= acc;
                acc_d2 <= acc_d1;
            end
        end
    
        wire [31:0] sum;
        wire cout_dummy;
    
        CLA #(.DATA_WIDTH(32)) adder (
            .a(reg_prod),
            .b(acc_d2),
            .cin(1'b0),
            .sum(sum),
            .cout(cout_dummy)
        );
    
        // Output register
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n)
                out <= 0;
            else
                out <= sum;
        end
    
    endmodule