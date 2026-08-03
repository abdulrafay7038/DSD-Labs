module top_dac_tb();

logic clk,aud_pwm,rst;

top_dac UUT(
    .clk(clk),
    .rst(rst),
    .aud_pwm(aud_pwm)
);

initial clk=1;
always begin
    #5 clk=~clk;
end

initial begin
    rst=1;
    #100 rst=0;
end

endmodule