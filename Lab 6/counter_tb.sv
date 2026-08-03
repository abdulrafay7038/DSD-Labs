module counter_tb();
    logic CLK;
    logic rst;
    logic tgr;
    logic [3:0] q;

    counter UUT(
        .CLK(CLK),
        .rst(rst),
        .tgr(tgr),
        .q(q)
    );

    initial CLK = 1;
    always begin
        #5 CLK = ~CLK;
    end

    initial begin
        rst = 0;
        tgr = 0;

        #10; 
        rst = 0;         // release reset
      #200;            // wrap counter

        rst = 1;         // reset before next mode
        #10; 
        rst = 0;

        tgr = 1;         // saturated counter
      #300;
    end

endmodule