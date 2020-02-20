module regfile (in, w, we, r1, r2, out1, out2, clk);
    input wire[31:0] in;
    input wire[2:0] w, r1, r2;
    input wire[0:0] we, clk;
    output wire[31:0] out1, out2;

    regfile8x8$ regfile0 (in[7:0], r1, r2, 1'b1, 1'b1, w, we, out1[7:0], out2[7:0], clk); 
    regfile8x8$ regfile1 (in[15:8], r1, r2, 1'b1, 1'b1, w, we, out1[15:8], out2[15:8], clk);
    regfile8x8$ regfile2 (in[23:16], r1, r2, 1'b1, 1'b1, w, we, out1[23:16], out2[23:16], clk); 
    regfile8x8$ regfile3 (in[31:24], r1, r2, 1'b1, 1'b1, w, we, out1[31:24], out2[31:24], clk);  
endmodule


