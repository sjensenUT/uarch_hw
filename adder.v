module adder32 (out, couts, a, b);
    input wire[31:0] a, b;
    output wire[31:0] out;
    output wire[31:0] couts;

    generate
        genvar i;
        for(i = 0; i < 32; i = i + 1) begin : adders
            full_adder adder(out[i], 
                couts[i], 
                a[i],
                b[i],
                i == 0 ? 1'b0 : couts[i-1]);        
        end
    endgenerate

endmodule

module adder16 (out, couts, a, b);
    input wire[15:0] a, b;
    output wire[15:0] out;
    output wire[15:0] couts;

    generate
        genvar i;
        for(i = 0; i < 16; i = i + 1) begin : adders
            full_adder adder(out[i], 
                couts[i], 
                a[i],
                b[i],
                i == 0 ? 1'b0 : couts[i-1]);        
        end
    endgenerate

endmodule




