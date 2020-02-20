module pe4_2 (out, v, in);
    input wire[3:0] in;
    output wire[1:0] out;
    output wire[0:0] v;

    wire[0:0] in2b, in2b_and_in1;
    
    inv1$ inv1 (in2b, in[2]);
    and2$ and1 (in2b_and_in1, in2b, in[1]);
    or2$ or1 (out[0], in[3], in2b_and_in1),
        or2(out[1], in[3], in[2]);
    or3$ or3(v, out[1], in[1], in[0]);
endmodule

module pe16_4 (out, v, in);
    input wire[15:0] in;
    output wire[3:0] out;
    output wire[0:0] v;
    
    wire[3:0] vs;
    wire[1:0] out3, out2, out1, out0;
    pe4_2 pe1 (out3, vs[3], in[15:12]),
        pe2 (out2, vs[2], in[11:8]),
        pe3 (out1, vs[1], in[7:4]),
        pe4 (out0, vs[0], in[3:0]),
        pe5 (out[3:2], v, vs);
    mux4_2 mux1 (out[1:0], out0, out1, out2, out3, out[3:2]);

endmodule

module pe32_5 (out, v, in);
    input wire[31:0] in;
    output wire[4:0] out;
    output wire[0:0] v;

    wire[0:0] v_high, v_low;
    wire[3:0] out_high, out_low;

    pe16_4 pe_high (out_high, v_high, in[31:16]),
        pe_low (out_low, v_low, in[15:0]);
    or2$ or1 (v, v_high, v_low);
    assign out[4] = v_high;
    mux2_4 mux1(out[3:0], out_low, out_high, v_high);

endmodule
