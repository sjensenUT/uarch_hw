module mem_dep_logic (mem_dep, re, v, addr, v_mr_we, v_ex_we, v_mw_we, mr_rmsel, ex_rmsel, mw_rmsel, mr_modrm, ex_modrm, mw_modrm, mr_addr, ex_addr, mw_addr);
    input wire[0:0] re, v, v_mr_we, v_ex_we, v_mw_we, mr_rmsel, ex_rmsel, mw_rmsel;
    input wire[31:0] addr, mr_addr, ex_addr, mw_addr;
    input wire[7:0] mr_modrm, ex_modrm, mw_modrm;
    output wire[0:0] mem_dep;

    wire [0:0] v_mr_wmem, v_ex_wmem, v_mw_wmem;
    
    assign v_mr_wmem = v_mr_we & mr_rmsel & !(mr_modrm[6] & mr_modrm[7]);
    assign v_ex_wmem = v_ex_we & ex_rmsel & !(ex_modrm[6] & ex_modrm[7]);
    assign v_mw_wmem = v_mw_we & mw_rmsel & !(mw_modrm[6] & mw_modrm[7]);
  
    assign mem_dep = v & re & (((addr == mr_addr) & v_mr_wmem) || ((addr == ex_addr) & v_ex_wmem) || ((addr == mw_addr) & v_mw_wmem));

endmodule

