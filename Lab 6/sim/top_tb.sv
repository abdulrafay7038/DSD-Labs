module top_tb();
    logic CLK;
    logic rst;
    logic tgr1,tgr2;
    logic [6:0]seg;
    logic [7:0]an;
    logic [3:0]out;

    top UUT(
        .CLK(CLK),
        .rst(rst),
        .tgr1(tgr1),
        .tgr2(tgr2),
        .seg(seg),
        .an(an),
        .out(out)
    );

    initial CLK = 1;
    always begin
        #5 CLK = ~CLK;
    end

    initial begin
        rst = 1;
        tgr1 = 0; tgr2 = 0;
        #10; 
        rst = 0;         // release resest
        #100000;
    end

endmodule