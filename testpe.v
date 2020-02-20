module TOP;

    reg[31:0] in;
    wire[4:0] out;
    wire[0:0] v;



    initial
        begin
            in = 32'h10000000;
            #10
            in = 32'h20000000;
            #10
            in = 32'h0000FFFF;
            #10
            in = 32'h00FFFF00;
            #10
            in = 32'h000000FF;

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
    
    pe32_5 pe(out, v, in);

endmodule
