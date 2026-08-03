module comparator#(parameter N=4)
(
    input logic [N-1:0]  in,
    output logic         out
);

    assign out = (in < {N{1'b1}});

endmodule