module TOP;
    //AG
    reg[31:0] dval, sval, disp, eip, cc, ccw;
    reg[15:0] sreg;
    reg[0:0] clk, we, re, ag_e, v;
    reg[1:0] addrsel, alusel;
    reg[7:0] modrm;
    wire[0:0] ag_re, ag_reb, ag_we, ag_web, ag_v, ag_vb;
    wire[1:0] ag_addrsel, ag_addrselb, ag_alusel, ag_aluselb;
    wire[31:0] ag_dval, ag_dvalb, ag_sval, ag_svalb, ag_disp, ag_dispb, mr_addrin, ag_eip, ag_eipb, ag_cc, ag_ccb, ag_ccw, ag_ccwb;
    wire[15:0] ag_sreg, ag_sregb;
    wire[7:0] ag_modrm, ag_modrmb;
    
    //MR
    wire[0:0] mr_re, mr_reb, mr_we, mr_web, mr_v, mr_vb, read_finished, write_finished, re_temp;
    wire[31:0] mr_addr, mr_addrb, mr_dval, mr_dvalb, mr_sval, mr_svalb, mem_val, ex_dvalin, ex_svalin, mr_cc, mr_ccb, mr_ccw, mr_ccwb;
    wire[7:0] mr_modrm, mr_modrmb;
    wire[1:0] mr_addrsel, mr_addrselb, mr_alusel, mr_aluselb;
    
    //EX
    wire[0:0] ex_we, ex_web, ex_v, ex_vb, mw_cfin, mw_afin;
    wire[31:0] ex_addr, ex_addrb, ex_dval, ex_dvalb, ex_sval, ex_svalb, ex_cc, ex_ccb, ex_ccw, ex_ccwb, mw_aluvalin;
    wire[7:0] ex_modrm, ex_modrmb;
    wire[1:0] ex_alusel, ex_aluselb;
    


    initial
        begin
            clk = 1'b0;
            dval = 32'h0000ABCD;
            sval = 32'h00000001;
            disp = 32'h00000002;
            eip = 32'h00000003;
            cc = 32'h00000000;
            ccw = 32'h00000000;
            sreg = 16'h0DEF;
            addrsel = 2'b00;
            alusel = 2'b00;
            we = 1'b1;
            re = 1'b1;
            ag_e = 1'b1;
            modrm = 8'b10000000;
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
    
    parameter CYCLE_TIME = 30;
    always #(CYCLE_TIME/2) clk = ~clk;
    
    
    //AG
    dffe agre_dff(.clk(clk), .d(re), .q(ag_re), .r(1'b1), .s(1'b1), .qb(), .e(ag_e)),
         agwe_dff(.clk(clk), .d(we), .q(ag_we), .r(1'b1), .s(1'b1), .qb(), .e(ag_e)),
         agv_dff(.clk(clk), .d(v), .q(ag_v), .qb(), .r(1'b1), .s(1'b1), .e(ag_e));
    dffe32 agdval_dff(.clk(clk), .d(dval), .q(ag_dval), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)),
           agsval_dff(.clk(clk), .d(sval), .q(ag_sval), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)),
           agdisp_dff(.clk(clk), .d(disp), .q(ag_disp), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)),
           ageip_dff(.clk(clk), .d(eip), .q(ag_eip), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)),
           agcc_dff(.clk(clk), .d(cc), .q(ag_cc), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)),
           agccw_dff(.clk(clk), .d(ccw), .q(ag_ccw), .qb(), .r(1'b1), .s(1'b1), .e(ag_e));
    dffe16 agsreg_dff(.clk(clk), .d(sreg), .q(ag_sreg), .qb(), .r(1'b1), .s(1'b1), .e(ag_e));
    dffe8 agmodrm_dff(.clk(clk), .d(modrm), .q(ag_modrm), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)); 
    dffe2 agaddrsel_dff(.clk(clk), .d(addrsel), .q(ag_addrsel), .qb(), .r(1'b1), .s(1'b1), .e(ag_e)),
          agalusel_dff(.clk(clk), .d(alusel), .q(ag_alusel), .qb(), .r(1'b1), .s(1'b1), .e(ag_e));
    
    addr_generator ag (mr_addrin, ag_dval, ag_sval, ag_disp, npc, ag_memsel, modrm, ag_sreg);

    //MR
    dffe mrre_dff(clk, ag_re, mr_re, mr_reb, 1'b1, 1'b1, 1'b1),
         mrwe_dff(clk, ag_we, mr_we, mr_web, 1'b1, 1'b1, 1'b1),
         mrv_dff(clk, ag_v, mr_v, mr_vb, 1'b1, 1'b1, 1'b1);
    dffe32 mraddr_dff(clk, mr_addrin, mr_addr, mr_addrb, 1'b1, 1'b1, 1'b1),
           mrdval_dff(clk, ag_dval, mr_dval, mr_dvalb, 1'b1, 1'b1, 1'b1),
           mrsval_dff(clk, ag_sval, mr_sval, mr_svalb, 1'b1, 1'b1, 1'b1),
           mrcc_dff(clk, ag_cc, mr_cc, mr_ccb, 1'b1, 1'b1, 1'b1),
           mrccw_dff(clk, ag_ccw, mr_ccw, mr_ccwb, 1'b1, 1'b1, 1'b1);

    dffe8  mr_modrmdff(clk, ag_modrm, mr_modrm, mr_modrmb, 1'b1, 1'b1, 1'b1);
    dffe2 mraddrsel_dff(clk, ag_addrsel, mr_addrsel, mr_addrselb, 1'b1, 1'b1, 1'b1),
          mralusel_dff(clk, ag_alusel, mr_alusel, mr_aluselb, 1'b1, 1'b1, 1'b1);
    
    and2$ re_and(re_temp, re, mr_v); 
    dummy_mem mem (mem_val, read_finished, write_finished, 32'h0, re_temp, 1'b0, mr_addr, 32'h0);
    mr_logic mr(ex_vin, ex_dvalin, ex_svalin, mr_memsel, mr_re, read_finished, mr_dval, mr_sval, mem_val, mr_v);
     
    //EX
    dffe exwe_dff(clk, mr_we, ex_we, ex_web, 1'b1, 1'b1, 1'b1),
         exv_dff(clk, ex_vin, ex_v, ex_vb, 1'b1, 1'b1, 1'b1);
        
    dffe32 exaddr_dff(clk, mr_addr, ex_addr, ex_addrb, 1'b1, 1'b1, 1'b1),
           exdval_dff(clk, ex_dvalin, ex_dval, ex_dvalb, 1'b1, 1'b1, 1'b1),
           exsval_dff(clk, ex_svalin, ex_sval, ex_svalb, 1'b1, 1'b1, 1'b1),
           excc_dff(clk, mr_cc, ex_cc, ex_ccb, 1'b1, 1'b1, 1'b1),
           exccw_dff(clk, mr_ccw, ex_ccw, ex_ccwb, 1'b1, 1'b1, 1'b1);
    dffe8 exmodrm_dff(clk, mr_modrm, ex_modrm, ex_modrmb, 1'b1, 1'b1, 1'b1);
    dffe2 exalusel_dff(clk, mr_alusel, ex_alusel, ex_aluselb, 1'b1, 1'b1, 1'b1);
    
    ALU alu(mw_aluvalin, ex_dval, ex_sval, ex_alusel, mw_cfin, mw_afin);

    //MW
     



endmodule
