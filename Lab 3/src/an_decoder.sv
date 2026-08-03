module an_decoder (
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