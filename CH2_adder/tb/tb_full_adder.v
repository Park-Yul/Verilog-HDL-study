`timescale 1ns / 1ps
module tb_full_adder;
    reg a, b, cin;
    wire s, c;

    full_adder DUT (
        .a  (a),
        .b  (b),
        .cin(cin),
        .s  (s),
        .c  (c)
    );

    integer i, j, k;

    initial begin
        for (i=0;i<2;i=i+1)begin
            for (j=0;j<2;j=j+1)begin
                for (k=0;k<2;k=k+1) begin
                    a = i;
                    b = j;
                    cin = k;
                    #10;
                end
            end
        end
        $stop;

    end


    //initial begin
        //a   = 0;
        //b   = 0;
        //cin = 0;
//
        //#10;
        //a   = 0;
        //b   = 1;
        //cin = 0;
//
        //#10;
        //a   = 1;
        //b   = 0;
        //cin = 0;
//
        //#10;
        //a   = 1;
        //b   = 1;
        //cin = 0;
//
        //#10;
        //a   = 0;
        //b   = 0;
        //cin = 1;
//
        //#10;
        //a   = 0;
        //b   = 1;
        //cin = 1;
//
        //#10;
        //a   = 1;
        //b   = 0;
        //cin = 1;
//
        //#10;
        //a   = 1;
        //b   = 1;
        //cin = 1;

        //#10;
        //$stop;      // simulation pausing
        // $finish  // simulation ending
    //end


endmodule
