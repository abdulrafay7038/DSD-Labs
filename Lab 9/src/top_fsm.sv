module top_fsm(
    input  logic clk,rst,left,right,
    output logic LA,LB,LC,RA,RB,RC
);

logic left_parsed, right_parsed, divided_clk;

button_parser B1(
    .clk(clk),
    .rst(rst),
    .btn_signal(left),
    .parsed_signal(left_parsed)
);

button_parser B2(
    .clk(clk),
    .rst(rst),
    .btn_signal(right),
    .parsed_signal(right_parsed)
);

freq_divider FD(
    .clk(clk),
    .reset(rst),
    .clk_out(divided_clk)
);

FSM FSM(
    .clk(divided_clk),
    .rst(rst),
    .left(left_parsed),
    .right(right_parsed),
    .LA(LA),
    .LB(LB),
    .LC(LC),
    .RA(RA),
    .RB(RB),
    .RC(RC)
);



endmodule