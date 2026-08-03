module edge_detector_tb();
    logic signal_in;
    logic edge_detected_pulse;
    logic CLK;

edge_detector UUT(
    .signal_in(signal_in),
    .edge_detected_pulse(edge_detected_pulse),
    .CLK(CLK)

);

initial CLK = 1;
always begin 
    #5 CLK = ~CLK;
end 

initial begin
    signal_in = 0;
    #7 signal_in = 1;
    
end
endmodule
