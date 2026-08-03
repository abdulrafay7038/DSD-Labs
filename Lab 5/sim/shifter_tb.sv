module shifter_tb;

logic    [3:0]X;
logic    [3:0]Y;
logic   S1,S0,K;

shifter uut(
    .X(X),
    .Y(Y),
    .S1(S1),
    .S0(S0),
    .K(K)
);

initial begin
    X=1; S1=0; S0=0; K=0; #10;
    X=2; S1=0; S0=1; K=0; #10;
    X=3; S1=1; S0=0; K=0; #10;
    X=1; S1=1; S0=1; K=0; #10;
    X=4; S1=1; S0=1; K=1; #10; 
end

endmodule