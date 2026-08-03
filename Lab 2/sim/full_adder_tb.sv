module full_adder_tb();

logic A;
logic B;
logic Cin;
logic Sum;
logic Cout;

full_adder MEA (
    .A(A),
    .B(B),
    .Cin(Cin),
    .Sum(Sum),
    .Cout(Cout)
);

initial begin
    A = 0; B = 0; Cin = 0; #10;
    A = 0; B = 0; Cin = 1; #10;
    A = 0; B = 1; Cin = 0; #10;
    A = 0; B = 1; Cin = 1; #10;
    A = 1; B = 0; Cin = 0; #10;
    A = 1; B = 0; Cin = 1; #10;
    A = 1; B = 1; Cin = 0; #10;
    A = 1; B = 1; Cin = 1; #10;

    $stop;
end

endmodule
