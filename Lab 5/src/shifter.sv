module shifter(
    input logic [3:0] X,
    input logic S1, S0, K,
    output logic [3:0] Y
);
wire logic [3:0] A, B;

//Stage 1 (mux1 to mux4)
mux2to1 mux1(.in0(X[0]), .in1(1'b0), .select(S1), .out(A[0]));
mux2to1 mux2(.in0(X[1]), .in1(1'b0), .select(S1), .out(A[1]));
mux2to1 mux3(.in0(X[2]), .in1(X[0]), .select(S1), .out(A[2]));
mux2to1 mux4(.in0(X[3]), .in1(X[1]), .select(S1), .out(A[3]));

//Stage 2 (mux5 to mux8)
mux2to1 mux5(.in0(A[0]), .in1(1'b0), .select(S0), .out(B[0]));
mux2to1 mux6(.in0(A[1]), .in1(A[0]), .select(S0), .out(B[1]));
mux2to1 mux7(.in0(A[2]), .in1(A[1]), .select(S0), .out(B[2]));
mux2to1 mux8(.in0(A[3]), .in1(A[2]), .select(S0), .out(B[3]));

//Stage 3 (mux9 to mux12)
mux2to1 mux9 (.in0(B[0]), .in1(1'b0), .select(K), .out(Y[0]));
mux2to1 mux10(.in0(B[1]), .in1(1'b0), .select(K), .out(Y[1]));
mux2to1 mux11(.in0(B[2]), .in1(1'b0), .select(K), .out(Y[2]));
mux2to1 mux12(.in0(B[3]), .in1(1'b0), .select(K), .out(Y[3]));

endmodule