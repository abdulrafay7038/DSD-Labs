module edge_detector #(parameter WIDTH = 1)
(
    input  logic signal_in,rst,
    input  logic clk, 
    output logic edge_detected_pulse
);

wire logic NS0;
wire logic NS1;
wire logic PS0;
wire logic PS1;

assign NS1 = signal_in & PS0;
assign NS0 = signal_in;

dq_ff FF1 (
    .d(NS1),
    .q(PS1),
    .rst(rst),
    .clk(clk)
);

dq_ff FF2 (
    .d(NS0),
    .q(PS0),
    .rst(rst),
    .clk(clk)
);

assign edge_detected_pulse = ~PS1 & PS0;

endmodule