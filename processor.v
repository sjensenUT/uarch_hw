module TOP;

    //reg[31:0] dval, sval, disp, flags, flag_ld;
    //reg[15:0] sreg, ptr;
    //reg[0:0] we, re, v, rmsel;
    //reg[2:0] jmp;
    //reg[1:0] alusel;
    //reg[7:0] modrm;
    reg[0:0] clk, s, r;

    //FETCH
    wire[0:0] reg_dep_stall, mem_dep_stall, mr_stall, mw_stall, ld_de, de_vin, f_ld_eip;
    wire[127:0] f_instr;
    wire[31:0] eflags, eip, f_new_eip, new_eip;
    wire[15:0] cs;

    //DECODE 
    wire[0:0] de_v, de_re, de_we, ag_vin, de_rmsel, ro_needed, rm_needed, ld_ag;
    wire[1:0] de_alusel;
    wire[2:0] de_jmp;
    wire[7:0] de_modrm;
    wire[15:0] de_sreg, de_ptr;
    wire[31:0] de_dval, de_sval, de_disp, de_flags, de_flag_ld;
    wire[127:0] de_instr;
    
    //ADDRESS GENERATE  
    wire[0:0] ag_v, ag_re, ag_we, ag_rmsel, ld_mr, mr_vin;
    wire[1:0] ag_alusel;
    wire[2:0] ag_jmp;
    wire[31:0] ag_dval, ag_sval, ag_disp, mr_addrin, ag_flags, ag_flag_ld;
    wire[15:0] ag_sreg, ag_ptr;
    wire[7:0] ag_modrm;

    //MEM READ
    wire[0:0] mr_re, mr_we, mr_rmsel, read_finished, write_finished, ex_vin, v_mr_re, ld_ex, v_ld_eip_jmp, v_ld_cs;
    wire[31:0] mr_addr, mr_dval, mr_sval, mem_val, ex_dvalin, ex_svalin, mr_flags, mr_flag_ld, mr_eip;
    wire[15:0] mr_ptr;
    wire[7:0] mr_modrm;
    wire[1:0] mr_alusel;
    wire[2:0] mr_jmp;

    //EXECUTE
    wire[0:0] ex_v, ex_we, ex_rmsel, mw_cfin, mw_afin, mw_ofin, ld_mw;
    wire[31:0] ex_addr, ex_dval, ex_sval, ex_flags, ex_flag_ld, mw_aluvalin;
    wire[15:0] ex_ptr;
    wire[7:0] ex_modrm;
    wire[1:0] ex_alusel;

    //MEM WRITEBACK
    wire[0:0] mw_v, mw_we, mw_cf, mw_af, mw_of, mw_rmsel, v_rf_ld, v_mem_we;
    wire[31:0] mw_aluval, mw_flags, mw_flag_ld, mw_addr, new_flags, v_flag_ld;
    wire[7:0] mw_modrm;
    wire[2:0] wreg;
    
    //FETCH 
    dummy_fetch df(.de_vin(de_vin), .ld_de(ld_de), .f_instr(f_instr), .f_new_eip(f_new_eip), .f_ld_eip(f_ld_eip), .eip(eip), .v_de_jmp(de_jmp[2] & de_v), .v_ag_jmp(ag_jmp[2] & ag_v),
                   .v_mr_jmp(mr_jmp[2] & mr_v), .reg_dep(reg_dep_stall), .mem_dep(mem_dep_stall), .mr_stall(mr_stall), .mw_stall(mw_stall));
    assign new_eip = f_ld_eip == 1 ? f_new_eip : mr_eip;  
    dffe32 eip_dff(.clk(clk), .d(new_eip), .q(eip), .qb(), .r(r), .s(s), .e(v_ld_eip_jmp | f_ld_eip));
    dffe16 cs_dff(.clk(clk), .d(mr_ptr), .q(cs), .qb(), .r(r), .s(s), .e(v_ld_cs));

    //DECODE
    dffe dev_dff(.clk(clk), .d(de_vin), .q(de_v), .qb(), .r(r), .s(s), .e(ld_de));
    dffe128 deinstr_dff(.clk(clk), .d(f_instr), .q(de_instr), .qb(), .r(r), .s(s), .e(ld_de));
    dummy_decode de(.de_re(de_re), .de_we(de_we), .ag_vin(ag_vin), .de_rmsel(de_rmsel), .de_alusel(de_alusel), .de_dval(de_dval),
                .de_sval(de_sval), .de_disp(de_disp), .de_flags(de_flags), .de_flag_ld(de_flag_ld), .de_sreg(de_sreg),
                .de_ptr(de_ptr), .de_modrm(de_modrm), .de_jmp(de_jmp), .ro_needed(ro_needed), .rm_needed(rm_needed), 
                .ld_ag(ld_ag), .mem_dep(mem_dep_stall), .reg_dep(reg_dep_stall), .mr_stall(mr_stall), .mw_stall(mw_stall), 
                .de_v(de_v), .instr(de_instr), .clk(clk));
    reg_dep_logic rdl(.reg_dep(reg_dep_stall), .ro_needed(ro_needed), .rm_needed(rm_needed), .modrm(de_modrm), .v(de_v), 
                      .v_ag_we(ag_we & ag_v), .v_mr_we(mr_we & mr_v), .v_ex_we(ex_we & ex_v), .v_mw_we(mw_we & mw_v),
                      .ag_rmsel(ag_rmsel), .mr_rmsel(mr_rmsel), .ex_rmsel(ex_rmsel), .mw_rmsel(mw_rmsel), 
                      .ag_modrm(ag_modrm), .mr_modrm(mr_modrm), .ex_modrm(ex_modrm), .mw_modrm(mw_modrm));    
    dffev32 eflags_dff(.clk(clk), .d(new_flags), .q(eflags), .qb(), .r(r), .s(s), .e(v_flag_ld));
    regfile rf(.in(mw_aluval), .w(wreg), .we(v_rf_ld), .r1(3'b000), .r2(3'b000), .out1(), .out2(), .clk(clk));

    //ADDRESS GENERATE
    dffe agrmsel_dff(.clk(clk), .d(de_rmsel), .q(ag_rmsel), .qb(), .r(r), .s(s), .e(ld_ag)),
         agre_dff(.clk(clk), .d(de_re), .q(ag_re), .r(r), .s(s), .qb(), .e(ld_ag)),
         agwe_dff(.clk(clk), .d(de_we), .q(ag_we), .r(r), .s(s), .qb(), .e(ld_ag)),
         agv_dff(.clk(clk), .d(ag_vin), .q(ag_v), .qb(), .r(r), .s(s), .e(ld_ag));
    dffe32 agdval_dff(.clk(clk), .d(de_dval), .q(ag_dval), .qb(), .r(r), .s(s), .e(ld_ag)),
           agsval_dff(.clk(clk), .d(de_sval), .q(ag_sval), .qb(), .r(r), .s(s), .e(ld_ag)),
           agdisp_dff(.clk(clk), .d(de_disp), .q(ag_disp), .qb(), .r(r), .s(s), .e(ld_ag)),
           agflags_dff(.clk(clk), .d(de_flags), .q(ag_flags), .qb(), .r(r), .s(s), .e(ld_ag)),
           agflag_ld_dff(.clk(clk), .d(de_flag_ld), .q(ag_flag_ld), .qb(), .r(r), .s(s), .e(ld_ag));
    dffe16 agsreg_dff(.clk(clk), .d(de_sreg), .q(ag_sreg), .qb(), .r(r), .s(s), .e(ld_ag)),
           agptr_dff(.clk(clk), .d(de_ptr), .q(ag_ptr), .qb(), .r(r), .s(s), .e(ld_ag));
    dffe8 agmodrm_dff(.clk(clk), .d(de_modrm), .q(ag_modrm), .qb(), .r(r), .s(s), .e(ld_ag)); 
    dffe3 agjmp_dff(.clk(clk), .d(de_jmp), .q(ag_jmp), .qb(), .r(r), .s(s), .e(ld_ag));
    dffe2 agalusel_dff(.clk(clk), .d(de_alusel), .q(ag_alusel), .qb(), .r(r), .s(s), .e(ld_ag));
    
    addr_generator ag (mr_addrin, ag_dval, ag_sval, ag_disp, ag_rmsel, ag_modrm, ag_sreg, ag_re, ag_jmp);
    assign ld_mr = !(mr_stall | mw_stall);
    assign mr_vin = ag_v & !(mem_dep_stall);
    mem_dep_logic mdl(.mem_dep(mem_dep_stall), .re(ag_re), .v(ag_v), .addr(mr_addrin),
                      .v_mr_we(mr_we & mr_v), .v_ex_we(ex_we & ex_v), .v_mw_we(mw_we & mw_v),
                      .mr_rmsel(mr_rmsel), .ex_rmsel(ex_rmsel), .mw_rmsel(mw_rmsel), .mr_modrm(mr_modrm),
                      .ex_modrm(ex_modrm), .mw_modrm(mw_modrm), .mr_addr(mr_addr), .ex_addr(ex_addr), 
                      .mw_addr(mw_addr));
    

    //MEM READ
    dffe mrrmsel_dff(.clk(clk), .d(ag_rmsel), .q(mr_rmsel), .qb(), .r(r), .s(s), .e(ld_mr)),
         mrre_dff(.clk(clk), .d(ag_re), .q(mr_re), .qb(), .r(r), .s(s), .e(ld_mr)),
         mrwe_dff(.clk(clk), .d(ag_we), .q(mr_we), .qb(), .r(r), .s(s), .e(ld_mr)),
         mrv_dff(.clk(clk), .d(mr_vin), .q(mr_v), .qb(), .r(r), .s(s), .e(ld_mr));
    dffe32 mraddr_dff(.clk(clk), .d(mr_addrin), .q(mr_addr), .qb(), .r(r), .s(s), .e(ld_mr)),
           mrdval_dff(.clk(clk), .d(ag_dval), .q(mr_dval), .qb(), .r(r), .s(s), .e(ld_mr)),
           mrsval_dff(.clk(clk), .d(ag_sval), .q(mr_sval), .qb(), .r(r), .s(s), .e(ld_mr)),
           mrflags_dff(.clk(clk), .d(ag_flags), .q(mr_flags), .qb(), .r(r), .s(s), .e(ld_mr)),
           mrflag_ld_dff(.clk(clk), .d(ag_flag_ld), .q(mr_flag_ld), .qb(), .r(r), .s(s), .e(ld_mr));
    dffe16 mrptr_dff(.clk(clk), .d(ag_ptr), .q(mr_ptr), .qb(), .r(r), .s(s), .e(ld_mr));
    dffe8 mr_modrmdff(.clk(clk), .d(ag_modrm), .q(mr_modrm), .qb(), .r(r), .s(s), .e(ld_mr));
    dffe3 mrjmp_dff(.clk(clk), .d(ag_jmp), .q(mr_jmp), .qb(), .r(r), .s(s), .e(ld_mr));
    dffe2 mralusel_dff(.clk(clk), .d(ag_alusel), .q(mr_alusel), .qb(), .r(r), .s(s), .e(ld_mr));
    
    mr_logic mr(ex_dvalin, ex_svalin, v_mr_re, v_ld_eip_jmp, v_ld_cs, mr_eip, mr_stall, mr_rmsel, mr_re, read_finished, mr_dval, mr_sval, mr_addr, mem_val, mr_jmp, mr_v);
    assign ld_ex = !mw_stall;
    assign ex_vin = mr_v & !(mr_stall);
    
    //EXECUTE
    dffe exrmsel_dff(.clk(clk), .d(mr_rmsel), .q(ex_rmsel), .qb(), .r(r), .s(s), .e(ld_ex)),
         exwe_dff(.clk(clk), .d(mr_we), .q(ex_we), .qb(), .r(r), .s(s), .e(ld_ex)),
         exv_dff(.clk(clk), .d(ex_vin), .q(ex_v), .qb(), .r(r), .s(s), .e(ld_ex));
    dffe32 exaddr_dff(.clk(clk), .d(mr_addr), .q(ex_addr), .qb(), .r(r), .s(s), .e(ld_ex)),
           exdval_dff(.clk(clk), .d(ex_dvalin), .q(ex_dval), .qb(), .r(r), .s(s), .e(ld_ex)),
           exsval_dff(.clk(clk), .d(ex_svalin), .q(ex_sval), .qb(), .r(r), .s(s), .e(ld_ex)),
           exflags_dff(.clk(clk), .d(mr_flags), .q(ex_flags), .qb(), .r(r), .s(s), .e(ld_ex)),
           exflag_ld_dff(.clk(clk), .d(mr_flag_ld), .q(ex_flag_ld), .qb(), .r(r), .s(s), .e(ld_ex));
    dffe16 exptr_dff(.clk(clk), .d(mr_ptr), .q(ex_ptr), .qb(), .r(r), .s(s), .e(ld_ex));
    dffe8 exmodrm_dff(.clk(clk), .d(mr_modrm), .q(ex_modrm), .qb(), .r(r), .s(s), .e(ld_ex));
    dffe2 exalusel_dff(.clk(clk), .d(mr_alusel), .q(ex_alusel), .qb(), .r(r), .s(s), .e(ld_ex));
    
    ALU alu(mw_aluvalin, ex_dval, ex_sval, ex_alusel, mw_cfin, mw_afin, mw_ofin);
    assign ld_mw = !mw_stall; 
    assign mw_vin = ex_v; 

    //MEM WRITE   
    dffe mwrmsel_dff(.clk(clk), .d(ex_rmsel), .q(mw_rmsel), .qb(), .r(r), .s(s), .e(ld_mw)),
         mwwe_dff(.clk(clk), .d(ex_we), .q(mw_we), .qb(), .r(r), .s(s), .e(ld_mw)),
         mwv_dff(.clk(clk), .d(mw_vin), .q(mw_v), .qb(), .r(r), .s(s), .e(ld_mw)),
         mwaf_dff(.clk(clk), .d(mw_afin), .q(mw_af), .qb(), .r(r), .s(s), .e(ld_mw)),
         mwcf_dff(.clk(clk), .d(mw_cfin), .q(mw_cf), .qb(), .r(r), .s(s), .e(ld_mw)),
         mwof_dff(.clk(clk), .d(mw_ofin), .q(mw_of), .qb(), .r(r), .s(s), .e(ld_mw));
    dffe32 mwaddr_dff(.clk(clk), .d(ex_addr), .q(mw_addr), .qb(), .r(r), .s(s), .e(ld_mw)),
           mwaluval_dff(.clk(clk), .d(mw_aluvalin), .q(mw_aluval), .qb(), .r(r), .s(s), .e(ld_mw)),
           mwflags_dff(.clk(clk), .d(ex_flags), .q(mw_flags), .qb(), .r(r), .s(s), .e(ld_mw)),
           mwflag_ld_dff(.clk(clk), .d(ex_flag_ld), .q(mw_flag_ld), .qb(), .r(r), .s(s), .e(ld_mw));
    dffe8 mwmodrm_dff(.clk(clk), .d(ex_modrm), .q(mw_modrm), .qb(), .r(r), .s(s), .e(ld_mw));
    
    mw_logic mw(.v_mem_we(v_mem_we), .v_rf_ld(v_rf_ld), .v_flag_ld(v_flag_ld), .drid(wreg), 
        .flags(new_flags), .mw_stall(mw_stall), .af(mw_af), .cf(mw_cf), .of(mw_of), .aluval(mw_aluval),
        .modrm(mw_modrm), .rmsel(mw_rmsel), .we(mw_we), .flag_ld(mw_flag_ld), .write_finished(write_finished), .v(mw_v));
        
    dummy_mem mem (.d_out(mem_val), 
        .r_finished(read_finished), 
        .w_finished(write_finished), 
        .d_in(mw_aluval), 
        .re(v_mr_re), 
        .we(v_mem_we), 
        .r_addr(mr_addr), 
        .w_addr(mw_addr));

    initial
        begin
            clk = 1'b0;
            r = 1'b0;
            s = 1'b1;
            #0.1
            r = 1'b1;
            //de_v = 1'b0;
            @(posedge clk);
            //de_v = 1'b1;
        end

    initial #1000 $finish;

    initial
        begin
         //$dumpfile ("test.dump");
         //$dumpvars (0, TOP);
         $vcdplusfile("test.dump.vpd");
         $vcdpluson(0, TOP);
        end // initial begin
    
    parameter CYCLE_TIME = 20;
    always #(CYCLE_TIME/2) clk = ~clk;

endmodule
