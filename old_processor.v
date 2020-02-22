module TOP;
    
    //AG    
    reg[31:0] dval, sval, disp, flags, flagw;
    reg[15:0] sreg, ptr;
    reg[0:0] clk, we, re, ld_ag, v, rmsel, eipw, csw;
    reg[1:0] alusel;
    reg[7:0] modrm;
    wire[0:0] ag_re, ag_we, ag_v, ag_rmsel, ag_eipw, ag_csw, ld_mr;
    wire[1:0] ag_alusel;
    wire[31:0] ag_dval, ag_sval, ag_disp, mr_addrin, ag_flags, ag_flagw;
    wire[15:0] ag_sreg, ag_ptr;
    wire[7:0] ag_modrm;

    dffe agrmsel_dff(.clk(clk), .d(rmsel), .q(ag_rmsel), .qb(), .r(1'b1), .s(1'b1), .e(ld_ag)),
         agre_dff(.clk(clk), .d(re), .q(ag_re), .r(1'b1), .s(1'b1), .qb(), .e(ld_ag)),
         agwe_dff(.clk(clk), .d(we), .q(ag_we), .r(1'b1), .s(1'b1), .qb(), .e(ld_ag)),
         agv_dff(.clk(clk), .d(v), .q(ag_v), .qb(), .r(1'b1), .s(1'b1), .e(ld_ag)),
         ageipw_dff(.clk(clk), .d(eipw), .q(ag_eipw), .qb(), .r(1'b1), .s(1'b1), .e(ld_ag)),
         agcsw_dff(.clk(clk), .d(csw), .q(ag_csw), .qb(), .r(1'b1), .s(1'b1), .e(ld_ag));
    dffe32 agdval_dff(.clk(clk), .d(dval), .q(ag_dval), .qb(), .r(1'b1), .s(1'b1), .e(ld_ag)),
           agsval_dff(.clk(clk), .d(sval), .q(ag_sval), .qb(), .r(1'b1), .s(1'b1), .e(ld_ag)),
           agdisp_dff(.clk(clk), .d(disp), .q(ag_disp), .qb(), .r(1'b1), .s(1'b1), .e(ld_ag)),
           agflags_dff(.clk(clk), .d(flags), .q(ag_flags), .qb(), .r(1'b1), .s(1'b1), .e(ld_ag)),
           agflagw_dff(.clk(clk), .d(flagw), .q(ag_flagw), .qb(), .r(1'b1), .s(1'b1), .e(ld_ag));
    dffe16 agsreg_dff(.clk(clk), .d(sreg), .q(ag_sreg), .qb(), .r(1'b1), .s(1'b1), .e(ld_ag)),
           agptr_dff(.clk(clk), .d(ptr), .q(ag_ptr), .qb(), .r(1'b1), .s(1'b1), .e(ld_ag));
    dffe8 agmodrm_dff(.clk(clk), .d(modrm), .q(ag_modrm), .qb(), .r(1'b1), .s(1'b1), .e(ld_ag)); 
    dffe2 agalusel_dff(.clk(clk), .d(alusel), .q(ag_alusel), .qb(), .r(1'b1), .s(1'b1), .e(ld_ag));
    
    addr_generator ag (mr_addrin, ag_dval, ag_sval, ag_disp, ag_rmsel, ag_modrm, ag_sreg);
    assign ld_mr = 1'b1;
    //MR
    wire[0:0] mr_re, mr_we, mr_v, mr_rmsel, mr_eipw, mr_csw, read_finished, write_finished, re_temp, ex_vin, mr_reb, mre, ld_ex;
    wire[31:0] mr_addr, mr_dval, mr_sval, mem_val, ex_dvalin, ex_svalin, mr_flags, mr_flagw;
    wire[15:0] mr_ptr;
    wire[7:0] mr_modrm;
    wire[1:0] mr_alusel;
 
    dffe mrrmsel_dff(.clk(clk), .d(ag_rmsel), .q(mr_rmsel), .qb(), .r(1'b1), .s(1'b1), .e(ld_mr)),
         mrre_dff(.clk(clk), .d(ag_re), .q(mr_re), .qb(mr_reb), .r(1'b1), .s(1'b1), .e(ld_mr)),
         mrwe_dff(.clk(clk), .d(ag_we), .q(mr_we), .qb(), .r(1'b1), .s(1'b1), .e(ld_mr)),
         mrv_dff(.clk(clk), .d(ag_v), .q(mr_v), .qb(), .r(1'b1), .s(1'b1), .e(ld_mr)),
         mreipw_dff(.clk(clk), .d(ag_eipw), .q(mr_eipw), .qb(), .r(1'b1), .s(1'b1), .e(ld_mr)),
         mrcsw_dff(.clk(clk), .d(ag_csw), .q(mr_csw), .qb(), .r(1'b1), .s(1'b1), .e(ld_mr));
    dffe32 mraddr_dff(.clk(clk), .d(mr_addrin), .q(mr_addr), .qb(), .r(1'b1), .s(1'b1), .e(ld_mr)),
           mrdval_dff(.clk(clk), .d(ag_dval), .q(mr_dval), .qb(), .r(1'b1), .s(1'b1), .e(ld_mr)),
           mrsval_dff(.clk(clk), .d(ag_sval), .q(mr_sval), .qb(), .r(1'b1), .s(1'b1), .e(ld_mr)),
           mrflags_dff(.clk(clk), .d(ag_flags), .q(mr_flags), .qb(), .r(1'b1), .s(1'b1), .e(ld_mr)),
           mrflagw_dff(.clk(clk), .d(ag_flagw), .q(mr_flagw), .qb(), .r(1'b1), .s(1'b1), .e(ld_mr));
    dffe16 mrptr_dff(.clk(clk), .d(ag_ptr), .q(mr_ptr), .qb(), .r(1'b1), .s(1'b1), .e(ld_mr));
    dffe8  mr_modrmdff(.clk(clk), .d(ag_modrm), .q(mr_modrm), .qb(), .r(1'b1), .s(1'b1), .e(ld_mr));
    dffe2  mralusel_dff(.clk(clk), .d(ag_alusel), .q(mr_alusel), .qb(), .r(1'b1), .s(1'b1), .e(ld_mr));
    
    mr_logic mr(ex_vin, ex_dvalin, ex_svalin, mre, mr_rmsel, mr_re, read_finished, mr_dval, mr_sval, mem_val, mr_v);
    assign ld_ex = 1'b1;
    //EX
    wire[0:0] ex_we, ex_v, ex_rmsel, ex_eipw, ex_csw, mw_cfin, mw_afin, mw_ofin, ld_mw;
    wire[31:0] ex_addr, ex_dval, ex_sval, ex_flags, ex_flagw, mw_aluvalin;
    wire[15:0] ex_ptr;
    wire[7:0] ex_modrm;
    wire[1:0] ex_alusel;

    dffe exrmsel_dff(.clk(clk), .d(mr_rmsel), .q(ex_rmsel), .qb(), .r(1'b1), .s(1'b1), .e(ld_ex)),
         exwe_dff(.clk(clk), .d(mr_we), .q(ex_we), .qb(), .r(1'b1), .s(1'b1), .e(ld_ex)),
         exv_dff(.clk(clk), .d(ex_vin), .q(ex_v), .qb(), .r(1'b1), .s(1'b1), .e(ld_ex)),
         exeipw_dff(.clk(clk), .d(mr_eipw), .q(ex_eipw), .qb(), .r(1'b1), .s(1'b1), .e(ld_ex)),
         excsw_dff(.clk(clk), .d(mr_csw), .q(ex_csw), .qb(), .r(1'b1), .s(1'b1), .e(ld_ex));
    dffe32 exaddr_dff(.clk(clk), .d(mr_addr), .q(ex_addr), .qb(), .r(1'b1), .s(1'b1), .e(ld_ex)),
           exdval_dff(.clk(clk), .d(ex_dvalin), .q(ex_dval), .qb(), .r(1'b1), .s(1'b1), .e(ld_ex)),
           exsval_dff(.clk(clk), .d(ex_svalin), .q(ex_sval), .qb(), .r(1'b1), .s(1'b1), .e(ld_ex)),
           exflags_dff(.clk(clk), .d(mr_flags), .q(ex_flags), .qb(), .r(1'b1), .s(1'b1), .e(ld_ex)),
           exflagw_dff(.clk(clk), .d(mr_flagw), .q(ex_flagw), .qb(), .r(1'b1), .s(1'b1), .e(ld_ex));
    dffe16 exptr_dff(.clk(clk), .d(mr_ptr), .q(ex_ptr), .qb(), .r(1'b1), .s(1'b1), .e(ld_ex));
    dffe8 exmodrm_dff(.clk(clk), .d(mr_modrm), .q(ex_modrm), .qb(), .r(1'b1), .s(1'b1), .e(ld_ex));
    dffe2 exalusel_dff(.clk(clk), .d(mr_alusel), .q(ex_alusel), .qb(), .r(1'b1), .s(1'b1), .e(ld_ex));
    
    ALU alu(mw_aluvalin, ex_dval, ex_sval, ex_alusel, mw_cfin, mw_afin, mw_ofin);
    assign ld_mw = 1'b1; 
    //MW
    wire[0:0] mw_we, mw_cf, mw_af, mw_of, mw_v, mw_eipw, mw_csw, mw_rmsel, rfwe, mwe, eipwe, cswe;
    wire[31:0] mw_aluval, mw_flags, mw_flagw, mw_addr, flags_temp, flagwe;
    wire[15:0] mw_ptr;
    wire[7:0] mw_modrm;
    wire[2:0] wreg;
    
    dffe mwrmsel_dff(.clk(clk), .d(ex_rmsel), .q(mw_rmsel), .qb(), .r(1'b1), .s(1'b1), .e(ld_mw)),
         mwwe_dff(.clk(clk), .d(ex_we), .q(mw_we), .qb(), .r(1'b1), .s(1'b1), .e(ld_mw)),
         mwv_dff(.clk(clk), .d(ex_v), .q(mw_v), .qb(), .r(1'b1), .s(1'b1), .e(ld_mw)),
         mweipw_dff(.clk(clk), .d(ex_eipw), .q(mw_eipw), .qb(), .r(1'b1), .s(1'b1), .e(ld_mw)),
         mwcsw_dff(.clk(clk), .d(ex_csw), .q(mw_csw), .qb(), .r(1'b1), .s(1'b1), .e(ld_mw)),
         mwaf_dff(.clk(clk), .d(mw_afin), .q(mw_af), .qb(), .r(1'b1), .s(1'b1), .e(ld_mw)),
         mwcf_dff(.clk(clk), .d(mw_cfin), .q(mw_cf), .qb(), .r(1'b1), .s(1'b1), .e(ld_mw)),
         mwof_dff(.clk(clk), .d(mw_ofin), .q(mw_of), .qb(), .r(1'b1), .s(1'b1), .e(ld_mw));
    dffe32 mwaddr_dff(.clk(clk), .d(ex_addr), .q(mw_addr), .qb(), .r(1'b1), .s(1'b1), .e(ld_mw)),
           mwaluval_dff(.clk(clk), .d(mw_aluvalin), .q(mw_aluval), .qb(), .r(1'b1), .s(1'b1), .e(ld_mw)),
           mwflags_dff(.clk(clk), .d(ex_flags), .q(mw_flags), .qb(), .r(1'b1), .s(1'b1), .e(ld_mw)),
           mwflagw_dff(.clk(clk), .d(ex_flagw), .q(mw_flagw), .qb(), .r(1'b1), .s(1'b1), .e(ld_mw));
    dffe16 mwptr_dff(.clk(clk), .d(ex_ptr), .q(mw_ptr), .qb(), .r(1'b1), .s(1'b1), .e(ld_mw));
    dffe8 mwmodrm_dff(.clk(clk), .d(ex_modrm), .q(mw_modrm), .qb(), .r(1'b1), .s(1'b1), .e(ld_mw));
    
    mw_logic (.mwe(mwe), .rfwe(rfwe), .flagwe(flagwe), .eipwe(eipwe), .cswe(cswe),
        .drid(wreg), .flags(flags_temp), .af(mw_af), .cf(mw_cf), .of(mw_of), .aluval(mw_aluval),
        .modrm(mw_modrm), .rmsel(mw_rmsel), .we(mw_we), .flagw(mw_flagw), .eipw(mw_eipw), .csw(mw_csw), .v(mw_v));
    

    wire[31:0] eflags, eip;
    wire[15:0] cs;
    dffev32 eflags_dff(.clk(clk), .d(flags_temp), .q(eflags), .qb(), .r(1'b1), .s(1'b1), .e(flagwe));
    dffe32 eip_dff(.clk(clk), .d(mw_aluval), .q(eip), .qb(), .r(1'b1), .s(1'b1), .e(eipwe));
    dffe16 cs_dff(.clk(clk), .d(mw_ptr), .q(cs), .qb(), .r(1'b1), .s(1'b1), .e(cswe));
    regfile rf(.in(mw_aluval), .w(wreg), .we(rfwe), .r1(3'b000), .r2(3'b000), .out1(), .out2(), .clk(clk));
    
    dummy_mem mem (.d_out(mem_val), 
        .r_finished(read_finished), 
        .w_finished(write_finished), 
        .d_in(mw_aluval), 
        .re(mre), 
        .we(mwe), 
        .r_addr(mr_addr), 
        .w_addr(mw_addr));

    initial
        begin
            clk = 1'b0;
            ptr = 32'h00000000;
            dval = 32'h00000002;
            sval = 32'h0000ABCD;
            disp = 32'h00000002;
            flags = 32'h00000000;
            flagw = 32'h00000000;
            sreg = 16'h0DEF;
            rmsel = 1'b0;
            alusel = 2'b11;
            we = 1'b1;
            re = 1'b1;
            ag_e = 1'b1;
            modrm = 8'b10010001;
            v = 1'b1;
            @(posedge clk);
            ag_e = 1'b0;
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
