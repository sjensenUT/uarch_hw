module dummy_decode (de_re, de_we, ag_vin, de_rmsel, de_alusel, de_dval, de_sval, de_disp, 
    de_flags, de_flag_ld, de_sreg, de_ptr, de_modrm, de_jmp, ro_needed, rm_needed, ld_ag, 
    mem_dep, reg_dep, mr_stall, mw_stall, de_v, clk);
    input wire[0:0] reg_dep, mem_dep, mr_stall, mw_stall, de_v, clk;
    output wire[0:0] ld_ag, ag_vin;
    output reg[0:0] de_re, de_we, de_rmsel, ro_needed, rm_needed;
    output reg[1:0] de_alusel;
    output reg[2:0] de_jmp;
    output reg[7:0] de_modrm;
    output reg[15:0] de_sreg, de_ptr;
    output reg[31:0] de_dval, de_sval, de_disp, de_flags, de_flag_ld;
    
     
    reg[3:0] count;

    assign ld_ag = !(mem_dep | mr_stall | mw_stall);
    assign ag_vin = de_v & !reg_dep;

    initial 
    begin
        count = 0;
        de_re = 1'b0;
        de_we = 1'b0;
        de_rmsel = 1'b0;
        de_alusel = 2'b00;
        de_dval = 32'h00000000;
        de_sval = 32'h00000000;
        de_disp = 32'h00000000;
        de_flags = 32'h00000000;
        de_flag_ld = 32'h00000000;
        de_sreg = 16'h0000;
        de_ptr = 16'h0000;
        de_modrm = 8'b00000000;
        de_jmp = 3'b000;
        ro_needed = 1'b0;
        rm_needed = 1'b0;
    end 

    always @(posedge clk)
    begin
        if(count == 0)
        begin //ADD M[ECX] EAX
            de_re = 1'b1;
            de_we = 1'b1;
            de_rmsel = 1'b1;
            de_alusel = 2'b11;
            de_dval = 32'h00000000;
            de_sval = 32'h00000001;
            de_disp = 32'h00000001;
            de_flags = 32'h00000000;
            de_flag_ld = 32'h00000000;
            de_sreg = 16'h0001;
            de_ptr = 16'h0001;
            de_modrm = 8'b00000001;
            de_jmp = 3'b000;
            ro_needed = 1'b1;
            rm_needed = 1'b1;
        end
        else if(count == 1)
        begin   //ADD M[ECX] EAX
            de_re = 1'b1;
            de_we = 1'b1;
            de_rmsel = 1'b1;
            de_alusel = 2'b11;
            de_dval = 32'h00000000;
            de_sval = 32'h00000001;
            de_disp = 32'h00000001;
            de_flags = 32'h00000000;
            de_flag_ld = 32'h00000000;
            de_sreg = 16'h0001;
            de_ptr = 16'h0001;
            de_modrm = 8'b00000001;
            de_jmp = 3'b000;
            ro_needed = 1'b1;
            rm_needed = 1'b1; 
        end
        else
        begin
            count = 0;
            de_re = 1'b0;
            de_we = 1'b0;
            de_rmsel = 1'b0;
            de_alusel = 2'b00;
            de_dval = 32'h00000000;
            de_sval = 32'h00000000;
            de_disp = 32'h00000000;
            de_flags = 32'h00000000;
            de_flag_ld = 32'h00000000;
            de_sreg = 16'h0000;
            de_ptr = 16'h0000;
            de_modrm = 8'b00000000;
            de_jmp = 3'b000;
            ro_needed = 1'b0;
            rm_needed = 1'b0; 
        end
    
        if(ld_ag & ag_vin)
        begin
            count = count + 1;
        end

    end


 

endmodule

