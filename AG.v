module addr_generator (addr, d, s, disp, sel, modrm, sreg);
    input wire[31:0] d, s, disp;
    input wire[0:0] sel;
    input wire[15:0] sreg;
    input wire[7:0] modrm;
    output wire[31:0] addr;
    
    wire[31:0] regval, dispval, couts, reg_disp;
    wire[0:0] usedisp;
    wire[15:0] couts2;   
    
    or2$ or1(usedisp, modrm[7], modrm[6]);
    mux2_32 mux1(regval, s, d, sel);
    mux2_32 mux2(reg_disp, regval, dispval, usedisp);
    adder32 adder1(dispval, couts, regval, disp);
    adder16 adder2(addr[31:16], couts2, reg_disp[31:16], sreg);
    assign addr[15:0] = reg_disp[15:0]; 
    

endmodule

