module dummy_mem (d_out, r_finished, w_finished, d_in, re, we, r_addr, w_addr);
    input wire[0:0] re, we;
    input wire[31:0] r_addr, w_addr, d_in;
    output reg[31:0] d_out;
    output reg[0:0] r_finished, w_finished;
    
    initial
    begin
        r_finished = 1'b1;
        w_finished = 1'b1;
        d_out = 32'h00000000;
    end 

    always @(r_addr, re)
    begin
        if(re == 1)
        begin
            r_finished = 0;
            #15
            d_out = 32'hDEADBEEF;
            r_finished = 1;
        end
    end

    always @(w_addr, we)
    begin
        if(we == 1)
        begin
            w_finished = 0;
            #15
            w_finished = 1;
        end
    end
   
endmodule
