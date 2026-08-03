module synchronizer 
(
    input  logic async_signal,
    input  logic clk,
    input  logic rst,
    output logic sync_signal
);

wire logic q1;

dq_ff FF0 (.d(async_signal), .clk(clk), .rst(rst), .q(q1));
dq_ff FF1 (.d(q1), .clk(clk), .rst(rst), .q(sync_signal));

endmodule
