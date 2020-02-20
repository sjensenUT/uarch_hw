module xor2_32 (out, a, b);
    input wire[31:0] a, b;
    output wire[31:0] out;

    generate
        genvar i;
        for(i = 0; i < 32; i = i + 1) begin : xors
            xor2$ xori(out[i], a[i], b[i]);
        end
    endgenerate
endmodule

module xnor4_1(out, in);
    input wire[3:0] in;
    output wire[0:0] out;
    wire[0:0] temp1, temp2;
    xnor2$ xnor1(temp1, in[3], in[2]),
           xnor2(temp2, in[1], in[0]),
           xnor3(out, temp1, temp2);
endmodule

module xnor8_1(out, in);
    input wire[7:0] in;
    input wire[0:0] out;
    wire[0:0] temp1, temp2;
    xnor4_1 xnor1(temp1, in[7:4]),
            xnor2(temp2, in[3:0]);
    xnor2$  xnor3(out, temp1, temp2);
endmodule
    

/*module xnor8_1(out, in);
    input wire[7:0] in;
    output wire[0:0] out;
    
    wire[3:0] lv2;
    wire[1:0] lv1;

    generate
        genvar i;
        for(i = 0; i < 4; i = i + 1) begin : xnorlv2s
            xnor2$ xorlv2(lv2[i], in[2*i], in[2*i + 1]);
        end

endmodule*/
