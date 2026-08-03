`define WIDTH 4
`define DEPTH 8
module fifo_tb;
logic clk;
logic rst;
logic wr_en;
logic [`WIDTH-1:0]din;
logic full;

logic rd_en;
logic [`WIDTH-1:0]dout;
logic empty;

fifo #(.WIDTH(`WIDTH),.DEPTH(`DEPTH))
DUT(
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .din(din),
    .full(full),

    .rd_en(rd_en),
    .dout(dout),
    .empty(empty)

);

initial clk = 0;
always #5 clk = ~clk;

initial begin
    rst = 1; rd_en = 0; wr_en = 0; din = 5;
    #10 rst =0; rd_en = 0; wr_en = 1;
    #10 din = 6;
    #10 din = 7;
    #10 din = 10;
    #10 din = 8;
    #10 din = 5;
    #10 din = 4;
    #10 din = 3; //FIFO is full now
    #10 din = 1;
    #10 din = 15;
    #10 wr_en = 0; 
    #15 rd_en = 1;
    #100 rd_en = 0; //FIFO becomes empty
end

endmodule