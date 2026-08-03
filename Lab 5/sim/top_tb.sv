module top_tb;
    
    logic [3:0]X;
    logic [2:0]sel;
    logic [6:0]seg;
    logic [7:0]an;

top UUT
(
    .X(X),
    .sel(sel),
    .seg(seg),
    .an(an)
);

initial begin
    X = 0; sel = 0; #10;
    X = 1; sel = 1; #10;
    X = 2; sel = 2; #10;
    X = 3; sel = 3; #10;
    X = 4; sel = 4; #10;
    X = 5; sel = 5; #10;
end

endmodule

