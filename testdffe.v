module TOP;

    reg[0:0] in, clk, e;
    wire[0:0] q, q_bar;




    initial
        begin

            clk = 0;
            in = 1;
            e = 1;

        end

    initial #1000 $finish;

    initial
        begin
         //$dumpfile ("test.dump");
         //$dumpvars (0, TOP);
         $vcdplusfile("test.dump.vpd");
         $vcdpluson(0, TOP);
        end // initial begin

    always #(5) clk = ~clk;
    dffe dffe(clk, in, q, q_bar, 1'b1, 1'b1, e);

endmodule
