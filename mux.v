module mux4_2 (out, a, b, c, d, sel);
    input wire[1:0] a, b, c, d, sel;
    output wire[1:0] out;

    generate
        genvar i;
        for(i = 0; i < 2; i = i + 1) begin : muxes
            mux4$ mux(out[i], a[i], b[i], c[i], d[i], sel[0], sel[1]);
        end
    endgenerate

endmodule

module mux4_32 (out, a, b, c, d, sel);
    input wire[31:0] a, b, c, d;
    input wire[1:0] sel;
    output wire[31:0] out;

    generate
        genvar i;
        for(i = 0; i < 32; i = i + 1) begin : muxes
            mux4$ mux(out[i], a[i], b[i], c[i], d[i], sel[0], sel[1]);
        end
    endgenerate

endmodule


module mux2_4 (out, a, b, sel);
    input wire[3:0] a, b;
    input wire[0:0] sel;
    output wire[3:0] out;

    generate
        genvar i;
        for(i = 0; i < 4; i = i + 1) begin : muxes
            mux2$ mux(out[i], a[i], b[i], sel);
        end
    endgenerate

endmodule

module mux2_3 (out, a, b, sel);
    input wire[2:0] a, b;
    input wire[0:0] sel;
    output wire[2:0] out;

    generate
        genvar i;
        for(i = 0; i < 3; i = i + 1) begin : muxes
            mux2$ mux(out[i], a[i], b[i], sel);
        end
    endgenerate

endmodule

module mux2_32 (out, a, b, sel);
    input wire[31:0] a, b;
    input wire[0:0] sel;
    output wire[31:0] out;

    generate
        genvar i;
        for(i = 0; i < 32; i = i + 1) begin : muxes
            mux2$ mux(out[i], a[i], b[i], sel);
        end
    endgenerate

endmodule

module mux2_16 (out, a, b, sel);
    input wire[15:0] a, b;
    input wire[0:0] sel;
    output wire[15:0] out;

    generate
        genvar i;
        for(i = 0; i < 16; i = i + 1) begin : muxes
            mux2$ mux(out[i], a[i], b[i], sel);
        end
    endgenerate

endmodule
