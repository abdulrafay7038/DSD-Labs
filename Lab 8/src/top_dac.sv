module top_dac
(
    input  logic clk, rst,
    input  logic aud_sd,
    input  logic trigger,
    output logic aud_pwm
);


logic [9:0] code;
logic next_sample;

dac dac(
    .clk(clk),
    .rst(rst),
    .code(code),
    .pwm(aud_pwm),        
    .next_sample(next_sample)
);

sq_wave_gen sq_wave_gen(
    .clk(clk),
    .rst(rst),
    .next_sample(next_sample),
    .code(code)
);

assign aud_sd = trigger;
endmodule