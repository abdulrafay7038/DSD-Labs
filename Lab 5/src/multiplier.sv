module multiplier(
    input  logic [3:0] X,
    output logic [3:0] P
);

wire logic [3:0] Y1, Y2, Y3, Y4, sum1, sum2;

shifter shifter1(.X(X), .S1(1'b0), .S0(1'b1), .K(1'b0), .Y(Y1));
shifter shifter2(.X(X), .S1(1'b0), .S0(1'b0), .K(1'b0), .Y(Y2));
shifter shifter3(.X(X), .S1(1'b1), .S0(1'b0), .K(1'b1), .Y(Y3));
shifter shifter4(.X(X), .S1(1'b1), .S0(1'b1), .K(1'b1), .Y(Y4));

ripple_carry adder1(.a(Y1),   .b(Y2), .c_in(1'b0), .sum(sum1), .c_out());
ripple_carry adder2(.a(sum1), .b(Y3), .c_in(1'b0), .sum(sum2), .c_out());
ripple_carry adder3(.a(sum2), .b(Y4), .c_in(1'b0), .sum(P),    .c_out());

endmodule