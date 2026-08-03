module controller_mem_ctrl_md#(parameter WIDTH = 8)
    (
    input logic clk,
    input logic rst,
    input logic [WIDTH-1:0] CMD,
    input logic rx_fifo_empty, tx_fifo_full,
    output logic LD_CMD, LD_ADDR, LD_DATA, RE, WE, rx_fifo_rd_en, tx_fifo_wr_en,
    output logic [5:0] state_leds
    );

    typedef enum logic [2:0] {
    IDLE       = 3'd0,
    GET_CMD    = 3'd1,
    GET_ADDR   = 3'd2,
    READ_MEM   = 3'd3,
    ECHO_VALUE = 3'd4,
    GET_DATA   = 3'd5,
    WRITE_MEM  = 3'd6
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
    rx_fifo_rd_en = 0;
    case (PS)
    IDLE: begin
      if (rx_fifo_empty == 0) begin
        NS = GET_CMD;
        rx_fifo_rd_en = 1;
      end
      else if (rx_fifo_empty == 1) begin
        NS = IDLE;
        rx_fifo_rd_en = 0;
      end
    end

    GET_CMD: begin
      if (rx_fifo_empty == 0) begin
        NS = GET_ADDR;
        rx_fifo_rd_en = 1;
      end
      else if (rx_fifo_empty == 1) begin
        NS = GET_CMD;
        rx_fifo_rd_en = 0;
      end
    end

    GET_ADDR: begin
      if (CMD == 8'd48) begin 
        NS = READ_MEM;
        rx_fifo_rd_en = 0;
      end
      else if (CMD == 8'd49) begin
        if (rx_fifo_empty == 1) begin
           NS = GET_ADDR;
           rx_fifo_rd_en = 0;
        end
        else if (rx_fifo_empty == 0) begin
           NS = GET_DATA;
           rx_fifo_rd_en = 1; 
        end
      end
    end
    GET_DATA: NS = WRITE_MEM;
    READ_MEM: begin
      if (tx_fifo_full == 1)begin
        NS = READ_MEM;
      end
      else if(tx_fifo_full == 0) begin
        NS = ECHO_VALUE;
      end
    end
    
    ECHO_VALUE: begin
      NS = IDLE;
    end

    WRITE_MEM: begin
      NS = IDLE;
    end
    endcase
  end

  //Output Logic
  always_comb begin
    tx_fifo_wr_en = 0;
    case (PS)
    IDLE: begin
      LD_CMD        = 0;
      LD_ADDR       = 0;
      LD_DATA       = 0;
      RE            = 0;
      WE            = 0;
      state_leds    = 6'b000001;
    end

    GET_CMD: begin
      LD_CMD        = 1;
      LD_ADDR       = 0;
      LD_DATA       = 0;
      RE            = 0;
      WE            = 0;
      state_leds    = 6'b000000;
    end

    GET_ADDR: begin
      LD_CMD        = 0;
      LD_ADDR       = 1;
      LD_DATA       = 0;
      RE            = 0;
      WE            = 0;
      state_leds    = 6'b000010;
    end

    GET_DATA: begin
      LD_CMD        = 0;
      LD_ADDR       = 0;
      LD_DATA       = 1;
      RE            = 0;
      WE            = 0;
      state_leds    = 6'b000000;
    end

    READ_MEM: begin
      LD_CMD        = 0;
      LD_ADDR       = 0;
      LD_DATA       = 0;
      RE            = 1;
      WE            = 0;
      state_leds    = 6'b000000;
    end

    ECHO_VALUE: begin
      LD_CMD        = 0;
      LD_ADDR       = 0;
      LD_DATA       = 0;
      RE            = 0;
      WE            = 0;
      tx_fifo_wr_en = 1;
      state_leds    = 6'b000000;
    end

    WRITE_MEM: begin
      LD_CMD        = 0;
      LD_ADDR       = 0;
      LD_DATA       = 0;
      RE            = 0;
      WE            = 1;
      state_leds    = 6'b000000;
    end
    endcase
  end
endmodule