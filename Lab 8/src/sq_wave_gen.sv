module sq_wave_gen(
    input  logic        clk, rst,
    input  logic        next_sample,
    output logic [9:0]  code
);

logic [7:0] dac_count;
always_ff @(posedge clk or posedge rst) begin

    if (rst) begin
        code <= 562;
        dac_count <= 0;
    end
    else if (next_sample) begin
        if (dac_count < 111)
            code <= 562;
        else if (dac_count >= 111 || dac_count <= 221)
            code <= 462;   
            dac_count <=0;
        dac_count <= dac_count + 1;    

    end
    else if (dac_count == 221)
            dac_count <= 0;

end
endmodule

