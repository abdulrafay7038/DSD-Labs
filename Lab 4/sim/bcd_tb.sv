module bcd_tb();
logic [4:0] in;
logic [7:0] out;

bcd bcd (
    .in(in),
    .out(out)
        );

initial begin
    in = 5'b01001;
    #5;
    in = 5'b10010;
    #5;
    in = 5'b11011;
    #5;
    in = 5'b11110;
    #5;
    in = 5'b11111;
    #5;
end

endmodule