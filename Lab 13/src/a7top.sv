module a7top#(
    parameter CLOCK_FREQ = 100_000_000,
    parameter BAUD_RATE = 115_200,
    parameter CYCLES_PER_SECOND = 100_000_000
)
(
    input  logic clk,
    input  logic rst,
    output logic [5:0]led,
    
    input  logic FPGA_SERIAL_RX,
    output logic FPGA_SERIAL_TX
);

//------------------------- UART ---------------------------
    // This UART is on the FPGA and communicates with your desktop
    // using the FPGA_SERIAL_TX, and FPGA_SERIAL_RX signals. The ready/valid
    // interface for this UART is used on the FPGA design.
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic data_in_valid, data_in_ready, data_out_valid, data_out_ready;
    
    uart # (.CLOCK_FREQ(CLOCK_FREQ),.BAUD_RATE(BAUD_RATE)) 
    on_chip_uart (
        .clk(clk),
        .reset(rst),
        .data_in(data_in),
        .data_in_valid(data_in_valid),
        .data_in_ready(data_in_ready),
        .data_out(data_out),
        .data_out_valid(data_out_valid),
        .data_out_ready(data_out_ready),
        .serial_in(FPGA_SERIAL_RX),
        .serial_out(FPGA_SERIAL_TX)
    );

//------------------------- RX FIFO ---------------------------
    logic rx_full;
    assign data_out_ready = ~rx_full;
    logic [7:0] rx_dout;
    logic rx_empty;
    logic rx_rd_en;;


    fifo #(.WIDTH(8), .DEPTH(8)) 
    rx_fifo (
        .clk(clk), 
        .rst(rst),
        .wr_en(data_out_ready && data_out_valid),               //complete this 
        .din(data_out),
        .full(rx_full),
        .rd_en(rx_rd_en),
        .dout(rx_dout),
        .empty(rx_empty)
    );

//------------------------- TX FIFO ---------------------------
    logic [7:0] tx_din;

    logic tx_full, tx_wr_en;

    logic tx_empty;
    logic tx_empty_delayed;
    assign data_in_valid = ~tx_empty_delayed;
    always_ff @(posedge clk) begin
        tx_empty_delayed <= tx_empty;
    end

    fifo #(.WIDTH(8), .DEPTH(8)) 
    tx_fifo (
        .clk(clk), 
        .rst(rst),
        .wr_en(tx_wr_en),
        .din(tx_din),
        .full(tx_full),
        .rd_en(data_in_ready),            //complete this
        .dout(data_in),
        .empty(tx_empty)
    );

//------------------------- MEM CONTROLLER ---------------------------
    mem_controller #(.FIFO_WIDTH(8)) 
    mem_ctrl (
      .clk(clk),
      .rst(rst),
      .rx_fifo_empty(rx_empty),
      .tx_fifo_full(tx_full),
      .din(rx_dout),    
      .rx_fifo_rd_en(rx_rd_en),
      .tx_fifo_wr_en(tx_wr_en),
      .dout(tx_din),
      .state_leds(led)
    );


endmodule