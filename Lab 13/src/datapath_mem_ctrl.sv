module datapath_mem_ctrl#(parameter WIDTH = 8)
    (
    input logic clk,
    input logic rst,
    input logic [7:0] din,
    input logic LD_CMD, LD_ADDR, LD_DATA,
    output logic [WIDTH-1:0] cmd,
    output logic [WIDTH-1:0] addr, data
    );
    
    register #(.WIDTH(WIDTH))
    CMD(
        .clk(clk),
        .rst(rst),
        .en(LD_CMD),
        .d(din),
        .q(cmd)
    );

    register #(.WIDTH(WIDTH))
    ADDR(
        .clk(clk),
        .rst(rst),
        .en(LD_ADDR),
        .d(din),
        .q(addr)
    );

    register #(.WIDTH(WIDTH))
    DATA(
        .clk(clk),
        .rst(rst),
        .en(LD_DATA),
        .d(din),
        .q(data)
    );

endmodule

module register #(parameter WIDTH = 8) (
    input  logic clk,
    input  logic rst,
    input  logic en,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
always_ff @(posedge clk or posedge rst) begin
    if (rst)
       q <= 8'b0;
    else if (en)
       q <= d;
    else
       q <= q;   
end
endmodule