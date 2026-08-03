module top
(
    input  logic clk,reset,
    input  logic [1:0] btn_signal,
    output logic [6:0] seg,
    output logic [7:0] an
);
logic [1:0] parsed_signal;
logic [3:0] counter;

button_parser B0 (
    .btn_signal(btn_signal[0]),
    .parsed_signal(parsed_signal[0]),
    .clk(clk),
    .rst(reset)
);

button_parser B1 (
    .btn_signal(btn_signal[1]),
    .parsed_signal(parsed_signal[1]),
    .clk(clk),
    .rst(reset)
);

counter C (
    .in_btn(parsed_signal[0]),
    .clk(clk),
    .reset(reset),
    .mode_btn(parsed_signal[1]),
    .out(counter)
);

always_comb begin

    an = 8'b11111110; // AN0 active (common cathode)
    case(counter)
        4'd0:    seg = 7'b0000001; // 0 abcdefg
        4'd1:    seg = 7'b1001111; // 1
        4'd2:    seg = 7'b0010010; // 2
        4'd3:    seg = 7'b0000110; // 3
        4'd4:    seg = 7'b1001100; // 4
        4'd5:    seg = 7'b0100100; // 5
        4'd6:    seg = 7'b0100000; // 6
        4'd7:    seg = 7'b0001111; // 7
        4'd8:    seg = 7'b0000000; // 8
        4'd9:    seg = 7'b0000100; // 9
        4'd10:   seg = 7'b0001000; // A
        4'd11:   seg = 7'b1100000; // b
        4'd12:   seg = 7'b0110001; // C
        4'd13:   seg = 7'b1000010; // d
        4'd14:   seg = 7'b0110000; // E
        4'd15:   seg = 7'b0111000; // F
        default: seg = 7'b1111111; // all off
    endcase
end

endmodule