module mr_logic (ex_dval, ex_sval, v_mr_re, v_ld_eip_jmp, v_ld_cs, eipval, mr_stall, rmsel, re, read_finished, dval, sval, addr, mem_val, jmp, mr_v);
    input wire[31:0] dval, sval, mem_val, addr;
    input wire[2:0] jmp;
    input wire[0:0] re, read_finished, mr_v, rmsel;
    output wire[0:0] v_mr_re, v_ld_eip_jmp, v_ld_cs, mr_stall;
    output wire[31:0] ex_dval, ex_sval, eipval;
    
    wire[0:0] reb, dval_sel, sval_sel, v_temp, rmselb, reb_or_rf, v_reb_or_rf;
    inv1$ inv1(reb, re),
          inv2(rmselb, rmsel),
          inv3(read_finishedb, read_finished);

    or2$ or1(reb_or_rf, reb, read_finished);
    and2$ and1(v_reb_or_rf, mr_v, reb_or_rf),
          and2(dval_sel, re, rmsel),
          and3(sval_sel, re, rmselb),
          and4(v_mr_re, re, mr_v),
          and5(v_ld_eip_jmp, v_reb_or_rf, jmp[2]),
          and6(v_ld_cs, v_ld_eip_jmp, jmp[1]);
    and3$ and7(mr_stall, mr_v, re, read_finishedb);

    mux2_32 mux1(ex_dval, dval, mem_val, dval_sel),
            mux2(ex_sval, sval, mem_val, sval_sel),
            mux3(eipval, addr, mem_val, re);
    
     

endmodule

