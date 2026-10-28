`timescale 1ns / 1ps

module sr04_controller (
    input        clk,
    input        rst,
    input        sr04_start,
    input        echo,
    output       trig,
    output [8:0] distance,
    output       busy,
    output       done
);

    wire o_tick;

    tick_gen #(
        .FREQUENCY(1000000)
    ) U_TICK_GEN_1US (
        .clk(clk),
        .rst(rst),
        .run_stop(1'b1),
        .clear(1'b0),
        .o_tick(o_tick)
    );

endmodule

module sr04_control_unit (
    input clk,
    input rst,
    input start,
    input us_tick,
    input echo,
    output enable,
    output clear,
    output trig,
    output [8:0] distance,
    output busy,
    output reg done
);

    localparam  IDLE = 0, START = 1, WAIT = 2, DISTANCE = 3, STOP = 4;
    reg [2:0] n_state, c_state;

    reg [15:0] us_tick_reg;
    reg [ 8:0] distance_reg;

    assign trig = (c_state == START) ? 1'b1 : 1'b0;
    assign busy = (c_state != IDLE) ? 1'b1 : 1'b0;
    assign distance = distance_reg;


    // state register
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            c_state <= IDLE;
            distance_reg <= 1'b0;
        end else begin
            c_state <= n_state;
            distance_reg <= distance_reg / 58;
        end

    end

    // next
    always @(*) begin
        n_state = c_state;
        done = 1'b0;
        case (c_state)
            IDLE: begin
                if (start) begin
                    n_state = START;
                end
            end

            START: begin
                if (us_tick_reg == 10) begin
                    n_state = WAIT;
                end
            end

            WAIT: begin
                if (echo) begin
                    n_state = DISTANCE;
                end
            end

            DISTANCE: begin
                if (~echo) begin
                    n_state = STOP;
                    done = 1'b1;
                end
            end

            STOP: begin
                if (us_tick_reg == 10_000) begin
                    n_state = IDLE;
                end
            end
            default: n_state = IDLE;
        endcase
    end

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            us_tick_reg <= 0;
        end else if (c_state != n_state) begin
            us_tick_reg <= 0;
        end else if (us_tick) begin
            us_tick_reg <= us_tick_reg + 1;
        end
    end

endmodule

