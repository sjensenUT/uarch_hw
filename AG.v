module addr_generator (addr, d, s, disp, sel, modrm, sreg, re, jmp);
    input wire[31:0] d, s, disp;
    input wire[0:0] sel, re;
    input wire[15:0] sreg;
    input wire[7:0] modrm;
    input wire[2:0] jmp;
    output wire[31:0] addr;
    
    wire[31:0] regval, dispval, couts, reg_disp;
    wire[0:0] usedisp, dispmod, jnr, jmp0b, jmp1b;
    wire[15:0] couts2, sreg_temp;   
    inv1$ inv1(jmp0b, jmp[0]),
          inv2(jmp1b, jmp[1]),
          inv3(reb, re);
    and3$ and1(jnr, jmp[2], jmp1b, jmp0b); 
    and2$ and2(sreg_sel, jmp[2], reb);
    xor2$ xor1(dispmod, modrm[7], modrm[6]); 
    or2$ or1(usedisp, jnr, dispmod);
    mux2_16 mux1(sreg_temp, sreg, 16'h0000, sreg_sel);
    mux2_32 mux2(regval, s, d, sel);
    mux2_32 mux3(reg_disp, regval, dispval, usedisp);
    adder32 adder1(dispval, couts, regval, disp);
    adder16 adder2(addr[31:16], couts2, reg_disp[31:16], sreg_temp);
    assign addr[15:0] = reg_disp[15:0]; 
    

endmodule

