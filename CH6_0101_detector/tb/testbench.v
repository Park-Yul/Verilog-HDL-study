`timescale 1ns / 1ps
module tb_non_overlap_detector_0101_moore;
    reg  clk;
    reg  reset;
    reg  x;
    wire z0;
    wire z1;
    wire z2;
    wire z3;

    // DUT Intstantiation
    non_overlap_detector_0101_moore DUT_NOVMOORE (
        .clk(clk),
        .reset(reset),
        .x(x),
        .z(z0)
    );
     non_overlap_detector_0101_mealy DUT_NOVMEALY (
        .clk(clk),
        .reset(reset),
        .x(x),
        .z(z1)
    );
     overlap_detector_0101_moore DUT_OVMOORE (
        .clk(clk),
        .reset(reset),
        .x(x),
        .z(z2)
    );
    overlap_detector_0101_mealy DUT_OVMEALY (
        .clk(clk),
        .reset(reset),
        .x(x),
        .z(z3)
    );

    // clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // scenario
    initial begin
        reset = 1;
        x = 0;
        #10;
        reset = 0;

        // 001010101
        x = 0;
        #10;

        x = 0;
        #10;

        x = 1;
        #10;

        x = 0;
        #10;

        x = 1;
        #10;

        x = 0;
        #10;

        x = 1;
        #10;

        x = 0;
        #10;

        x = 1;
        #10;
        $stop;
    end
endmodule
