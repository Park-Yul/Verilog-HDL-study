`timescale 1ns / 1ps

module tb_adder;
    reg  [7:0] a, b;
    wire [7:0] s;
    wire c;

    adder DUT (
    .a (a),
    .b (b),
    .s (s),
    .c (c)
    );

    integer i,j;

    initial begin
        for ( i = 0; i < 256; i = i + 1) begin
            for (j = 0 ; j < 256; j = j + 1) begin
                a = i;
                b = j;
                #10;
            end
        end
        $stop;

    end 
endmodule
