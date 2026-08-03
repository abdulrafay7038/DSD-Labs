module FSM_tb ();
    logic clk;
    logic rst;
    logic left;
    logic right;
    logic LA;
    logic LB;
    logic LC;
    logic RA;
    logic RB;
    logic RC;

    FSM UUT(
        .clk(clk),
        .rst(rst),
        .left(left),
        .right(right),
        .LA(LA),
        .LB(LB),
        .LC(LC),
        .RA(RA),
        .RB(RB),
        .RC(RC)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 1;
        left  = 0;
        right = 0;
        rst   = 1;
        #10;

        rst   = 0;
        left  = 1;
        right = 0;
        #10;
        left = 0;
        #40

        left = 0;
        right = 0;
        #10;

        left  = 0;
        right = 1;
        #10;
        right = 0;
        #40

        left = 0;
        right = 0;
        #10;

        left  = 1;
        right = 1;
        #10;
        left = 0;
        right = 0;
    
    end

endmodule