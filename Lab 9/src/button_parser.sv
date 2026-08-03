module button_parser #(parameter SCM = 10000, parameter PCM = 100)
(
   input  logic btn_signal,clk,rst,
   output logic parsed_signal
);

logic sync_signal;
logic sample_pulse;
logic debounced_signal;

synchronizer synchronizer
(
    .async_signal(btn_signal),
    .sync_signal(sync_signal),
    .clk(clk),
    .rst(rst)
);
sample_pulse_generator #(.SCM(SCM)) sample_pulse_generator
(
    .clk(clk),
    .glitchy_signal(sync_signal),
    .sample_pulse(sample_pulse)
);
debouncer #(.PCM(PCM)) Debouncer
(
    .clk(clk),
    .glitchy_signal(sync_signal),
    .sample_pulse(sample_pulse),
    .debounced_signal(debounced_signal)
);
assign parsed_signal=debounced_signal;
endmodule