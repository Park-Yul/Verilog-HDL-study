`timescale 1ns / 1ps
// `define BIT_4
module adder(
    input   [7:0] a, b,
    output  [7:0] s,
    output  c
);
    wire c1;

    full_adder_4bit FA4_0 (
        .a  (a[3:0]),
        .b  (b[3:0]),
        .cin(1'b0),
        .s  (s[3:0]),
        .c  (c1)
    );

    full_adder_4bit FA4_1 (
        .a  (a[7:4]),
        .b  (b[7:4]),
        .cin(c1),
        .s  (s[7:4]),
        .c  (c)
    );

endmodule

module full_adder_4bit (
    input   [3:0] a, b,
    `ifndef BIT_4
    input   cin,
    `endif
    output  [3:0] s,
    output  c
);
    

    wire c1, c2, c3;

    full_adder FA0 (
        .a  (a[0]),
        .b  (b[0]),
        `ifdef BIT_4
        .cin(1'b0),
        `else
        .cin(cin),
        `endif
        .s  (s[0]),
        .c  (c1)
    );

    full_adder FA1 (
        .a  (a[1]),
        .b  (b[1]),
        .cin(c1),
        .s  (s[1]),
        .c  (c2)
    );

    full_adder FA2 (
        .a  (a[2]),
        .b  (b[2]),
        .cin(c2),
        .s  (s[2]),
        .c  (c3)
    );

    full_adder FA3 (
        .a  (a[3]),
        .b  (b[3]),
        .cin(c3),
        .s  (s[3]),
        .c  (c)
    );


endmodule

module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire s,
    output wire c
);
    wire s1, c1, c2;

    half_adder HA1 (
        .a(a),
        .b(b),
        .s(s1),
        .c(c1)
    );

    half_adder HA2 (
        .a(s1),
        .b(cin),
        .s(s),
        .c(c2)
    );
    assign c = c1 | c2;

endmodule

module half_adder (
    input  wire a,
    input  wire b,
    output wire s,
    output wire c
);

    // assign c = a & b;
    // assign s = a ^ b;

    xor U0 (s, a, b);
    and (c, a, b);

endmodule

// ctrl + shift + p -> SystemVerilog Formatter - Format this file
// alt + up-down dirction key -> we can modify the location of the code selected