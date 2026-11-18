`timescale 1ns / 1ps
module tb_top_counter_10000;
    reg clk;
    reg reset;
    reg [2:0] mode;
    wire [3:0] fnd_com;
    wire [7:0] fnd_data;

top_counter_10000 DUT (
    .clk(clk),
    .reset(reset),
    .mode(mode),
    .fnd_com(fnd_com),
    .fnd_data(fnd_data)
);
    // clock generation
    always #5 clk = ~clk;

    // vector excitation
    initial begin
        clk   = 0;
        reset = 1;
        #10 reset = 0;

        mode = 3'b010;
        #(10 * 1_000_000 * 3)  // #1 test 3 cycles cheking upcounting

        mode = 3'b011;
        #(10 * 1_000_000 * 6)  // #2 test 6 cycles cheking downcounting

        mode = 3'b001;
        #(10 * 1_000_000 * 2)  // #3 test 2 cycles for checking stop mode

        mode = 3'b010;
        #(10 * 1_000_000 * 2)  // #4 test 2 cycles for checking re-run function

        mode = 3'b110;
        #(10 * 1_000_000 * 2)  // #5 test 2 cycles for checking clear mode

        $stop; 
    end


endmodule


module tb_datapath_10000;
    reg clk;
    reg reset;
    reg [2:0] mode;
    wire [13:0] counter;

    // Instantiation
    datapath_10000 DUT (
        .clk    (clk),
        .reset  (reset),
        .mode   (mode),
        .counter(counter)
    );

    // clock generation
    always #5 clk = ~clk;

    // vector excitation
    initial begin
        clk   = 0;
        reset = 1;
        #10 reset = 0;

        mode = 3'b010;
        #(10 * 1_000_000 * 10)  // #1 test 10 cycles cheking upcounting

        mode = 3'b011;
        #(10 * 1_000_000 * 20)  // #2 test 20 cycles cheking downcounting

        mode = 3'b001;
        #(10 * 1_000_000 * 10)  // #3 test 10 cycles for checking stop mode

        mode = 3'b010;
        #(10 * 1_000_000 * 5)  // #4 test 5 cycles for checking re-run function

        mode = 3'b110;
        #(10 * 1_000_000 * 5)  // #5 test 5 cycles for checking clear mode

        mode = 3'b000;
        #(10 * 1_000_000 * 5)  // #6 test 5 cycles for checking clear to stop

        mode = 3'b011;
        #(10 * 1_000_000 * 5); // #7 test 5 cycles for checking downcounting

        $stop; 
    end

endmodule
