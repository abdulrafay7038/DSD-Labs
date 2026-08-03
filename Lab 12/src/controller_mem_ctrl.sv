module controller_mem_ctrl#(parameter WIDTH = 8)
    (
    input logic clk,
    input logic rst,
    input logic [WIDTH-1:0] CMD,
    input logic rx_fifo_empty, tx_fifo_full,
    output logic LD_CMD, LD_ADDR, LD_DATA, RE, WE, rx_fifo_rd_en, tx_fifo_wr_en,
    output logic [5:0] state_leds
    );

    typedef enum logic [3:0] {
    IDLE       = 4'd0,
    READ_CMD   = 4'd1,
    LOAD_CMD   = 4'd2,
    READ_ADDR  = 4'd3,
    LOAD_ADDR  = 4'd4,
    READ_MEM   = 4'd5,
    ECHO_VALUE = 4'd6,
    READ_DATA  = 4'd7,
    LOAD_DATA  = 4'd8,
    WRITE_MEM  = 4'd9
  } state;
  state NS, PS;

  //State Register
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      PS <= IDLE;
    end
    else begin
      PS <= NS;
    end
  end

  //Next State Logic
  always_comb begin
    case (PS)
    IDLE: begin
      if (rx_fifo_empty == 1) begin
        NS = IDLE;
      end
      else begin
        NS = READ_CMD;
      end
    end

    READ_CMD: begin
      NS = LOAD_CMD;
    end

    LOAD_CMD: begin
      if (rx_fifo_empty == 1) begin
        NS = LOAD_CMD;
      end
      else begin
        NS = READ_ADDR;
      end
    end

    READ_ADDR: begin
      NS = LOAD_ADDR;
    end

    LOAD_ADDR: begin
      if (CMD == 8'd48) begin
        NS = READ_MEM;
      end
      else if (rx_fifo_empty == 0 && CMD == 8'd49) begin
        NS = READ_DATA;
      end
      else begin
        NS = LOAD_ADDR;
      end
    end

    READ_MEM: begin
      if (tx_fifo_full == 1)begin
        NS = READ_MEM;
      end
      else begin
        NS = ECHO_VALUE;
      end
    end

    ECHO_VALUE: begin
      NS = IDLE;
    end

    READ_DATA: begin
      NS = LOAD_DATA;
    end

    LOAD_DATA: begin
      NS = WRITE_MEM;
    end

    WRITE_MEM: begin
      NS = IDLE;
    end
    endcase
  end

  //Output Logic
  always_comb begin
      LD_CMD        = 0;
      LD_ADDR       = 0;
      LD_DATA       = 0;
      RE            = 0;
      WE            = 0;
      rx_fifo_rd_en = 0;
      state_leds    = 6'b000000;
      tx_fifo_wr_en = 0;
    case (PS)
    IDLE: begin
      LD_CMD        = 0;
      LD_ADDR       = 0;
      LD_DATA       = 0;
      RE            = 0;
      WE            = 0;
      rx_fifo_rd_en = 0;
      state_leds    = 6'b000001;
      tx_fifo_wr_en = 0;
    end

    READ_CMD: begin
      LD_CMD        = 0;
      LD_ADDR       = 0;
      LD_DATA       = 0;
      RE            = 0;
      WE            = 0;
      rx_fifo_rd_en = 1;
      state_leds    = 6'b000000;
      tx_fifo_wr_en = 0;
    end

    LOAD_CMD: begin
      LD_CMD        = 1;
      LD_ADDR       = 0;
      LD_DATA       = 0;
      RE            = 0;
      WE            = 0;
      rx_fifo_rd_en = 0;
      state_leds    = 6'b000010;
      tx_fifo_wr_en = 0;
    end

    READ_ADDR: begin
      LD_CMD        = 0;
      LD_ADDR       = 0;
      LD_DATA       = 0;
      RE            = 0;
      WE            = 0;
      rx_fifo_rd_en = 1;
      state_leds    = 6'b000000;
      tx_fifo_wr_en = 0;
    end

    LOAD_ADDR: begin
      LD_CMD        = 0;
      LD_ADDR       = 1;
      LD_DATA       = 0;
      RE            = 0;
      WE            = 0;
      rx_fifo_rd_en = 0;
      state_leds    = 6'b000100;
      tx_fifo_wr_en = 0;
    end

    READ_MEM: begin
      LD_CMD        = 0;
      LD_ADDR       = 0;
      LD_DATA       = 0;
      RE            = 1;
      WE            = 0;
      rx_fifo_rd_en = 0;
      state_leds    = 6'b000000;
      tx_fifo_wr_en = 0;
    end

    ECHO_VALUE: begin
      LD_CMD        = 0;
      LD_ADDR       = 0;
      LD_DATA       = 0;
      RE            = 0;
      WE            = 0;
      rx_fifo_rd_en = 0;
      state_leds    = 6'b000000;
      tx_fifo_wr_en = 1;
    end

    READ_DATA: begin
      LD_CMD        = 0;
      LD_ADDR       = 0;
      LD_DATA       = 0;
      RE            = 0;
      WE            = 0;
      rx_fifo_rd_en = 1;
      state_leds    = 6'b000000;
      tx_fifo_wr_en = 0;
    end

    LOAD_DATA: begin
      LD_CMD        = 0;
      LD_ADDR       = 0;
      LD_DATA       = 1;
      RE            = 0;
      WE            = 0;
      rx_fifo_rd_en = 0;
      state_leds    = 6'b000000;
      tx_fifo_wr_en = 0;
    end

    WRITE_MEM: begin
      LD_CMD        = 0;
      LD_ADDR       = 0;
      LD_DATA       = 0;
      RE            = 0;
      WE            = 1;
      rx_fifo_rd_en = 0;
      state_leds    = 6'b000000;
      tx_fifo_wr_en = 0;
    end
    endcase
  end
endmodule