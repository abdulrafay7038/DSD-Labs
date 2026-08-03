// module mem_controller #(
//   parameter FIFO_WIDTH = 8
// ) (
//   input clk,
//   input rst,
//   input rx_fifo_empty,
//   input tx_fifo_full,
//   input [FIFO_WIDTH-1:0] din,

//   output rx_fifo_rd_en,
//   output tx_fifo_wr_en,
//   output [FIFO_WIDTH-1:0] dout,
//   output [5:0] state_leds
// );

//   localparam MEM_WIDTH = 8;   /* Width of each mem entry (word) */
//   localparam MEM_DEPTH = 256; /* Number of entries */
//   localparam NUM_BYTES_PER_WORD = MEM_WIDTH/8;
//   localparam MEM_ADDR_WIDTH = $clog2(MEM_DEPTH); 

//   wire [NUM_BYTES_PER_WORD-1:0] mem_we;
//   wire [NUM_BYTES_PER_WORD-1:0] mem_rd;
//   wire [MEM_ADDR_WIDTH-1:0] mem_addr;
//   wire [MEM_WIDTH-1:0] mem_din, cmd;
//   wire ld_cmd, ld_addr, ld_data;

//   memory #(.dwidth(MEM_WIDTH),.depth(MEM_DEPTH)) 
//     mem (
//     .clk(clk),
//     .we(mem_we),
//     .re(mem_rd),
//     .addr(mem_addr),
//     .din(mem_din),
//     .dout(dout)
//   );

//   datapath_mem_ctrl #(.WIDTH(MEM_WIDTH))
//     datapath (
//     .clk(clk),
//     .rst(rst),
//     .din(din),
//     .LD_CMD(ld_cmd),
//     .LD_ADDR(ld_addr),
//     .LD_DATA(ld_data),
//     .cmd(cmd),
//     .addr(mem_addr),
//     .data(mem_din)
//   );

//   controller_mem_ctrl_md #(.WIDTH(MEM_WIDTH))
//     controller (
//     .clk(clk),
//     .rst(rst),
//     .CMD(cmd),
//     .rx_fifo_empty(rx_fifo_empty),
//     .tx_fifo_full(tx_fifo_full),
//     .LD_CMD(ld_cmd),
//     .LD_ADDR(ld_addr),
//     .LD_DATA(ld_data),
//     .RE(mem_rd),
//     .WE(mem_we),
//     .rx_fifo_rd_en(rx_fifo_rd_en),
//     .state_leds(state_leds),
//     .tx_fifo_wr_en(tx_fifo_wr_en)
//   );
// endmodule

module mem_controller #(
  parameter FIFO_WIDTH = 8
) (
  input  clk,
  input  rst,
  input  rx_fifo_empty,
  input  tx_fifo_full,
  input  [FIFO_WIDTH-1:0] din,

  output reg                  rx_fifo_rd_en,
  output reg                  tx_fifo_wr_en,
  output reg [FIFO_WIDTH-1:0] dout,
  output [5:0]                state_leds
);

  localparam MEM_WIDTH      = 8;
  localparam MEM_DEPTH      = 256;
  localparam MEM_ADDR_WIDTH = $clog2(MEM_DEPTH);

  localparam [7:0] READ_CMD  = 8'd48;
  localparam [7:0] WRITE_CMD = 8'd49;

  localparam [5:0]
    IDLE            = 6'd0,
    READ_COMMAND    = 6'd1,
    SAVE_COMMAND    = 6'd2,
    WAIT_ADDRESS    = 6'd3,
    READ_ADDRESS    = 6'd4,
    SAVE_ADDRESS    = 6'd5,
    READ_MEMORY     = 6'd6,
    SAVE_READ_DATA  = 6'd7,
    WAIT_TX_FIFO    = 6'd8,
    SEND_DATA       = 6'd9,
    WAIT_WRITE_DATA = 6'd10,
    READ_WRITE_DATA = 6'd11,
    SAVE_WRITE_DATA = 6'd12,
    WRITE_MEMORY    = 6'd13;

  wire [5:0] state;
  reg  [5:0] next_state;

  wire [7:0]                command;
  wire [MEM_ADDR_WIDTH-1:0] address;
  wire [MEM_WIDTH-1:0]      write_data;
  wire [MEM_WIDTH-1:0]      read_data;

  wire [0:0]                mem_we;
  reg  [MEM_ADDR_WIDTH-1:0] mem_addr;
  reg  [MEM_WIDTH-1:0]      mem_din;
  wire [MEM_WIDTH-1:0]      mem_dout;

  /*
   * State and data registers.
   * These use the REGISTER modules from your supplied EECS151 file.
   */
  REGISTER_R #(
    .N(6),
    .INIT(IDLE)
  ) state_register (
    .q   (state),
    .d   (next_state),
    .rst (rst),
    .clk (clk)
  );

  REGISTER_R_CE #(
    .N(8)
  ) command_register (
    .q   (command),
    .d   (din[7:0]),
    .rst (rst),
    .ce  (state == SAVE_COMMAND),
    .clk (clk)
  );

  REGISTER_R_CE #(
    .N(MEM_ADDR_WIDTH)
  ) address_register (
    .q   (address),
    .d   (din[MEM_ADDR_WIDTH-1:0]),
    .rst (rst),
    .ce  (state == SAVE_ADDRESS),
    .clk (clk)
  );

  REGISTER_R_CE #(
    .N(MEM_WIDTH)
  ) write_data_register (
    .q   (write_data),
    .d   (din[MEM_WIDTH-1:0]),
    .rst (rst),
    .ce  (state == SAVE_WRITE_DATA),
    .clk (clk)
  );

  REGISTER_R_CE #(
    .N(MEM_WIDTH)
  ) read_data_register (
    .q   (read_data),
    .d   (mem_dout),
    .rst (rst),
    .ce  (state == SAVE_READ_DATA),
    .clk (clk)
  );

  /*
   * RAM supplied in your EECS151 standard include file.
   * wbe = 1 writes the complete 8-bit word.
   */
  SYNC_RAM_WBE #(
    .DWIDTH(MEM_WIDTH),
    .AWIDTH(MEM_ADDR_WIDTH),
    .DEPTH (MEM_DEPTH)
  ) mem (
    .q    (mem_dout),
    .d    (mem_din),
    .addr (mem_addr),
    .en   (1'b1),
    .wbe  (mem_we),
    .clk  (clk)
  );

  assign mem_we     = (state == WRITE_MEMORY) ? 1'b1 : 1'b0;
  assign state_leds = state;

  always @(*) begin
    next_state    = state;
    rx_fifo_rd_en = 1'b0;
    tx_fifo_wr_en = 1'b0;

    dout     = {FIFO_WIDTH{1'b0}};
    mem_addr = address;
    mem_din  = write_data;

    case (state)

      IDLE: begin
        if (!rx_fifo_empty)
          next_state = READ_COMMAND;
      end

      READ_COMMAND: begin
        rx_fifo_rd_en = 1'b1;
        next_state    = SAVE_COMMAND;
      end

      SAVE_COMMAND: begin
        if ((din[7:0] == READ_CMD) || (din[7:0] == WRITE_CMD))
          next_state = WAIT_ADDRESS;
        else
          next_state = IDLE;
      end

      WAIT_ADDRESS: begin
        if (!rx_fifo_empty)
          next_state = READ_ADDRESS;
      end

      READ_ADDRESS: begin
        rx_fifo_rd_en = 1'b1;
        next_state    = SAVE_ADDRESS;
      end

      SAVE_ADDRESS: begin
        if (command == READ_CMD)
          next_state = READ_MEMORY;
        else
          next_state = WAIT_WRITE_DATA;
      end

      // Address is applied to synchronous RAM in this state.
      READ_MEMORY: begin
        mem_addr   = address;
        next_state = SAVE_READ_DATA;
      end

      // Captures synchronous RAM output in read_data register.
      SAVE_READ_DATA: begin
        next_state = WAIT_TX_FIFO;
      end

      WAIT_TX_FIFO: begin
        if (!tx_fifo_full)
          next_state = SEND_DATA;
      end

      SEND_DATA: begin
        dout          = {FIFO_WIDTH{1'b0}};
        dout[7:0]     = read_data;
        tx_fifo_wr_en = 1'b1;
        next_state    = IDLE;
      end

      WAIT_WRITE_DATA: begin
        if (!rx_fifo_empty)
          next_state = READ_WRITE_DATA;
      end

      READ_WRITE_DATA: begin
        rx_fifo_rd_en = 1'b1;
        next_state    = SAVE_WRITE_DATA;
      end

      SAVE_WRITE_DATA: begin
        next_state = WRITE_MEMORY;
      end

      WRITE_MEMORY: begin
        mem_addr   = address;
        mem_din    = write_data;
        next_state = IDLE;
      end

      default: begin
        next_state = IDLE;
      end

    endcase
  end

endmodule