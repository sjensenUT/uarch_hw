module ALU (out, a, b, sel, cf, af, of);
    input wire[31:0] a, b;
    input wire[1:0] sel;
    output wire[31:0] out;
    output wire[0:0] cf, af, of;
    
    wire[31:0] out1, out2, out3, couts;
    wire[0:0] carry_sel, xnorab, xorao, of_temp;

    or2_32 or1(out1, a, b);
    adder32 adder1(out3, couts, a, b);
    per32_5 per1(out2[4:0], v, a);
    assign out2[31:5] = 27'h0;
    
    mux4_32 mux1(out, b, out1, out2, out3, sel);
    
    
    and2$ and1(carry_sel, sel[1], sel[0]),
          and2(of_temp, xnorab, xorao);
    mux2$ mux2(cf, 1'b0, couts[31], carry_sel),
          mux3(af, 1'b0, couts[3], carry_sel),
          mux4(of, 1'b0, of_temp, carry_sel);
    
    xnor2$ xnor1(xnorab, a[31], b[31]);
    xor2$ xor1(xorao, a[31], out[31]);
    
    

endmodule

