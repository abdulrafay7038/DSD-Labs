module multiplier_tb();
logic [3:0] X;
logic [3:0] P;

multiplier uut (
    .X(X),
    .P(P)
    );

initial begin
    X = 4'b0010;
    #5;
    X = 4'b0011;
    #5;
    X = 4'b0100;
    #5;
    X = 4'b0101;
end
      
endmodule