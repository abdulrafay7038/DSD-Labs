module dq_ff
(
    input  logic d,
    input  logic clk,
    input  logic rst,
    output logic q
);

always_ff @(posedge clk or posedge rst) begin 
    if(rst==1) begin
        q<=0;
    end     
    else begin
        q<=d;
    end    
end

endmodule