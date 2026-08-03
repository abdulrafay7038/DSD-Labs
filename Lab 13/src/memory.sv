module memory
#(parameter dwidth = 8, 
            depth  = 2,
            awidth = $clog2(depth)
            
)
(
    input  logic              clk,
    input  logic              we,
    input  logic              re,
    input  logic [dwidth-1:0] din,
    input  logic [awidth-1:0] addr,
    output logic [dwidth-1:0] dout
);

logic [dwidth-1:0] mem [depth-1:0];

always_ff @(posedge clk) begin
    
        if(we == 1) begin
            mem[addr] <= din;
        end
        else if(re == 1) begin
            dout <= mem[addr];
        end
    
end

endmodule