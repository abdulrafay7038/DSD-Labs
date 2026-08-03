module full_adder (
    input  logic A,
    input  logic B,
    input  logic Cin,
    output logic Sum,
    output logic Cout
);

    wire logic A1, A2, A3;

    xor (Sum, A, B, Cin);

    and (A1, A, B);
    and (A2, A, Cin);
    and (A3, B, Cin);

    or  (Cout, A1, A2, A3);

endmodule
