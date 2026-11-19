`timescale 1ns / 1ps
module top_counter_10000 (
    input clk,
    input reset,
    input btn_L,  // run_stop
    input btn_R,  // clear
    input btn_U,  // mode
    output [3:0] fnd_com,
    output [7:0] fnd_data
);

    wire [13:0] w_counter;
    wire w_run_stop, w_clear, w_mode;
    wire w_bd_runstop, w_bd_clear, w_bd_mode;

    //btn debouncer for runstop(btn_L)
    btn_debounce U_BD_RUNSTOP (
        .clk  (clk),
        .reset(reset),
        .i_btn(btn_L),
        .o_btn(w_bd_runstop)
    );

    //btn debouncer for clear(btn_R)
    btn_debounce U_BD_CLEAR (
        .clk  (clk),
        .reset(reset),
        .i_btn(btn_R),
        .o_btn(w_bd_clear)
    );


    //btn debouncer for mode(btn_U)
    btn_debounce U_BD_MODE (
        .clk  (clk),
        .reset(reset),
        .i_btn(btn_U),
        .o_btn(w_bd_mode)
    );


    control_unit U_CONTROL_UNIT (
        .clk(clk),
        .reset(reset),
        .o_run_stop(w_run_stop),
        .o_clear(w_clear),
        .o_mode(w_mode),
        .i_run_stop(w_bd_runstop),  //runstop
        .i_clear(w_bd_clear),  //clear
        .i_mode(w_bd_mode)  // mode
    );

    datapath_10000 U_DATAPATH_10000 (
        .clk       (clk),
        .reset     (reset),
        .i_run_stop(w_run_stop),
        .i_clear   (w_clear),
        .i_mode    (w_mode),
        .counter   (w_counter)
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
    input i_run_stop,
    input i_clear,
    input i_mode,
    output [13:0] counter
);

    wire w_tick;



    counter_10000 U_COUNTER_10000 (
        .clk       (clk),
        .reset     (reset),
        .i_tick    (w_tick),
        .i_run_stop(i_run_stop),
        .i_clear   (i_clear),
        .i_mode    (i_mode),
        .counter   (counter)
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
    input i_run_stop,
    input i_clear,
    input i_mode,
    output [13:0] counter
);
    reg [13:0] tick_counter_reg;
    assign counter = tick_counter_reg;

    always @(posedge clk, posedge reset) begin
        if (reset) tick_counter_reg <= 14'b0;
        else if (i_clear) tick_counter_reg <= 14'b0;
        else if (!i_run_stop) tick_counter_reg <= tick_counter_reg;
        else if (!i_mode && i_tick) begin
            tick_counter_reg <= tick_counter_reg + 1;
            if (tick_counter_reg == (10000 - 1)) begin
                tick_counter_reg <= 0;
            end
        end else if (i_mode && i_tick) begin
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
