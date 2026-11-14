`timescale 1ns / 1ps
module tb_half_adder;
    reg a;
    reg b;
    wire s;
    wire c;

    half_adder DUT (
        .a(a),
        .b(b),
        .s(s),
        .c(c)
    );

    integer i,j;

    initial begin
        for (i=0;i<2;i=i+1) begin
            for (j=0;j<2;j=j+1)begin
                a = i;
                b = j;
                #10;
            end
        end
        $stop;
    end


endmodule
