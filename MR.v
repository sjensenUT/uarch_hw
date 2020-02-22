module mr_logic (ex_v, ex_dval, ex_sval, mre, eipwe, cswe, eipval, rmsel, re, read_finished, dval, sval, addr, mem_val, jmp, mr_v);
    input wire[31:0] dval, sval, mem_val, addr;
    input wire[2:0] jmp;
    input wire[0:0] re, read_finished, mr_v, rmsel;
    output wire[0:0] ex_v, mre, eipwe, cswe;
    output wire[31:0] ex_dval, ex_sval, eipval;
    
    wire[0:0] reb, dval_sel, sval_sel, v_temp, rmselb;
    inv1$ inv1(reb, re),
          inv2(rmselb, rmsel);

    or2$ or1(v_temp, reb, read_finished);
    and2$ and1(ex_v, mr_v, v_temp),
          and2(dval_sel, re, rmsel),
          and3(sval_sel, re, rmselb),
          and4(mre, re, mr_v),
          and5(eipwe, ex_v, jmp[2]),
          and6(cswe, eipwe, jmp[1]);

    mux2_32 mux1(ex_dval, dval, mem_val, dval_sel),
            mux2(ex_sval, sval, mem_val, sval_sel),
            mux3(eipval, addr, mem_val, re);
    
    

endmodule

