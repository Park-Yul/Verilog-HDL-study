`timescale 1ns / 1ps
module tb_btn_debounce;
    reg  clk;
    reg  reset;
    reg  i_btn;
    wire o_btn;

    // parameter
    parameter DELAY = 1_000 * 10;  // 100kHz Period 10us

    // DUT instantiation
    btn_debounce DUT (
        .clk  (clk),
        .reset(reset),
        .i_btn(i_btn),
        .o_btn(o_btn)
    );

    // clock generation
    always #5 clk = ~clk;

    // Scenario
    initial begin
        clk   = 0;
        reset = 1;
        i_btn = 0;
        #10;

        reset = 0;

        // 1010 input with 15us period
        i_btn = 1;
        #(1.5 * DELAY);

        i_btn = 0;
        #(1.5 * DELAY);

        i_btn = 1;
        #(1.5 * DELAY);

        i_btn = 0;
        #(1.5 * DELAY);

        // 1'b0 input for 200us
        i_btn = 1;
        #(20 * DELAY);
        $stop;
    end
endmodule
