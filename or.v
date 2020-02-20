module or2_32 (out, a, b);
    input wire[31:0] a, b;
    output wire[31:0] out;

    generate
        genvar i;
        for(i = 0; i < 32; i = i + 1) begin : ors
            or2$ or1(out[i], a[i], b[i]);
        end
    endgenerate
endmodule

module nor8_1(out, in);
    input wire[7:0] in;
    input wire[0:0] out;
    wire[0:0] temp1, temp2;
    nor4$ nor1(temp1, in[7], in[6], in[5], in[4]),
          nor2(temp2, in[3], in[2], in[1], in[0]);
    and2$ and2(out, temp1, temp2);
endmodule

module nor16_1(out, in);
    input wire[15:0] in;
    input wire[0:0] out;
    wire[0:0] temp1, temp2;
    nor8_1 nor1(temp1, in[15:8]),
          nor2(temp2, in[7:0]);
    and2$ and2(out, temp1, temp2);
endmodule

module nor32_1(out, in);
    input wire[31:0] in;
    input wire[0:0] out;
    wire[0:0] temp1, temp2;
    nor16_1 nor1(temp1, in[31:16]),
          nor2(temp2, in[15:0]);
    and2$ and2(out, temp1, temp2);
endmodule

