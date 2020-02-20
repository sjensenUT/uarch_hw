module TOP;

    reg[2:0] w, r1, r2;
    reg[0:0] clk, we;
    reg[31:0] in;
    wire[31:0] out1, out2;



    initial
        begin
            clk = 0;
            @(posedge clk);
            w = 3'b000;
            we = 1'b1;
            in = 32'hABCDABCD;
            @(posedge clk);
            w = 3'b001;
            in = 32'hDEADBEEF;
            @(posedge clk);
            we = 1'b0;
            in = 32'h00000000;
            r1 = 3'b000;
            r2 = 3'b001;

        end

    initial #1000 $finish;

    initial
        begin
         //$dumpfile ("test.dump");
         //$dumpvars (0, TOP);
         $vcdplusfile("test.dump.vpd");
         $vcdpluson(0, TOP);
        end // initial begin

    //always @*
        //$strobe ("at time %0d, a = %b, b = %b, c = %b, d = %b, sel = %b", $time, a, b, c, d, sel);
    
    parameter CYCLE_TIME = 10;
    always #(CYCLE_TIME/2) clk = ~clk;
    
    regfile regfile (in, w, we, r1, r2, out1, out2, clk);

endmodule
