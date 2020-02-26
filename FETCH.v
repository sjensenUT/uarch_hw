module dummy_fetch (de_vin, ld_de, f_instr, f_new_eip, f_ld_eip, eip, v_de_jmp, v_ag_jmp, v_mr_jmp, reg_dep, mem_dep, mr_stall, mw_stall);
    output wire[0:0] de_vin, ld_de, f_ld_eip;
    output wire[31:0] f_new_eip;
    output wire[127:0] f_instr;
    input wire[0:0] v_de_jmp, v_ag_jmp, v_mr_jmp, reg_dep, mem_dep, mr_stall, mw_stall;
    input wire[31:0] eip;

    assign ld_de = !(reg_dep | mem_dep | mr_stall | mw_stall);
    assign de_vin = !(v_de_jmp | v_ag_jmp | v_mr_jmp);
    assign f_ld_eip = ld_de & de_vin;
    assign f_new_eip = eip + 1;


    generate
        genvar i;
        for(i = 32; i < 128; i = i + 1) begin : bits
            assign f_instr[i] = 1'b0;
        end
    endgenerate

    assign f_instr[31:0] = eip;

endmodule
