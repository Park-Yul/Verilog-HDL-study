`timescale 1ns / 1ps
module uart_controller #(
    parameter SYS_CLK = 100_000_000,
    parameter BAUD    = 9600,
    parameter DATA_WIDTH = 8
) (
    input                      clk,
    input                      reset,
    input  [DATA_WIDTH -1 : 0] tx_data,
    input                      tx_start,
    input                      rx,
    output                     tx,
    output                     tx_busy,
    output                     tx_done,
    output [DATA_WIDTH -1 : 0] rx_data,
    output                     rx_done
);

    // wire
    wire w_tick;

    // baud_tick_x16 instantiation
    baud_tick_x16 #(
        .SYS_CLK(SYS_CLK),
        .BAUD   (BAUD)
    ) U_BAUD_TICK_X16 (
        .clk(clk),
        .reset(reset),
        .o_baud_tick(w_tick)

    );

    // fsm_tx instantiation
    fsm_tx #(
        .DATA_WIDTH(DATA_WIDTH)
    ) U_FSM_TX (
        .clk(clk),
        .reset(reset),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx_baud(w_tick),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );

    // fsm_rx instantiation
    fsm_rx #(
        .DATA_WIDTH(DATA_WIDTH)
    ) U_FSM_RX (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .rx_baud(w_tick),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

endmodule

//////////

module baud_tick_x16 #(
    parameter SYS_CLK = 100_000_000,           // system clock frequency
    parameter BAUD    = 9600,                  // baud rate
    parameter F_COUNT = SYS_CLK / (BAUD * 16)
) (
    input clk,
    input reset,
    output reg o_baud_tick

);
    // register
    reg [$clog2(F_COUNT) - 1 : 0] reg_counter_tick;


    // sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_counter_tick <= 0;
            o_baud_tick <= 1'b0;
        end else begin
            if (reg_counter_tick == F_COUNT - 1) begin
                reg_counter_tick <= 0;
                o_baud_tick <= 1'b1;
            end else begin
                reg_counter_tick <= reg_counter_tick + 1;
                o_baud_tick <= 1'b0;
            end
        end
    end
endmodule

//////////

module fsm_tx #(
    parameter DATA_WIDTH = 8
) (
    input clk,
    input reset,
    input [DATA_WIDTH - 1 : 0] tx_data,
    input tx_start,
    input tx_baud,
    output tx,
    output tx_busy,
    output tx_done
);
    // state parameter
    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;

    // register
    reg [1:0] n_state, c_state;
    reg [DATA_WIDTH - 1 : 0] data_next, data_reg;
    reg tx_next, tx_reg;
    reg [$clog2(DATA_WIDTH) -1:0] bit_count_next, bit_count_reg;
    reg [3:0] tick_count_next, tick_count_reg;
    reg tx_busy_next, tx_busy_reg;
    reg tx_done_next, tx_done_reg;

    // assignment
    assign tx = tx_reg;
    assign tx_busy = tx_busy_reg;
    assign tx_done = tx_done_reg;

    // CL
    always @(*) begin
        n_state = c_state;
        tx_next = tx_reg;
        data_next = data_reg;
        bit_count_next = bit_count_reg;
        tick_count_next = tick_count_reg;
        tx_busy_next = tx_busy_reg;
        tx_done_next = tx_done_reg;
        case (c_state)
            IDLE: begin
                tx_next = 1;
                bit_count_next = 0;
                tx_busy_next = 0;
                tx_done_next = 0;
                if (tx_start) begin
                    n_state = START;
                    data_next = tx_data;
                    tx_busy_next = 1;
                end
            end

            START: begin
                tx_next = 0;
                if (tx_baud) begin
                    if (tick_count_reg >= 15) begin
                        n_state = DATA;
                        tick_count_next = 0;
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end

            DATA: begin
                tx_next = data_reg[0];
                if (tx_baud) begin
                    if (tick_count_reg >= 15) begin
                        if (bit_count_reg >= 7) begin
                            n_state = STOP;
                            tick_count_next = 0;
                        end else begin
                            data_next = {1'b0, data_reg[DATA_WIDTH-1:1]};
                            bit_count_next = bit_count_reg + 1;
                            tick_count_next = 0;
                        end
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end

            STOP: begin
                tx_next = 1;
                if (tx_baud) begin
                    if (tick_count_reg >= 15) begin
                        n_state = IDLE;
                        tick_count_next = 0;
                        tx_busy_next = 0;
                        tx_done_next = 1;
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end


        endcase
    end

    // SL
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            c_state        <= IDLE;
            tx_reg         <= 1;
            data_reg       <= 0;
            bit_count_reg  <= 0;
            tick_count_reg <= 0;
            tx_busy_reg    <= 0;
            tx_done_reg    <= 0;
        end else begin
            c_state        <= n_state;
            tx_reg         <= tx_next;
            data_reg       <= data_next;
            bit_count_reg  <= bit_count_next;
            tick_count_reg <= tick_count_next;
            tx_busy_reg    <= tx_busy_next;
            tx_done_reg    <= tx_done_next;
        end
    end

endmodule

//////////

module fsm_rx #(
    parameter DATA_WIDTH = 8
) (
    input clk,
    input reset,
    input rx,
    input rx_baud,
    output [DATA_WIDTH- 1 : 0] rx_data,
    output rx_done
);
    // state parameter
    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;

    // register
    reg [1:0] n_state, c_state;
    reg [DATA_WIDTH - 1 : 0] data_next, data_reg;
    reg [$clog2(DATA_WIDTH) -1 : 0] bit_count_next, bit_count_reg;
    reg [3:0] tick_count_next, tick_count_reg;
    reg rx_done_next, rx_done_reg;

    // assignment
    assign rx_data = data_reg;
    assign rx_done = rx_done_reg;

    // CL
    always @(*) begin
        n_state = c_state;
        data_next = data_reg;
        bit_count_next = bit_count_reg;
        tick_count_next = tick_count_reg;
        rx_done_next = rx_done_reg;
        case (c_state)
            IDLE: begin
                bit_count_next = 0;
                rx_done_next   = 0;
                if (rx_baud) begin
                    if (!rx) begin
                        if (tick_count_reg >= 7) begin
                            n_state = START;
                            tick_count_next = 0;
                        end else begin
                            tick_count_next = tick_count_reg + 1;
                        end
                    end else begin
                        tick_count_next = 0;
                    end
                end
            end

            START: begin
                if (rx_baud) begin
                    if (tick_count_reg >= 15) begin
                        n_state = DATA;
                        tick_count_next = 0;
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end

            DATA: begin
                if (rx_baud) begin
                    if (tick_count_reg == 0) begin
                        data_next = {rx, data_reg[DATA_WIDTH-1 : 1]};
                    end
                    if (tick_count_reg >= 15) begin
                        if (bit_count_reg >= 7) begin
                            n_state = STOP;
                            bit_count_next = 0;
                            tick_count_next = 0;
                        end else begin
                            bit_count_next  = bit_count_reg + 1;
                            tick_count_next = 0;
                        end
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end

            STOP: begin

                if (rx_baud) begin
                    if (tick_count_reg >= 7) begin
                        n_state = IDLE;
                        tick_count_next = 0;
                        rx_done_next = 1;
                    end else begin
                        tick_count_next = tick_count_reg + 1;
                    end
                end
            end
        endcase
    end

    // SL
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            c_state <= IDLE;
            data_reg <= 0;
            bit_count_reg <= 0;
            tick_count_reg <= 0;
            rx_done_reg <= 0;
        end else begin
            c_state <= n_state;
            data_reg <= data_next;
            bit_count_reg <= bit_count_next;
            tick_count_reg <= tick_count_next;
            rx_done_reg <= rx_done_next;
        end
    end
endmodule

//////////
