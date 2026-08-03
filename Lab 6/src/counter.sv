module counter#(parameter N=4)
(
    input logic CLK,
    input logic rst,
    input logic tgr,
    output logic [N-1:0]q

);

wire logic [N-1:0] d;
wire logic comp_out, en;

adder      #(.N(N)) adder (.a(1'b1), .b(q), .sum(d));
comparator #(.N(N)) comparator (.in(q), .out(comp_out));
mux2to1             mux (.in0(1), .in1(comp_out), .select(tgr), .out(en));
register   #(.N(N)) register (.d(d), .CLK(CLK), .rst(rst), .en(en), .q(q));

endmodule