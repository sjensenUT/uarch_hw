module TOP;

    reg[0:0] re, we;
    reg[31:0] r_addr, w_addr, d_in;
    wire[0:0] r_finished, w_finished;
    wire[31:0] d_out;



    initial
        begin
            re = 1'b0;
            we = 1'b0;
            r_addr = 32'h00000000;
            w_addr = 32'h00000000;
            d_in = 32'h00000000;

            #1
            r_addr = 32'hABCDABCD;

            #1
            re = 1'b1;
            we = 1'b1;
            #21
            r_addr = 32'hFFFFFFFF;

        end

    initial #1000 $finish;

    initial
        begin
         //$dumpfile ("test.dump");
         //$dumpvars (0, TOP);
         $vcdplusfile("test.dump.vpd");
         $vcdpluson(0, TOP);
        end // initial begin


    
    dummy_mem mem (d_out, d_in, re, we, r_addr, w_addr, r_finished, w_finished);

endmodule
