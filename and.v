module and2_32 (out, a, b);
    input wire[31:0] a, b;
    output wire[31:0] out;

    generate
        genvar i;
        for(i = 0; i < 32; i = i + 1) begin : ands
            and2$ and1(out[i], a[i], b[i]);
        end
    endgenerate
endmodule

