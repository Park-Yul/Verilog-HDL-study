`timescale 1ns / 1ps
module control_unit (
    input clk,
    input reset,
    input i_run_stop,
    input i_clear,
    input i_mode,
    output o_run_stop,  //btnL
    output o_clear,  //btnR
    output o_mode  // btnU
);

    // state parameter
    parameter STOP = 0, RUN = 1, CLEAR = 2, MODE = 3;

    // register
    reg [1:0] c_state;
    reg [1:0] n_state;
    reg run_stop_reg, run_stop_next, clear_reg, clear_next, mode_reg, mode_next;
    //
    //    // output assign
    //    assign {o_run_stop, o_clear, o_mode} = (c_state == STOP) ? 3'b000 :
    //                                            (c_state == RUN) ? 3'b100 :
    //                                            (c_state == CLEAR) ? 3'b010:
    //                                            (c_state ==MODE) ? 3'b000: 3'b000;
    //


    // output assign
    assign {o_run_stop, o_clear, o_mode} = {run_stop_reg, clear_reg, mode_reg};


    // c_state(Sequential Logic)
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            c_state <= 0;
        end else begin
            c_state <= n_state;
        end
    end

    // n_state(Combinational Logic)
    always @(c_state or {i_run_stop,
        i_clear,
        i_mode
    })
    begin
        n_state = c_state;
        case (c_state)
            STOP: begin
                if (i_run_stop) n_state = RUN;
                else if (i_clear) n_state = CLEAR;
                else if (i_mode) n_state = MODE;
                else n_state = c_state;
            end
            RUN: begin
                if (i_run_stop) n_state = STOP;
                else n_state = c_state;
            end
            CLEAR: n_state = STOP;
            MODE:  n_state = STOP;
        endcase
    end

    // output reg (Sequential Logic)
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            run_stop_reg <= 1'b0;
            clear_reg <= 1'b0;
            mode_reg <= 1'b0;
        end else begin
            run_stop_reg <= run_stop_next;
            clear_reg <= clear_next;
            mode_reg <= mode_next;
        end
    end

    // output next (Combinational Logic)
    always @(c_state) begin
        run_stop_next = run_stop_reg;
        clear_next = clear_reg;
        mode_next = mode_reg;
        case (c_state)
            STOP: begin
                run_stop_next = 1'b0;
                clear_next = 1'b0;
            end
            RUN: begin
                run_stop_next = 1'b1;
                clear_next = 1'b0;
            end
            CLEAR: begin
                run_stop_next = 1'b0;
                clear_next = 1'b1;
            end
            MODE: begin
                run_stop_next = 1'b0;
                clear_next = 1'b0;
                mode_next = ~mode_reg;
            end
        endcase
    end
endmodule
