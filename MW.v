module mw_logic (mwe, rfwe, flagwe, drid, flags, af, cf, of, aluval, modrm, rmsel, we, flagw, v);
    input wire[31:0] aluval, flagw;
    input wire[0:0] af, cf, of, we, rmsel, v;
    input wire[7:0] modrm;
    output wire[31:0] flags, flagwe;
    output wire[0:0] mwe, rfwe;
    output wire[2:0] drid;
    
    wire[0:0] mod_indirect, rfwe_temp;
    wire[31:0] v_vector;
    generate
        genvar i;
        for(i = 0; i < 32; i = i + 1) begin : vs
            assign v_vector[i] = v;
        end
    endgenerate    
 
    nand2$ nand1(mod_indirect, modrm[7], modrm[6]),
           nand2(rfwe_temp, rmsel, mod_indirect); 
    and4$ and1(mwe, we, rmsel, mod_indirect, v);
    and3$ and2(rfwe, rfwe_temp, we, v);
    and2_32 and5(flagwe, flagw, v_vector);

    mux2_3 mux2(drid, modrm[5:3], modrm[2:0], rmsel);
    assign flags[0] = cf;
    xnor8_1 xnor1(flags[2], aluval[7:0]);
    assign flags[4] = af;
    nor32_1 nor1(flags[6], aluval);
    assign flags[7] = aluval[31];
    assign flags[11] = of;
endmodule

