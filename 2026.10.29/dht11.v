`timescale 1ns / 1ps

module top_dht11 (
    input        clk,
    input        rst,
    input        btnR,
    output [3:0] fnd_com,
    output [7:0] fnd_font,
    inout        dht11_io
);

    wire w_dht11_start, w_us_tick;
    
    button_debounce U_BUTTON_START (
        .clk    (clk),
        .reset(rst),
        .i_btn(btnR),
        .o_btn(w_dht11_start)
    );

    tick_gen_us U_TICK_GEN_US (
        .clk    (clk),
        .rst    (rst),
        .us_tick(w_us_tick)
    );

    dht11_controller U_DHT11_CONTROLLER(
        .clk        (clk),
        .rst        (rst),
        .dht11_start(w_dht11_start),  // start trigger
        .us_tick(w_us_tick),
        .valid(),  // chech sum ok
        .humidity(),
        .temperature(),
        .dht11_io(dht11_io)  // single wire, for half duplexing
    );


endmodule

module dht11_controller (
    input         clk,
    input         rst,
    input         dht11_start,  // start trigger
    input         us_tick,
    output        valid,        // chech sum ok
    output [15:0] humidity,
    output [15:0] temperature,
    inout         dht11_io      // single wire, for half duplexing
);

    localparam IDLE = 0, START = 1, WAIT = 2, SYNC_L = 3, SYNC_H = 4;
    localparam DATA_SYNC = 5, BIT = 6, STOP = 10;

    reg [3:0] c_state, n_state;
    reg dht11_io_control_reg, dht11_io_control_next;
    reg dht11_io_reg, dht11_io_next;
    reg [$clog2(19_000)-1:0] tick_cnt_reg, tick_cnt_next;
    reg [5:0] bit_cnt_reg, bit_cnt_next;
    reg [39:0] data_reg, data_next;


    // output control by 3 state buffer
    assign dht11_io = (dht11_io_control_reg) ? dht11_io_reg : 1'bz;
    // valid = check sum ok & data_reg != 0
    assign valid = ( (data_reg[39:32]+data_reg[31:24]+data_reg[23:16]+data_reg[15:8]) == data_reg[7:0]);
    assign humidity = ((c_state == IDLE) & (valid)) ? data_reg[39:24] : 0;
    assign temperature = ((c_state == IDLE) & (valid)) ? data_reg[23:8] : 0;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            c_state              <= IDLE;
            dht11_io_control_reg <= 1'b1;
            dht11_io_reg         <= 1'b1;
            tick_cnt_reg         <= 0;
            bit_cnt_reg          <= 0;
            data_reg             <= 0;
        end else begin
            c_state              <= n_state;
            dht11_io_control_reg <= dht11_io_control_next;
            dht11_io_reg         <= dht11_io_next;
            tick_cnt_reg         <= tick_cnt_next;
            bit_cnt_reg          <= bit_cnt_next;
            data_reg             <= data_next;
        end

    end

    // next, output
    always @(*) begin
        n_state               = c_state;
        dht11_io_control_next = dht11_io_control_reg;
        dht11_io_next         = dht11_io_reg;
        tick_cnt_next         = tick_cnt_reg;
        bit_cnt_next          = bit_cnt_reg;
        data_next             = data_reg;
        case (c_state)
            IDLE: begin
                dht11_io_next = 1'b1;
                dht11_io_control_next = 1'b1;
                if (dht11_start) begin
                    tick_cnt_next = 0;
                    bit_cnt_next  = 0;
                    data_next     = 0;
                    n_state       = START;
                end
            end

            START: begin
                dht11_io_next = 1'b0;
                dht11_io_control_next = 1'b1;
                if (us_tick) begin
                    if (tick_cnt_reg == 19_000 - 1) begin
                        tick_cnt_next = 0;
                        n_state = WAIT;
                    end else begin
                        tick_cnt_next = tick_cnt_reg + 1;
                    end
                end
            end

            WAIT: begin
                dht11_io_next = 1'b1;
                if (us_tick) begin
                    if (tick_cnt_reg == 30 - 1) begin
                        tick_cnt_next = 0;
                        // tochange output to high impedence
                        dht11_io_control_next = 1'b0;
                        n_state = SYNC_L;
                    end else begin
                        tick_cnt_next = tick_cnt_reg + 1;
                    end
                end
            end

            SYNC_L: begin
                if (us_tick) begin
                    if (tick_cnt_reg > 30) begin
                        if (dht11_io) begin
                            tick_cnt_next = 0;
                            n_state = SYNC_H;
                        end
                    end else begin
                        tick_cnt_next = tick_cnt_reg + 1;
                    end
                end
            end

            SYNC_H: begin
                if (us_tick) begin
                    if (tick_cnt_reg > 30) begin
                        if (!dht11_io) begin
                            tick_cnt_next = 0;
                            n_state = DATA_SYNC;
                        end
                    end else begin
                        tick_cnt_next = tick_cnt_reg + 1;
                    end
                end
            end

            DATA_SYNC: begin
                if (us_tick) begin
                    if (dht11_io) begin
                        tick_cnt_next = 0;
                        n_state       = BIT;
                    end
                end
            end

            BIT: begin
                if (us_tick) begin
                    if (!dht11_io) begin
                        if (tick_cnt_reg >= 40) begin
                            data_next = {data_reg[38:0], 1'b1};
                        end else begin
                            data_next = {data_reg[38:0], 1'b0};
                        end
                        if (bit_cnt_reg == 39) begin
                            tick_cnt_next = 0;
                            n_state       = STOP;
                        end else begin
                            n_state = DATA_SYNC;
                            bit_cnt_next = bit_cnt_reg + 1;
                        end
                    end else begin
                        tick_cnt_next = tick_cnt_reg + 1;
                    end
                end
            end

            STOP: begin
                if (us_tick) begin
                    if (tick_cnt_reg == 60 - 1) begin
                        tick_cnt_next = 0;
                        // change output to high impedence
                        dht11_io_control_next = 1'b1;
                        n_state = IDLE;
                    end else begin
                        tick_cnt_next = tick_cnt_reg + 1;
                    end
                end
            end
        endcase

    end


endmodule

module tick_gen_us (
    input clk,
    input rst,
    output reg us_tick
);

    parameter FREQ = 100_000_000 / 1_000_000;
    reg [$clog2(FREQ)-1:0] counter_reg;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            counter_reg <= 0;
            us_tick     <= 0;
        end else begin
            counter_reg <= counter_reg + 1;

            if (counter_reg == (FREQ - 1)) begin
                counter_reg <= 0;
                us_tick <= 1'b1;
            end else begin
                us_tick <= 1'b0;
            end
        end
    end
endmodule
