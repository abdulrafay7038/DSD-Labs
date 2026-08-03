
`define SCM 3
`define PCM 3
module btn_parser_tb;
logic clk;
logic async_signal;
logic rst;
logic edge_detected_pulse;

button_parser #(.SCM(`SCM),.PCM(`PCM)) 
UUT (
    .clk(clk),
    .btn_signal(async_signal),
    .rst(rst),
    .parsed_signal(edge_detected_pulse)
);

initial clk=1;

always begin
    #5 clk=~clk;
end

initial begin
      
        async_signal = 0; rst = 1;
        #10  rst = 0;
        #50 async_signal=1;
        #200 async_signal=0;
        #20 async_signal=1;
        #180 async_signal=0;
        #20 $finish;

end
endmodule