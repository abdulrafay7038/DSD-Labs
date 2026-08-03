module mux2to1(
    input logic  in0,
    input logic  in1,
    input logic  select,
    output logic out
);

always_comb begin

    if(select==0) begin
        out=in0;
    end     
    else if (select==1) begin
        out=in1;
    end    

end    

endmodule