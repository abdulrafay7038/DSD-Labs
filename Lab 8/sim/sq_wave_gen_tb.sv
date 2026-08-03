module sq_wave_gen_tb;
logic clk, rst, next_sample;
logic [9:0] code;

sq_wave_gen DUT(
    .clk(clk),
    .rst(rst),
    .next_sample(next_sample),
    .code(code)
);
initial clk=1;
always begin
    #5 clk=~clk;
end
initial next_sample=0;
always begin
    #10 next_sample = ~next_sample;
end

initial begin
    rst=1;
    #5 rst=0; 
end
endmodule