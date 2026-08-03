
`define PCM 3
module debouncer_tb();
    logic clk;
    logic in;
    logic out;
    logic sample_pulse;

    debouncer #(
        .PCM(`PCM)
    ) UUT (
        .clk(clk),
        .glitchy_signal(in),
        .sample_pulse(sample_pulse),
        .debounced_signal(out)
    );

initial clk=1;
always begin
    #5 clk=~clk;
end

initial sample_pulse = 0;
always begin
    #10 sample_pulse = ~sample_pulse;
end
initial begin
              in=0;
         #60  in=1; 
       #120 in=0;
         #20  in=1;
         #180 in=0;

end    
endmodule
