module TOP;
    
    //AG    
    reg[31:0] dval, sval, disp, cc, ccw;
    reg[15:0] sreg, ptr;
    reg[0:0] clk, we, re, ag_e, v, rmsel, eipw, csw;
    reg[1:0] alusel;
    reg[7:0] modrm;
    wire[0:0] ag_re, ag_we, ag_v, ag_rmsel, ag_eipw, ag_csw;
    wire[1:0] ag_alusel;
    wire[31:0] ag_dval, ag_sval, ag_disp, mr_addrin, ag_cc, ag_ccw;
    wire[15:0] ag_sreg, ag_ptr;
    wire[7:0] ag_modrm;

    dffe agrmsel_dff(.clk(clk), .d(rmsel), .q(ag_rmsel), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)),
         agre_dff(.clk(clk), .d(re), .q(ag_re), .r(1'b1), .s(1'b1), .qb(), .e(ag_e)),
         agwe_dff(.clk(clk), .d(we), .q(ag_we), .r(1'b1), .s(1'b1), .qb(), .e(ag_e)),
         agv_dff(.clk(clk), .d(v), .q(ag_v), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)),
         ageipw_dff(.clk(clk), .d(eipw), .q(ag_eipw), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)),
         agcsw_dff(.clk(clk), .d(csw), .q(ag_csw), .qb(), .r(1'b1), .s(1'b1), .e(ag_e));
    dffe32 agdval_dff(.clk(clk), .d(dval), .q(ag_dval), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)),
           agsval_dff(.clk(clk), .d(sval), .q(ag_sval), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)),
           agdisp_dff(.clk(clk), .d(disp), .q(ag_disp), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)),
           agcc_dff(.clk(clk), .d(cc), .q(ag_cc), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)),
           agccw_dff(.clk(clk), .d(ccw), .q(ag_ccw), .qb(), .r(1'b1), .s(1'b1), .e(ag_e));
    dffe16 agsreg_dff(.clk(clk), .d(sreg), .q(ag_sreg), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)),
           agptr_dff(.clk(clk), .d(ptr), .q(ag_ptr), .qb(), .r(1'b1), .s(1'b1), .e(ag_e));
    dffe8 agmodrm_dff(.clk(clk), .d(modrm), .q(ag_modrm), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)); 
    dffe2 agalusel_dff(.clk(clk), .d(alusel), .q(ag_alusel), .qb(), .r(1'b1), .s(1'b1), .e(ag_e));
    
    addr_generator ag (mr_addrin, ag_dval, ag_sval, ag_disp, ag_rmsel, ag_modrm, ag_sreg);

    //MR
    wire[0:0] mr_re, mr_we, mr_v, mr_rmsel, mr_eipw, mr_csw, read_finished, write_finished, re_temp, ex_vin, mr_reb, mre;
    wire[31:0] mr_addr, mr_dval, mr_sval, mem_val, ex_dvalin, ex_svalin, mr_cc, mr_ccw;
    wire[15:0] mr_ptr;
    wire[7:0] mr_modrm;
    wire[1:0] mr_alusel;
 
    dffe mrrmsel_dff(.clk(clk), .d(ag_rmsel), .q(mr_rmsel), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
         mrre_dff(.clk(clk), .d(ag_re), .q(mr_re), .qb(mr_reb), .r(1'b1), .s(1'b1), .e(1'b1)),
         mrwe_dff(.clk(clk), .d(ag_we), .q(mr_we), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
         mrv_dff(.clk(clk), .d(ag_v), .q(mr_v), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
         mreipw_dff(.clk(clk), .d(ag_eipw), .q(mr_eipw), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
         mrcsw_dff(.clk(clk), .d(ag_csw), .q(mr_csw), .qb(), .r(1'b1), .s(1'b1), .e(1'b1));
    dffe32 mraddr_dff(.clk(clk), .d(mr_addrin), .q(mr_addr), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
           mrdval_dff(.clk(clk), .d(ag_dval), .q(mr_dval), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
           mrsval_dff(.clk(clk), .d(ag_sval), .q(mr_sval), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
           mrcc_dff(.clk(clk), .d(ag_cc), .q(mr_cc), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
           mrccw_dff(.clk(clk), .d(ag_ccw), .q(mr_ccw), .qb(), .r(1'b1), .s(1'b1), .e(1'b1));
    dffe16 mrptr_dff(.clk(clk), .d(ag_ptr), .q(mr_ptr), .qb(), .r(1'b1), .s(1'b1), .e(1'b1));
    dffe8  mr_modrmdff(.clk(clk), .d(ag_modrm), .q(mr_modrm), .qb(), .r(1'b1), .s(1'b1), .e(1'b1));
    dffe2  mralusel_dff(.clk(clk), .d(ag_alusel), .q(mr_alusel), .qb(), .r(1'b1), .s(1'b1), .e(1'b1));
    
    mr_logic mr(ex_vin, ex_dvalin, ex_svalin, mre, mr_rmsel, mr_re, read_finished, mr_dval, mr_sval, mem_val, mr_v);
     
    //EX
    wire[0:0] ex_we, ex_v, ex_rmsel, ex_eipw, ex_csw, mw_cfin, mw_afin, mw_ofin;
    wire[31:0] ex_addr, ex_dval, ex_sval, ex_cc, ex_ccw, mw_aluvalin;
    wire[15:0] ex_ptr;
    wire[7:0] ex_modrm;
    wire[1:0] ex_alusel;

    dffe exrmsel_dff(.clk(clk), .d(mr_rmsel), .q(ex_rmsel), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
         exwe_dff(.clk(clk), .d(mr_we), .q(ex_we), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
         exv_dff(.clk(clk), .d(ex_vin), .q(ex_v), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
         exeipw_dff(.clk(clk), .d(mr_eipw), .q(ex_eipw), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
         excsw_dff(.clk(clk), .d(mr_csw), .q(ex_csw), .qb(), .r(1'b1), .s(1'b1), .e(1'b1));
    dffe32 exaddr_dff(.clk(clk), .d(mr_addr), .q(ex_addr), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
           exdval_dff(.clk(clk), .d(ex_dvalin), .q(ex_dval), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
           exsval_dff(.clk(clk), .d(ex_svalin), .q(ex_sval), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
           excc_dff(.clk(clk), .d(mr_cc), .q(ex_cc), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
           exccw_dff(.clk(clk), .d(mr_ccw), .q(ex_ccw), .qb(), .r(1'b1), .s(1'b1), .e(1'b1));
    dffe16 exptr_dff(.clk(clk), .d(mr_ptr), .q(ex_ptr), .qb(), .r(1'b1), .s(1'b1), .e(1'b1));
    dffe8 exmodrm_dff(.clk(clk), .d(mr_modrm), .q(ex_modrm), .qb(), .r(1'b1), .s(1'b1), .e(1'b1));
    dffe2 exalusel_dff(.clk(clk), .d(mr_alusel), .q(ex_alusel), .qb(), .r(1'b1), .s(1'b1), .e(1'b1));
    
    ALU alu(mw_aluvalin, ex_dval, ex_sval, ex_alusel, mw_cfin, mw_afin, mw_ofin);

    //MW
    wire[0:0] mw_we, mw_cf, mw_af, mw_of, mw_v, mw_eipw, mw_csw, mw_rmsel, rfwe, mwe, eipwe, cswe;
    wire[31:0] mw_aluval, mw_cc, mw_ccw, mw_addr, cc_temp, ccwe;
    wire[15:0] mw_ptr;
    wire[7:0] mw_modrm;
    wire[2:0] wreg;
    
    dffe mwrmsel_dff(.clk(clk), .d(ex_rmsel), .q(mw_rmsel), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
         mwwe_dff(.clk(clk), .d(ex_we), .q(mw_we), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
         mwv_dff(.clk(clk), .d(ex_v), .q(mw_v), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
         mweipw_dff(.clk(clk), .d(ex_eipw), .q(mw_eipw), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
         mwcsw_dff(.clk(clk), .d(ex_csw), .q(mw_csw), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
         mwaf_dff(.clk(clk), .d(mw_afin), .q(mw_af), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
         mwcf_dff(.clk(clk), .d(mw_cfin), .q(mw_cf), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
         mwof_dff(.clk(clk), .d(mw_ofin), .q(mw_of), .qb(), .r(1'b1), .s(1'b1), .e(1'b1));
    dffe32 mwaddr_dff(.clk(clk), .d(ex_addr), .q(mw_addr), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
           mwaluval_dff(.clk(clk), .d(mw_aluvalin), .q(mw_aluval), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
           mwcc_dff(.clk(clk), .d(ex_cc), .q(mw_cc), .qb(), .r(1'b1), .s(1'b1), .e(1'b1)),
           mwccw_dff(.clk(clk), .d(ex_ccw), .q(mw_ccw), .qb(), .r(1'b1), .s(1'b1), .e(1'b1));
    dffe16 mwptr_dff(.clk(clk), .d(ex_ptr), .q(mw_ptr), .qb(), .r(1'b1), .s(1'b1), .e(1'b1));
    dffe8 mwmodrm_dff(.clk(clk), .d(ex_modrm), .q(mw_modrm), .qb(), .r(1'b1), .s(1'b1), .e(1'b1));
    
    regfile rf(.in(mw_aluval), .w(wreg), .we(rfwe), .r1(3'b000), .r2(3'b000), .out1(), .out2(), .clk(clk));
    mw_logic (.mwe(mwe), .rfwe(rfwe), .ccwe(ccwe), .eipwe(eipwe), .cswe(cswe),
        .drid(wreg), .cc(cc_temp), .af(mw_af), .cf(mw_cf), .of(mw_of), .aluval(mw_aluval),
        .modrm(mw_modrm), .rmsel(mw_rmsel), .we(mw_we), .ccw(mw_ccw), .eipw(mw_eipw), .csw(mw_csw), .v(mw_v));
    

    wire[31:0] eflags, eip;
    wire[15:0] cs;
    dffev32 eflags_dff(.clk(clk), .d(cc_temp), .q(eflags), .qb(), .r(1'b1), .s(1'b1), .e(ccwe));
    dffe32 eip_dff(.clk(clk), .d(mw_aluval), .q(eip), .qb(), .r(1'b1), .s(1'b1), .e(eipwe));
    dffe16 cs_dff(.clk(clk), .d(mw_ptr), .q(cs), .qb(), .r(1'b1), .s(1'b1), .e(cswe));

    
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
            cc = 32'h00000000;
            ccw = 32'h00000000;
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
