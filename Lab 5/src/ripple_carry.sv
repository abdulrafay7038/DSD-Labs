module full_adder (
    input  logic a,
    input  logic b,
    input  logic c_in,
    output logic sum,
    output logic c_out
);

    wire logic a1, a2, a3;

    xor (sum, a, b, c_in);

    and (a1, a, b);
    and (a2, a, c_in);
    and (a3, b, c_in);

    or  (c_out, a1, a2, a3);

endmodule

module ripple_carry (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic c_in,
    output logic [3:0] sum,
    output logic c_out
);
    wire logic c1, c2, c3;

    full_adder FA0 (
        .a(a[0]),
        .b(b[0]),
        .c_in(c_in),
        .sum(sum[0]),
        .c_out(c1)
    );

    full_adder FA1 (
        .a(a[1]),
        .b(b[1]),
        .c_in(c1),
        .sum(sum[1]),
        .c_out(c2)
    );

    full_adder FA2 (
        .a(a[2]),
        .b(b[2]),
        .c_in(c2),
        .sum(sum[2]),
        .c_out(c3)
    );

    full_adder FA3 (
        .a(a[3]),
        .b(b[3]),
        .c_in(c3),
        .sum(sum[3]),
        .c_out(c_out)
    );

endmodule
