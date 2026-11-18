`timescale 1ns / 1ps
module top_counter_10000 (
    input clk,
    input reset,
    input [2:0] mode,
    output [3:0] fnd_com,
    output [7:0] fnd_data
);

    wire [13:0] w_counter;

    datapath_10000 U_DATAPATH_10000 (
        .clk    (clk),
        .reset  (reset),
        .mode   (mode),
        .counter(w_counter)
    );

    fnd_controller U_FND_CNTL (
        .clk     (clk),
        .reset   (reset),
        .fnd_in  (w_counter),
        .fnd_com (fnd_com),
        .fnd_data(fnd_data)
    );



endmodule

module datapath_10000 (
    input clk,
    input reset,
    input [2:0] mode,
    output [13:0] counter
);

    wire w_tick;



    counter_10000 U_COUNTER_10000 (
        .clk    (clk),
        .reset  (reset),
        .i_tick (w_tick),
        .mode   (mode),
        .counter(counter)
    );

    tick_gen U_TICK_GEN (
        .clk  (clk),
        .reset(reset),
        .tick (w_tick)
    );

endmodule



module counter_10000 (
    input clk,
    input reset,
    input i_tick,
    input [2:0] mode,
    output [13:0] counter
);
    reg [13:0] tick_counter_reg;
    assign counter = tick_counter_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) tick_counter_reg <= 14'b0;
        else if (mode[2]) tick_counter_reg <= 14'b0;
        else if (!mode[1]) tick_counter_reg <= tick_counter_reg;
        else if (!mode[0] && i_tick) begin
            tick_counter_reg <= tick_counter_reg + 1;
            if (tick_counter_reg == (10000 - 1)) begin
                tick_counter_reg <= 0;
            end
        end else if (mode[0] && i_tick) begin
            tick_counter_reg <= tick_counter_reg - 1;
            if (tick_counter_reg == 0) begin
                tick_counter_reg <= (10000 - 1);
            end
        end
    end


    //always @(posedge clk, posedge reset) begin
    //    if (reset) begin
    //        tick_counter_reg <= 0;
    //    end else begin
    //        if (i_tick) begin
    //            tick_counter_reg <= tick_counter_reg + 1;
    //        end
    //        if (tick_counter_reg == (10000 - 1)) begin
    //            tick_counter_reg <= 0;
    //        end
    //    end
    //
    //end
endmodule

module tick_gen (
    input  clk,
    input  reset,
    output tick
);
    reg [$clog2(1_000_000)-1:0] counter_reg;
    reg tick_reg;
    assign tick = tick_reg;
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_reg <= 0;
            tick_reg    <= 0;
        end else begin
            counter_reg <= counter_reg + 1;
            if (counter_reg == 1_000_000 - 1) begin
                counter_reg <= 0;
                tick_reg <= 1'b1;
            end else begin
                tick_reg <= 1'b0;
            end
        end
    end

endmodule
