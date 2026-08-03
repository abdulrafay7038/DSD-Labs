
module datapath_uart#(
    parameter CLOCK_FREQ = 100_000_000,
    parameter BAUD_RATE = 115_200)
(
    input  logic clk,
    input  logic [7:0] data_in,

    //Control Signals
    input  logic OUT_SEL,
    input  logic LOAD,
    input  logic RST1,
    input  logic RST2,

    output logic DONE,

    output logic serial_out
);

localparam  SYMBOL_EDGE_TIME    =   CLOCK_FREQ / BAUD_RATE;
localparam  CLOCK_COUNTER_WIDTH =   $clog2(SYMBOL_EDGE_TIME);

//Internal Signals
logic shift_reg;
logic [CLOCK_COUNTER_WIDTH-1:0] clk_counter;
logic clk_comparator;
logic [3:0] bit_counter;
logic SHIFT_EN;
logic ENABLE2;

//Latch
logic [9:0] data;
assign data = {1'b1, data_in, 1'b0};

mux2to1 OUT_MUX(
    .in0(shift_reg),
    .in1(1'b1),
    .sel(OUT_SEL),
    .out(serial_out)
);

shift_register SHIFT_REGISTER(
    .clk(clk),
    .data_in(data),
    .load(LOAD),
    .enable(SHIFT_EN),
    .serial_out(shift_reg)
);

counter #(.WIDTH(CLOCK_COUNTER_WIDTH),.COUNT_MAX(SYMBOL_EDGE_TIME - 1))
CLOCK_COUNTER(
    .clk(clk),
    .reset(RST1),
    .enable(1'b1),
    .count(clk_counter)
);

counter #(.WIDTH(4),.COUNT_MAX(9))
BIT_COUNTER(
    .clk(clk),
    .reset(RST2),
    .enable(COUNTER_EN),
    .count(bit_counter)
);

assign clk_comparator = (clk_counter == SYMBOL_EDGE_TIME - 1);
assign SHIFT_EN = clk_comparator;
assign COUNTER_EN = clk_comparator;
assign DONE = (bit_counter == 9) && clk_comparator;

endmodule

//------------------
//Other Modules
//------------------


module shift_register(
    input logic clk,
    input logic load,
    input logic enable,
    input logic [9:0] data_in,
    output logic serial_out
);

logic [9:0] shift_reg;

always_ff @(posedge clk) begin
    if (load)
      shift_reg <= data_in;
    else if (enable)
      shift_reg <= shift_reg >> 1;
end

assign serial_out = (shift_reg[0]);

endmodule

module counter #(parameter WIDTH = 4, parameter COUNT_MAX = 868) 
(
    input logic clk, reset, enable,
    output logic [WIDTH-1:0] count
);

always_ff @(posedge clk or posedge reset) begin
    if (reset)
       count <= 0;
    else if (enable)
       if (count == COUNT_MAX)
           count <= 0;
       else 
           count <= count + 1;   
end

endmodule

module mux2to1 (
    input logic in0,
    input logic in1,
    input logic sel,
    output logic out
);
always_comb begin
   if (sel == 1)
       out = in1;
   else
       out = in0;
end
endmodule
