`timescale 1ns / 1ps
module tb_uart_controller #(
    parameter SYS_CLK = 100_000_000,
    parameter BAUD    = 9600,
    parameter DATA_WIDTH = 8
);
    reg                         clk;
    reg                         reset;
    reg     [DATA_WIDTH -1 : 0] tx_data;
    reg                         tx_start;
    reg                         rx;
    wire                        tx;
    wire                        tx_busy;
    wire                        tx_done;
    wire    [DATA_WIDTH -1 : 0] rx_data;
    wire                        rx_done;

    // integer
    integer                     i = 0;

    // delay parameter  
    parameter ns_10 = 10;
    parameter BAUD_DELAY = (SYS_CLK / BAUD) * 10;

    // DUT instantiation
    uart_controller #(
        .SYS_CLK   (SYS_CLK),
        .BAUD      (BAUD),
        .DATA_WIDTH(DATA_WIDTH)
    ) DUT (
        .clk(clk),
        .reset(reset),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .rx(rx),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // clock generation
    always #5 clk = ~clk;

    // task : uart tx start
    task UART_TX_START_TASK(input [DATA_WIDTH -1 : 0] i_data);
        begin
            // uart TX
            @(negedge clk);
            tx_start = 1;
            tx_data  = i_data;
            @(negedge clk);
            tx_start = 0;
            wait (DUT.U_FSM_TX.tx_done);
        end
    endtask

    task SENDER_FOR_UART_RX(input [DATA_WIDTH -1 : 0] send_data);
        begin
            // START
            rx = 0;
            #(BAUD_DELAY);

            // DATA
            for (i = 0; i < 8; i = i + 1) begin
                rx = send_data[i];
                #(BAUD_DELAY);
            end

            // STOP
            rx = 1;
            #(BAUD_DELAY);
        end
    endtask


    // scenario
    initial begin
        clk = 0;
        reset = 1;
        tx_data = 0;
        tx_start = 0;
        rx = 1;
        #ns_10;

        reset = 0;
        #ns_10;

        // simulation for UART_TX
        UART_TX_START_TASK(8'h30);
        UART_TX_START_TASK(8'h31);

        // simulation for UART_RX
        SENDER_FOR_UART_RX(8'h32);
        SENDER_FOR_UART_RX(8'h33);

        #100;
        $stop;
    end
endmodule
