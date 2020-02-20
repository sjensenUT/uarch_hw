module bsf32 (out, v, in);
    input wire[31:0] in;
    output wire[31:0] out;
    output wire[0:0] v;

    wire[31:0] minus_1, pe_in;
    wire[31:0] couts;
    
    adder32 adder(minus_1, couts, in, 32'hFFFFFFFF);
    xor2_32 xor1(pe_in, in, minus_1);
    pe32_5 pe1(out[4:0], v, pe_in);
    assign out[31:5] = 27'h0;

endmodule

