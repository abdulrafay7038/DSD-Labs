
`define SCM 2
`define PCM 3
module button_parser_tb;
logic clk;
logic btn_signal;
logic rst;
logic edge_detected_pulse;

button_parser #(.SCM(`SCM),.PCM(`PCM)) 
UUT (
    .clk(clk),
    .btn_signal(btn_signal),
    .rst(rst),
    .parsed_signal(edge_detected_pulse)
);

initial clk=1;

always begin
    #5 clk=~clk;
end

initial begin
      
        btn_signal = 0; rst = 1;
        #5  rst = 0;
        #11  btn_signal = 1;   // first press starts
        #12  btn_signal = 0;   // bounce
        #9  btn_signal = 1;   // bounce
        #9  btn_signal = 0;   // bounce
        #8  btn_signal = 1;   // bounce
        #6  btn_signal = 0;   // bounce
        #5  btn_signal = 1;   // first press starts
        #4  btn_signal = 0;   // bounce
        #7  btn_signal = 1;   // bounce
        #8  btn_signal = 0;   // bounce
        #9  btn_signal = 1;   // bounce
        #11  btn_signal = 0;   // bounce
        #12  btn_signal = 1;   // finally settles high

        #200 btn_signal = 0;   // release starts
        #11  btn_signal = 1;   // bounce
        #12  btn_signal = 0;   // bounce
        #9  btn_signal = 1;   // bounce
        #9  btn_signal = 0;   // finally settles low   
        #8  btn_signal = 1;   // first press starts
        #6  btn_signal = 0;   // bounce
        #5  btn_signal = 1;   // bounce
        #4  btn_signal = 0;   // bounce
        #7  btn_signal = 1;   // bounce
        #11  btn_signal = 0;   // bounce 

end
endmodule