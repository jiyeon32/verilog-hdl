`timescale 1ns / 1ps


module watch(
    input clk,
    input reset,
    input btnR,
    input btnL,
    input btnU,
    input btnD,
    output [3:0] fnd_com,
    output [7:0] fnd_font
);
endmodule

module watch_datapath (
    input clk,
    input reset,
    input inc,
    input dec,
    input [1:0] cursor,
    output [6:0] msec,
    output [5:0] sec,
    output [5:0] min,
    output [4:0] hour
);
    wire w_tick_10ms, w_tick_sec, w_tick_min, w_tick_hour;

    wire w_inc_hour = inc & (cursor == 2'b11);
    wire w_inc_min = inc & (scursor == 2'b10);
    wire w_inc_sec = inc & (scursor == 2'b01);
    wire w_inc_msec = inc & (cursor == 2'b00);
    wire w_dec_hour = dec & (cursor == 2'b11);
    wire w_dec_min = dec & (scursor == 2'b10);
    wire w_dec_sec = dec & (scursor == 2'b01);
    wire w_dec_msec = dec & (cursor == 2'b00);


    watch_counter #(
        .BIT_WIDTH(5),
        .TIMES(24),
        .default_value(12)

    ) U_WATCH_HOUR_COUNTER(
        .clk(clk),
        .reset(reset),
        .i_tick(w_tick_hour),
        .inc(w_inc_hour),
        .dec(w_dec_hour),
        .o_tick(),
        .time_count(hour)
    );


    watch_counter #(
        .BIT_WIDTH(6),
        .TIMES(60),
        .default_value(0)

    ) U_WATCH_MIN_COUNTER(
        .clk(clk),
        .reset(reset),
        .i_tick(w_tick_min),
        .inc(w_inc_min),
        .dec(w_dec_min),
        .o_tick(w_tick_hour),
        .time_count(min)
    );


    watch_counter #(
        .BIT_WIDTH(6),
        .TIMES(60),
        .default_value(0)

    ) U_WATCH_SEC_COUNTER(
        .clk(clk),
        .reset(reset),
        .i_tick(w_tick_sec),
        .inc(w_inc_sec),
        .dec(w_dec_sec),
        .o_tick(w_tick_min),
        .time_count(sec)
    );


    watch_counter #(
        .BIT_WIDTH(7),
        .TIMES(100),
        .default_value(0)

    ) U_WATCH_MSEC_COUNTER(
        .clk(clk),
        .reset(reset),
        .i_tick(w_tick_10ms),
        .inc(w_inc_msec),
        .dec(w_dec_msec),
        .o_tick(w_tick_sec),
        .time_count(msec)
    );

    tick_gen_100hz U_WATCH_TICK_GEN_100HZ(
        .clk(clk),
        .reset(reset),
        .run_stop(1'b1),
        .clear(1'b0),
        .o_tick(w_tick_10ms)
    );

endmodule

module watch_counter #(
    parameter BIT_WIDTH = 7,
    parameter TIMES = 100,
    parameter default_value = 0 //시작값
)(
    input clk,
    input reset,
    input i_tick,
    input inc, //증가
    input dec, //감소
    output reg o_tick,
    output [BIT_WIDTH-1:0] time_count
);


    reg [BIT_WIDTH-1:0] counter_reg;

    assign time_count = counter_reg;
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            counter_reg <= default_value;
            o_tick <= 1'b0;
        end else begin
            o_tick <= 1'b0;
            if(i_tick) begin
                if(counter_reg == TIMES-1) begin
                    counter_reg <= 0;
                    o_tick <= 1'b1;
                end else begin
                    counter_reg <= counter_reg + 1;
                end                                
            end else if(inc) begin
                if(counter_reg == TIMES-1) begin
                    counter_reg <= 0;
                end else begin
                    counter_reg <= counter_reg + 1;
                end                                 
            end else if(dec) begin
                if(counter_reg == 0) begin         
                    counter_reg <= TIMES-1;         
                end else begin
                    counter_reg <= counter_reg - 1;
                end
            end
        end
    end
endmodule