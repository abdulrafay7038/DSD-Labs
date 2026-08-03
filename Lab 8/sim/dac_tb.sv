module dac_tb();
    logic clk;
    logic rst;
    logic [9:0] code;
    logic next_sample;
    logic pwm;

    dac UUT (
        .clk(clk),
        .rst(rst),
        .code(code),
        .next_sample(next_sample),
        .pwm(pwm)
    );

    initial clk=1;
    always begin
        #5 clk=~clk;
    end

    initial begin
        rst = 1;
        #10;
        rst = 0;
        code = 10'd400;
       #1500;
    end
endmodule