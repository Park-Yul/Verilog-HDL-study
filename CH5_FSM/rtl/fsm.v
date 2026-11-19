`timescale 1ns / 1ps
module fsm (
    input    clk,
    input   reset,
    input   [2:0]   sw,
    output  [2:0]   led
);
    // parameter declaration
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    // reg, wire declaration
    reg [2:0] current_state;
    reg [2:0] next_state;
    reg [2:0] led_reg;

    //////////// dataflow modeling ///////////////

    // output assignment
    assign led = led_reg;

    //////////// behavioral modeling ///////////////

    // Current State(Sequential Logic)
    always @(posedge clk, posedge reset) begin  // asynchronized reset
        if (reset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State(Combinational Logic)
    always @(current_state, sw) begin
        next_state = current_state; // avoiding latch
        case (current_state)
            S0:
            if (sw == 3'b001) next_state = S1;
            else if (sw == 3'b100) next_state = S4;
            else next_state = current_state;
            S1:
            if (sw == 3'b010) next_state = S2;
            else next_state = current_state;
            S2:
            if (sw == 3'b011) next_state = S3;
            else next_state = current_state;
            S3:
            if (sw == 3'b100) next_state = S4;
            else next_state = current_state;
            S4:
            if (sw == 3'b001) next_state = S1;
            else if (sw == 3'b111) next_state = S0;
            else next_state = current_state;
            default:
            next_state = current_state;  // full case for avoiding latch
        endcase
    end

    // Output(Combinational Logic)
    always @(current_state) begin
        case (current_state)
            S0: led_reg = 3'b000;
            S1: led_reg = 3'b001;
            S2: led_reg = 3'b010;
            S3: led_reg = 3'b011;
            S4: led_reg = 3'b100;
            default led_reg = 3'b111;  // full case for avoiding latch
        endcase
    end


endmodule
