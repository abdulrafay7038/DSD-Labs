module dac #(
    parameter CYCLES_PER_WINDOW = 1024,
    parameter CODE_WIDTH = $clog2(CYCLES_PER_WINDOW)
)(
    input  logic clk, rst,
    input  logic [CODE_WIDTH-1:0] code,
    output logic next_sample,
    output logic pwm
);

logic [CODE_WIDTH - 1:0] counter;

// counter
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
    end
    else begin
        if (counter == CYCLES_PER_WINDOW - 1) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end
end

// next sample
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        next_sample <= 0;
    end
    else begin
        if (counter == CYCLES_PER_WINDOW - 2) begin
            next_sample <= 1;
        end
        else begin
            next_sample <= 0;
        end
    end
end

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        pwm <= 0;
    end
    else begin
        pwm = (counter < code);
    end
end

endmodule