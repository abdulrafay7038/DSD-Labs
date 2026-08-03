module mem_controller #(
  parameter FIFO_WIDTH = 8
) (
  input clk,
  input rst,
  input rx_fifo_empty,
  input tx_fifo_full,
  input [FIFO_WIDTH-1:0] din,

  output rx_fifo_rd_en,
  output tx_fifo_wr_en,
  output [FIFO_WIDTH-1:0] dout,
  output [5:0] state_leds
);

  localparam MEM_WIDTH = 8;   /* Width of each mem entry (word) */
  localparam MEM_DEPTH = 256; /* Number of entries */
  localparam NUM_BYTES_PER_WORD = MEM_WIDTH/8;
  localparam MEM_ADDR_WIDTH = $clog2(MEM_DEPTH); 

  logic [NUM_BYTES_PER_WORD-1:0] mem_we;
  logic [NUM_BYTES_PER_WORD-1:0] mem_rd;
  logic [MEM_ADDR_WIDTH-1:0] mem_addr;
  logic [MEM_WIDTH-1:0] mem_din, cmd;
  logic ld_cmd, ld_addr, ld_data;

  memory #(.dwidth(MEM_WIDTH),.depth(MEM_DEPTH)) 
    mem (
    .clk(clk),
    .we(mem_we),
    .re(1'b1),
    .addr(mem_addr),
    .din(mem_din),
    .dout(dout)
  );

  datapath_mem_ctrl #(.WIDTH(MEM_WIDTH))
    datapath (
    .clk(clk),
    .rst(rst),
    .din(din),
    .LD_CMD(ld_cmd),
    .LD_ADDR(ld_addr),
    .LD_DATA(ld_data),
    .cmd(cmd),
    .addr(mem_addr),
    .data(mem_din)
  );

  controller_mem_ctrl #(.WIDTH(MEM_WIDTH))
    controller (
    .clk(clk),
    .rst(rst),
    .CMD(cmd),
    .rx_fifo_empty(rx_fifo_empty),
    .tx_fifo_full(tx_fifo_full),
    .LD_CMD(ld_cmd),
    .LD_ADDR(ld_addr),
    .LD_DATA(ld_data),
    .RE(mem_rd),
    .WE(mem_we),
    .rx_fifo_rd_en(rx_fifo_rd_en),
    .state_leds(state_leds),
    .tx_fifo_wr_en(tx_fifo_wr_en)
  );
endmodule
