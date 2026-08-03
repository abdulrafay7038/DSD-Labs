module top
(
    input  logic [3:0]X,
    input  logic [2:0]sel,
    output logic [6:0]seg,
    output logic [7:0]an
);
wire logic [3:0]w;

multiplier multiplier
(
    .X(X),
    .P(w)
);

decoder decoder
(
    .sel(sel),
    .in(w),
    .seg(seg),
    .an(an)
);

endmodule
