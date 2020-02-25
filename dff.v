module dff16 (clk, d, q, qb, r, s);
    input wire[0:0] clk, r, s;
    input wire[15:0] d;
    output wire[15:0] q, qb;

    generate
        genvar i;
        for(i = 0; i < 16; i = i + 1) begin : dffs
            dff$ dff(clk, d[i], q[i], qb[i], r, s);
        end
    endgenerate

endmodule

module dff32 (clk, d, q, qb, r, s);
    input wire[0:0] clk, r, s;
    input wire[31:0] d;
    output wire[31:0] q, qb;

    generate
        genvar i;
        for(i = 0; i < 32; i = i + 1) begin : dffs
            dff$ dff(clk, d[i], q[i], qb[i], r, s);
        end
    endgenerate

endmodule

module dffe (clk, d, q, qb, r, s, e);
    input wire[0:0] clk, r, s, e, d;
    output wire[0:0] q, qb;
    
    wire[0:0] dffin;
    
    mux2$ mux(dffin, q, d, e);
    dff$ dff(clk, dffin, q, qb, r, s);

endmodule

module dffe32 (clk, d, q, qb, r, s, e);
    input wire[0:0] clk, r, s, e;
    input wire[31:0] d;
    output wire[31:0] q, qb;

    generate
        genvar i;
        for(i = 0; i < 32; i = i + 1) begin : dffes
            dffe dffe(clk, d[i], q[i], qb[i], r, s, e);
        end
    endgenerate

endmodule

module dffe128 (clk, d, q, qb, r, s, e);
    input wire[0:0] clk, r, s, e;
    input wire[127:0] d;
    output wire[127:0] q, qb;

    generate
        genvar i;
        for(i = 0; i < 128; i = i + 1) begin : dffes
            dffe dffe(clk, d[i], q[i], qb[i], r, s, e);
        end
    endgenerate

endmodule

module dffe16 (clk, d, q, qb, r, s, e);
    input wire[0:0] clk, r, s, e;
    input wire[15:0] d;
    output wire[15:0] q, qb;

    generate
        genvar i;
        for(i = 0; i < 16; i = i + 1) begin : dffes
            dffe dffe(clk, d[i], q[i], qb[i], r, s, e);
        end
    endgenerate

endmodule

module dffe8 (clk, d, q, qb, r, s, e);
    input wire[0:0] clk, r, s, e;
    input wire[7:0] d;
    output wire[7:0] q, qb;

    generate
        genvar i;
        for(i = 0; i < 8; i = i + 1) begin : dffes
            dffe dffe(clk, d[i], q[i], qb[i], r, s, e);
        end
    endgenerate

endmodule

module dffe2 (clk, d, q, qb, r, s, e);
    input wire[0:0] clk, r, s, e;
    input wire[1:0] d;
    output wire[1:0] q, qb;

    generate
        genvar i;
        for(i = 0; i < 2; i = i + 1) begin : dffes
            dffe dffe(clk, d[i], q[i], qb[i], r, s, e);
        end
    endgenerate

endmodule

module dffe3 (clk, d, q, qb, r, s, e);
    input wire[0:0] clk, r, s, e;
    input wire[2:0] d;
    output wire[2:0] q, qb;

    generate
        genvar i;
        for(i = 0; i < 3; i = i + 1) begin : dffes
            dffe dffe(clk, d[i], q[i], qb[i], r, s, e);
        end
    endgenerate

endmodule

module dffev32 (clk, d, q, qb, r, s, e);
    input wire[0:0] clk, r, s;
    input wire[31:0] d, e;
    output wire[31:0] q, qb;

    generate
        genvar i;
        for(i = 0; i < 32; i = i + 1) begin : dffes
            dffe dffe(clk, d[i], q[i], qb[i], r, s, e[i]);
        end
    endgenerate

endmodule

