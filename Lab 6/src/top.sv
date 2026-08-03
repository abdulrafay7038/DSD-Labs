module top#(parameter N=4)
(
    input  logic CLK,
    input  logic rst,
    input  logic tgr1,
    input  logic tgr2,
    output logic [6:0]seg,
    output logic [7:0]an,
    output logic [N-1:0]out
);
    logic clk_out;
    logic [3:0] clk_counter;
    logic [N-1:0] out1;

    // freq_divider freq_divider
    // (
    //     .clk(CLK),
    //     .reset(rst),
    //     .clk_out(clk_out)

    // );

    always_ff @(posedge CLK or posedge rst) begin

        if (rst)
            clk_counter <= 0;
        else 
            clk_counter <= clk_counter + 1'b1;
    end
    assign clk_out = (clk_counter == 0);


    counter #(.N(N))counter1
    (
        .CLK(clk_out),
        .rst(rst),
        .tgr(tgr1),
        .q(out1)
    );

    counter #(.N(N))counter2
    (
        .CLK(clk_out),
        .rst(rst),
        .tgr(tgr2),
        .q(out)
    );

    decoder decoder
    (
        .in(out1),
        .seg(seg),
        .an(an)
    );

endmodule