// column mode edit : ctrl + alt + direction_key

`timescale 1ns / 1ps
module tb_gates;

    reg i_a, i_b;
    wire o_y0, o_y1, o_y2, o_y3, o_y4, o_y5, o_y6;

    gates dut(
        .a (i_a),
        .b (i_b),
        .y0(o_y0),
        .y1(o_y1),
        .y2(o_y2),
        .y3(o_y3),
        .y4(o_y4),
        .y5(o_y5),
        .y6(o_y6)
    );

    initial begin
        i_a = 0;
        i_b = 0;
        
        #10;
        i_a = 0;
        i_b = 1;

        #10;
        i_a = 1;
        i_b = 0;

        #10;
        i_a = 1;
        i_b = 1;

        #10;
        $stop; // $ : system command
    end
    


endmodule
