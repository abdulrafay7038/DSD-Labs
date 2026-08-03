module counter 
(
    input  logic in_btn,
    input  logic clk,
    input  logic reset,
    input  logic mode_btn,
    output logic [3:0] out
);

logic [3:0] counter;
logic enable;
logic mode;
logic divided_clk;

freq_divider FD(
    .clk(clk),
    .reset(reset),
    .clk_out(divided_clk)
);

logic div_clk_d, div_clk_pulse;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        div_clk_d     <= 0;
        div_clk_pulse <= 0;
    end else begin
        div_clk_d     <= divided_clk;
        div_clk_pulse <= divided_clk & ~div_clk_d;
    end
end

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        mode <= 0;
    else if (mode_btn)
        mode <= ~mode;
end

always_comb begin
    if (mode)
        enable = div_clk_pulse;  
    else
        enable = in_btn;         
end

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        counter <= 0;
    else if (enable)
        counter <= counter + 1;
end

assign out = counter;

endmodule

