`define SCM 2

module sample_puslse_tb; 

logic glitchy_signal,clk,sample_pulse;

sample_pulse_generator #(.SCM(`SCM)) 
SPG(
    .clk(clk),
    .glitchy_signal(glitchy_signal),
    .sample_pulse(sample_pulse)
);


initial clk=1;
always begin
    #5 clk=~clk;
end

initial begin
    glitchy_signal = 0;
    #10 glitchy_signal = 1;
end


endmodule

