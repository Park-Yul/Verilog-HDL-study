`timescale 1ns / 1ps
module tb_fsm;

    reg        clk;
    reg        reset;
    reg  [2:0] sw;
    wire [2:0] led;

    // DUT instantiation
    fsm DUT (
        .clk  (clk),
        .reset(reset),
        .sw   (sw),
        .led  (led)
    );

    // clock generation 
    always #5 clk = ~clk;

    // scenario
    initial begin
        // reset
        clk = 1'b0;
        reset = 1'b1;
        sw = 3'b000;
        #10;
        reset = 1'b0;
        #3;
        
        // #1 S0 -> S1
        sw = 3'b001;
        #7;

        // #2 S1 -> S2
        sw = 3'b010;
        #10;

        // #3 S2 -> S3
        sw = 3'b011;
        #10;

        // #4 S3 -> S4
        sw = 3'b100;
        #10;

        // #5 S4 -> S0
        sw = 3'b111;
        #10;

        // #6 S0 -> S0
        sw = 3'b011;
        #10;

        // #7 S0 -> S4
        sw = 3'b100;
        #10;

        // #8 S4 -> S1
        sw = 3'b001;
        #10;

        // #8 S4 -> S1
        sw = 3'b000;
        #10;

        $stop;

    end

endmodule
