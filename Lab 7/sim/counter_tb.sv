//This counter was tested while ignoring the frequency divider
module counter_tb;
logic in_btn,clk,mode_btn,reset;
logic [3:0] out;

counter UUT(
    .in_btn(in_btn),
    .clk(clk),
    .mode_btn(mode_btn),
    .out(out),
    .reset(reset)
);

initial clk = 1;
always begin
    #5 clk = ~clk;
end
initial in_btn = 0;
always begin
    #10 in_btn = ~in_btn;
end

initial begin

    mode_btn=0; reset=1;
    #5  reset=0;
    #200  mode_btn=1;
    #10  mode_btn=0;
    #200 mode_btn=1;
    #10  mode_btn=0;
end

endmodule