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
    output [6:0] msec,
    output [5:0] sec,
    output [5:0] min,
    output [4:0] hour
);

    wire w_tick_10ms;

    watch_counter #(
        .BIT_WIDTH(7),
        .TIMES(100),
        .default_value(0)

    ) U_WATCH_MSEC_COUNTER(
        .clk(clk),
        .reset(reset),
        .i_tick(w_tick_10ms),
        .inc(),
        .dec(),
        .o_tick(),
        .time_count()
    );

    tick_gen_100hz U__WATCH_TICK_GEN_100HZ(
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