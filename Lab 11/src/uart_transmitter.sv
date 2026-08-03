module uart_transmitter #(parameter CLOCK_FREQ = 100_000_000, parameter BAUD_RATE = 115_200)
    (
    input logic clk, reset, data_in_valid,
    input logic [7:0] data_in,
    output logic serial_out, data_in_ready
    );
    wire logic out_sel, rst1, rst2, done, load;

    datapath_uart #(.CLOCK_FREQ(CLOCK_FREQ), .BAUD_RATE(BAUD_RATE)) datapath(.clk(clk), .data_in(data_in), .OUT_SEL(out_sel), .LOAD(load), .RST1(rst1), .RST2(rst2), .DONE(done), .serial_out(serial_out));

    controller_uart  controller(.clk(clk), .reset(reset), .data_in_valid(data_in_valid), .DONE(done), .OUT_SEL(out_sel), .data_in_ready(data_in_ready), .RST1(rst1), .RST2(rst2));

    assign load = data_in_ready & data_in_valid;
endmodule