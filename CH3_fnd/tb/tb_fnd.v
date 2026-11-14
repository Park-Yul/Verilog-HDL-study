`timescale 1ns / 1ps
module tb_fnd;
    reg clk, reset;
    reg  [7:0] fnd_in;
    wire [3:0] fnd_com;
    wire [7:0] fnd_data;

    // fnd_controller(DUT) instantiation
    fnd_controller DUT (
        .clk(clk),
        .reset(reset),
        .fnd_in(fnd_in),
        .fnd_com(fnd_com),
        .fnd_data(fnd_data)
    );

    // clk generation
    always #5 clk = ~clk;
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        fnd_in = 8'd123;
        #10;
        reset = 1'b0;
        #(500_000 * 11);  // check 2 cycle
        $stop;
    end
endmodule
