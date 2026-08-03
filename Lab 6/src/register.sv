module register#(parameter N=4)
(
    input  logic  [N-1:0]d,
    input  logic      en,
    input  logic     CLK,
    input  logic     rst,
    output logic  [N-1:0]q
);

always_ff @(posedge CLK or posedge rst) begin 
    if(rst==1) begin
        q<=0;
    end     
    else if(en==1) begin
        q<=d;
    end    
end

endmodule