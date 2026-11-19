`timescale 1ns / 1ps
module non_overlap_detector_0101_moore (
    input clk,
    input reset,
    input x,
    output reg z
);
    // state parameter
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    // register
    reg [2:0] c_state;
    reg [2:0] n_state;

    // Sequential Logic for c_state
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            c_state <= S0;
        end else begin
            c_state <= n_state;
        end
    end

    // Combinational Logic for n_state
    always @(x or c_state) begin
        n_state = c_state;  // initialization for avoiding latch
        case (c_state)
            S0: begin
                if (x == 0) n_state = S1;
                else if (x == 1) n_state = S0;
            end
            S1: begin
                if (x == 0) n_state = S1;
                else if (x == 1) n_state = S2;
            end
            S2: begin
                if (x == 0) n_state = S3;
                else if (x == 1) n_state = S0;
            end
            S3: begin
                if (x == 0) n_state = S1;
                else if (x == 1) n_state = S4;
            end
            S4: begin
                if (x == 0) n_state = S1;
                else if (x == 1) n_state = S0;
            end
        endcase
    end

    // Combinational Logic for output z
    always @(c_state) begin
        z = 0;  // initialization for avoiding latch
        case (c_state)
            S0: z = 0;
            S1: z = 0;
            S2: z = 0;
            S3: z = 0;
            S4: z = 1;
        endcase
    end

endmodule

///////////////////////////////////////////////////////////////////////////////

module non_overlap_detector_0101_mealy (
    input clk,
    input reset,
    input x,
    output reg z
);
    // state parameter
    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;

    // register
    reg [1:0] c_state;
    reg [1:0] n_state;

    // Sequential Logic for c_state
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            c_state <= S0;
        end else begin
            c_state <= n_state;
        end
    end

    // Combinational Logic for n_state
    always @(x or c_state) begin
        n_state = c_state;  // initialization for avoiding latch
        case (c_state)
            S0: begin
                if (x == 0) n_state = S1;
                else if (x == 1) n_state = S0;
            end
            S1: begin
                if (x == 0) n_state = S1;
                else if (x == 1) n_state = S2;
            end
            S2: begin
                if (x == 0) n_state = S3;
                else if (x == 1) n_state = S0;
            end
            S3: begin
                if (x == 0) n_state = S1;
                else if (x == 1) n_state = S0;
            end
        endcase
    end

    // Combinational Logic for output z
    always @(x or c_state) begin
        z = 0;  // initialization for avoiding latch
        case (c_state)
            S0: begin
                if (x == 0) z = 0;
                else if (x == 1) z = 0;
            end
            S1: begin
                if (x == 0) z = 0;
                else if (x == 1) z = 0;
            end
            S2: begin
                if (x == 0) z = 0;
                else if (x == 1) z = 0;
            end
            S3: begin
                if (x == 0) z = 0;
                else if (x == 1) z = 1;
            end
        endcase
    end

endmodule

///////////////////////////////////////////////////////////////////////////////

module overlap_detector_0101_moore (
    input clk,
    input reset,
    input x,
    output reg z
);
    // state parameter
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    // register
    reg [2:0] c_state;
    reg [2:0] n_state;

    // Sequential Logic for c_state
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            c_state <= S0;
        end else begin
            c_state <= n_state;
        end
    end

    // Combinational Logic for n_state
    always @(x or c_state) begin
        n_state = c_state;  // initialization for avoiding latch
        case (c_state)
            S0: begin
                if (x == 0) n_state = S1;
                else if (x == 1) n_state = S0;
            end
            S1: begin
                if (x == 0) n_state = S1;
                else if (x == 1) n_state = S2;
            end
            S2: begin
                if (x == 0) n_state = S3;
                else if (x == 1) n_state = S0;
            end
            S3: begin
                if (x == 0) n_state = S1;
                else if (x == 1) n_state = S4;
            end
            S4: begin
                if (x == 0) n_state = S3;
                else if (x == 1) n_state = S0;
            end
        endcase
    end

    // Combinational Logic for output z
    always @(c_state) begin
        z = 0;  // initialization for avoiding latch
        case (c_state)
            S0: z = 0;
            S1: z = 0;
            S2: z = 0;
            S3: z = 0;
            S4: z = 1;
        endcase
    end

endmodule

///////////////////////////////////////////////////////////////////////////////

module overlap_detector_0101_mealy (
    input clk,
    input reset,
    input x,
    output reg z
);
    // state parameter
    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;

    // register
    reg [1:0] c_state;
    reg [1:0] n_state;

    // Sequential Logic for c_state
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            c_state <= S0;
        end else begin
            c_state <= n_state;
        end
    end

    // Combinational Logic for n_state
    always @(x or c_state) begin
        n_state = c_state;  // initialization for avoiding latch
        case (c_state)
            S0: begin
                if (x == 0) n_state = S1;
                else if (x == 1) n_state = S0;
            end
            S1: begin
                if (x == 0) n_state = S1;
                else if (x == 1) n_state = S2;
            end
            S2: begin
                if (x == 0) n_state = S3;
                else if (x == 1) n_state = S0;
            end
            S3: begin
                if (x == 0) n_state = S1;
                else if (x == 1) n_state = S2;
            end
        endcase
    end

    // Combinational Logic for output z
    always @(x or c_state) begin
        z = 0;  // initialization for avoiding latch
        case (c_state)
            S0: begin
                if (x == 0) z = 0;
                else if (x == 1) z = 0;
            end
            S1: begin
                if (x == 0) z = 0;
                else if (x == 1) z = 0;
            end
            S2: begin
                if (x == 0) z = 0;
                else if (x == 1) z = 0;
            end
            S3: begin
                if (x == 0) z = 0;
                else if (x == 1) z = 1;
            end
        endcase
    end

endmodule

///////////////////////////////////////////////////////////////////////////////