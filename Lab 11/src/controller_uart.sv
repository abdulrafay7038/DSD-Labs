module controller_uart (
    input logic clk, reset,
    input logic data_in_valid, DONE,
    output logic OUT_SEL, data_in_ready, RST1, RST2
    );

    typedef enum logic {
        IDLE = 1'b0,
        TRANSMIT = 1'b1
    }state;

    state NS, PS;

    // State Register
    always_ff @(posedge clk) begin
        if (reset) begin
            PS <= IDLE;
        end
        else begin
            PS <= NS;
        end
    end

    // Next State Logic
    always_comb begin
        case (PS)
            IDLE: begin
                if (data_in_valid == 0) begin
                    NS = IDLE;
                end
                else begin
                    NS = TRANSMIT;
                end
            end

            TRANSMIT: begin
                if (DONE == 0) begin
                    NS = TRANSMIT;
                end
                else begin
                    NS = IDLE;
                end
            end
        endcase
    end

    // Output Logic
    always_comb begin
        case (PS) 
            IDLE: begin
                data_in_ready = 1;
                OUT_SEL       = 1;
                RST1          = 1;
                RST2          = 1;
            end

            TRANSMIT: begin
                data_in_ready = 0;
                OUT_SEL       = 0;
                RST1          = 0;
                RST2          = 0;
            end
        endcase
    end
endmodule