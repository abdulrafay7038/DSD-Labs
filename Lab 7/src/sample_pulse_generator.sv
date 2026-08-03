module sample_pulse_generator #(parameter SCM = 65000, parameter N = $clog2(SCM))
(
    input  logic clk,
    input  logic glitchy_signal,
    output logic sample_pulse
);

logic [N:0] count;
logic reset; 
assign reset = ~glitchy_signal;

always_ff @(posedge clk or posedge reset) begin
    if (reset == 1'b1 || count == SCM) begin
        count <= 0;
    end
    else begin
        count <= count + 1;
    end
end
assign sample_pulse = count == SCM;

endmodule