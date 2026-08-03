module decoder1(
    input logic [3:0] in,
    output logic [6:0] seg
);

assign seg[6] = (~in[3]&~in[2]&~in[1]&in[0]|
                 ~in[3]&in[2]&~in[1]&~in[0]|
                 in[3]&~in[2]&in[1]&in[0]|
                 in[3]&in[2]&~in[1]&in[0]);

assign seg[5] = (~in[3]&in[2]&~in[1]&in[0]|
                 ~in[3]&in[2]&in[1]&~in[0]|
                 in[3]&~in[2]&in[1]&in[0]|
                 in[3]&in[2]&~in[1]&~in[0]|
                 in[3]&in[2]&in[1]&~in[0]|
                 in[3]&in[2]&in[1]&in[0]);

assign seg[4] = (~in[3]&~in[2]&in[1]&~in[0]|
                 in[3]&in[2]&~in[1]&~in[0]|
                 in[3]&in[2]&in[1]&~in[0]|
                 in[3]&in[2]&in[1]&in[0]);

assign seg[3] = (~in[3]&~in[2]&~in[1]&in[0]|
                 ~in[3]&in[2]&~in[1]&~in[0]|
                 ~in[3]&in[2]&in[1]&in[0]|
                 in[3]&~in[2]&in[1]&~in[0]|
                 in[3]&in[2]&in[1]&in[0]);

assign seg[2] = (~in[3]&~in[2]&~in[1]&in[0]|
                 ~in[3]&~in[2]&in[1]&in[0]|
                 ~in[3]&in[2]&~in[1]&~in[0]|
                 ~in[3]&in[2]&~in[1]&in[0]|
                 ~in[3]&in[2]&in[1]&in[0]|
                 in[3]&~in[2]&~in[1]&in[0]);

assign seg[1] = (~in[3]&~in[2]&~in[1]&in[0]|
                 ~in[3]&~in[2]&in[1]&~in[0]|
                 ~in[3]&~in[2]&in[1]&in[0]|
                 ~in[3]&in[2]&in[1]&in[0]|
                 in[3]&in[2]&~in[1]&in[0]);

assign seg[0] = (~in[3]&~in[2]&~in[1]&~in[0]|
                 ~in[3]&~in[2]&~in[1]&in[0]|
                 ~in[3]&in[2]&in[1]&in[0]|
                 in[3]&in[2]&~in[1]&~in[0]);

endmodule                 


module decoder2(
    input  logic [2:0] sel,
    output logic [7:0] an
);

assign an[0]=(sel[2]|sel[1]|sel[0]);
assign an[1]=(sel[2]|sel[1]|~sel[0]);
assign an[2]=(sel[2]|~sel[1]|sel[0]);
assign an[3]=(sel[2]|~sel[1]|~sel[0]);
assign an[4]=(~sel[2]|sel[1]|sel[0]);
assign an[5]=(~sel[2]|sel[1]|~sel[0]);
assign an[6]=(~sel[2]|~sel[1]|sel[0]);
assign an[7]=(~sel[2]|~sel[1]|~sel[0]);

endmodule 


module decoder (
    input  logic [3:0] in,
    input  logic [2:0] sel,
    output logic [6:0] seg,
    output logic [7:0] an
);

decoder1 decoder1 (
    .in(in),
    .seg(seg)
);

decoder2 decoder2 (
    .sel(sel),
    .an(an)
);

endmodule