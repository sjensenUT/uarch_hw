module reg_dep_logic (reg_dep, ro_needed, rm_needed, modrm, v, v_ag_we, v_mr_we, v_ex_we, v_mw_we, ag_rmsel, mr_rmsel, ex_rmsel, mw_rmsel, ag_modrm, mr_modrm, ex_modrm, mw_modrm);
    input wire[0:0] ro_needed, rm_needed, v, v_ag_we, v_mr_we, v_ex_we, v_mw_we, ag_rmsel, mr_rmsel, ex_rmsel, mw_rmsel;
    input wire[7:0] modrm, ag_modrm, mr_modrm, ex_modrm, mw_modrm;
    output wire[0:0] reg_dep;

    wire [2:0] ag_reg, mr_reg, ex_reg, mw_reg, ro, rm;
    wire [0:0] v_ag_ldreg, v_mr_ldreg, v_ex_ldreg, v_mw_ldreg, rm_isreg, ro_dep, rm_dep;
 
    assign ag_reg = ag_rmsel == 0 ? ag_modrm[5:3] : ag_modrm[2:0];
    assign mr_reg = mr_rmsel == 0 ? mr_modrm[5:3] : mr_modrm[2:0];
    assign ex_reg = ex_rmsel == 0 ? ex_modrm[5:3] : ex_modrm[2:0];
    assign mw_reg = mw_rmsel == 0 ? mw_modrm[5:3] : mw_modrm[2:0];

    assign v_ag_ldreg = v_ag_we == 1 ? (ag_rmsel == 1 ? (ag_modrm[6] & ag_modrm[7]) : 1) : 0;
    assign v_mr_ldreg = v_mr_we == 1 ? (mr_rmsel == 1 ? (mr_modrm[6] & mr_modrm[7]) : 1) : 0;
    assign v_ex_ldreg = v_ex_we == 1 ? (ex_rmsel == 1 ? (ex_modrm[6] & ex_modrm[7]) : 1) : 0;
    assign v_mw_ldreg = v_mw_we == 1 ? (mw_rmsel == 1 ? (mw_modrm[6] & mw_modrm[7]) : 1) : 0;

    assign ro = modrm[5:3];
    assign rm = modrm[2:0];

    assign rm_isreg = !modrm[6] & !modrm[7] & rm[2] & !rm[1] & !rm[0];
    
    assign ro_dep = v & (((ro == ag_reg) & v_ag_ldreg) || ((ro == mr_reg) & v_mr_ldreg) || ((ro == ex_reg) & v_ex_ldreg) || ((ro == mw_reg) & v_mw_ldreg));   
    assign rm_dep = v & rm_isreg & (((rm == ag_reg) & v_ag_ldreg) || ((rm == mr_reg) & v_mr_ldreg) || ((rm == ex_reg) & v_ex_ldreg) || ((rm == mw_reg) & v_mw_ldreg));
    
    assign reg_dep = ro_dep | rm_dep;


endmodule

