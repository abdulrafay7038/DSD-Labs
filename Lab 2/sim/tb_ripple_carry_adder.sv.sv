module tb_ripple_carry_adder();

logic [2:0] A;
logic [2:0] B;
logic       Cin;
logic [2:0] Sum;
logic       Cout;

ripple_carry_adder_3bit RCA (
    .A(A),
    .B(B),
    .Cin(Cin),
    .Sum(Sum),
    .Cout(Cout)
);

initial begin

    A = 3'b000; B = 3'b000; Cin = 0; #10;
    A = 3'b001; B = 3'b001; Cin = 0; #10;
    A = 3'b011; B = 3'b010; Cin = 0; #10;
    A = 3'b111; B = 3'b111; Cin = 1; #10;
    A = 3'b011; B = 3'b001; Cin = 0; #10;
    A = 3'b010; B = 3'b011; Cin = 1; #10;
    A = 3'b110; B = 3'b001; Cin = 0; #10;
    A = 3'b010; B = 3'b010; Cin = 0; #10;
    A = 3'b110; B = 3'b001; Cin = 0; #10;
    A = 3'b100; B = 3'b111; Cin = 0; #10;
end

endmodule
