module top_adder_decoder_tb;

logic [2:0] a;
logic [2:0] b;
logic       c_in;
logic [2:0] sel;

logic [6:0] seg;   
logic [7:0] an;    

top_adder_decoder DUT (
    .a(a),
    .b(b),
    .c_in(c_in),
    .sel(sel),
    .seg(seg),
    .an(an)
);

initial begin

    $display("a\tb\tc_in\tsel\tseg\t\tan");
    $display("------------------------------------------------");

    // Case 1: 3 + 4 + 0 = 7
    a = 3; b = 4; c_in = 0; sel = 3'b000;
    #10;
    $display("%0d\t%0d\t%b\t%b\t%b\t%b", a, b, c_in, sel, seg, an);
    if (seg !== 7'b0001111) $display("ERROR: seg incorrect");
    else $display("PASS: seg correct");
    if (an !== 8'b11111110) $display("ERROR: an incorrect");
    else $display("PASS: an correct");


    // Case 2: 7 + 7 + 1 = F
    a = 7; b = 7; c_in = 1; sel = 3'b010;
    #10;
    $display("%0d\t%0d\t%b\t%b\t%b\t%b", a, b, c_in, sel, seg, an);
    if (seg !== 7'b0111000) $display("ERROR: seg incorrect for F");
    else $display("PASS: seg correct for F");
    if (an !== 8'b11111011) $display("ERROR: an incorrect");
    else $display("PASS: an correct");


    // Case 3: 0 + 0 + 0 = 0
    a = 0; b = 0; c_in = 0; sel = 3'b001;
    #10;
    $display("%0d\t%0d\t%b\t%b\t%b\t%b", a, b, c_in, sel, seg, an);
    if (seg !== 7'b0000001) $display("ERROR: seg incorrect for 0");
    else $display("PASS: seg correct for 0");
    if (an !== 8'b11111101) $display("ERROR: an incorrect");
    else $display("PASS: an correct");


    // Case 4: 2 + 3 + 0 = 5
    a = 2; b = 3; c_in = 0; sel = 3'b011;
    #10;
    $display("%0d\t%0d\t%b\t%b\t%b\t%b", a, b, c_in, sel, seg, an);
    if (seg !== 7'b0100100) $display("ERROR: seg incorrect for 5");
    else $display("PASS: seg correct for 5");
    if (an !== 8'b11110111) $display("ERROR: an incorrect");
    else $display("PASS: an correct");


    // Case 5: 5 + 1 + 1 = 7
    a = 5; b = 1; c_in = 1; sel = 3'b100;
    #10;
    $display("%0d\t%0d\t%b\t%b\t%b\t%b", a, b, c_in, sel, seg, an);
    if (seg !== 7'b0001111) $display("ERROR: seg incorrect for 7");
    else $display("PASS: seg correct for 7");
    if (an !== 8'b11101111) $display("ERROR: an incorrect");
    else $display("PASS: an correct");


    // Case 6: 6 + 1 + 0 = 7
    a = 6; b = 1; c_in = 0; sel = 3'b111;
    #10;
    $display("%0d\t%0d\t%b\t%b\t%b\t%b", a, b, c_in, sel, seg, an);
    if (seg !== 7'b0001111) $display("ERROR: seg incorrect for 7");
    else $display("PASS: seg correct for 7");
    if (an !== 8'b01111111) $display("ERROR: an incorrect");
    else $display("PASS: an correct");

    #10;
    $display("Simulation Finished.");
    $stop;

end

endmodule