module full_adder (out, cout, a, b, cin);
    input wire[0:0] a, b, cin;
    output wire[0:0] out, cout;

    wire[0:0] xor_ab, nand_ab, nand_abcin;

    xor2$ xor1 (xor_ab, a, b),
         xor2 (out, xor_ab, cin);
    
    nand2$ nand1 (nand_ab, a, b),
           nand2 (nand_abcin, xor_ab, cin),
           nand3 (cout, nand_ab, nand_abcin);

endmodule

