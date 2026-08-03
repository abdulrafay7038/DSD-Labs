module debouncer #(parameter PCM = 200, parameter N = $clog2(PCM))
(
    input logic clk,
    input logic glitchy_signal,
    input logic sample_pulse,
    output logic debounced_signal
);

logic [N:0] count;
logic reset, enable;
assign reset = ~glitchy_signal;
assign enable = sample_pulse & glitchy_signal;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 0;
    end
    else if (count == PCM) begin
        count <= count;
    end
    else if (enable) begin
        count <= count + 1;
    end
end
assign debounced_signal = count == PCM;
endmodule