`timescale 1ns / 1ps
module uart (
    input clk,
    input rst,
    input btnR,
    input rx,
    output led, // tx_busy
    output tx
);

wire w_b_tick, w_tx_start;

button_debounce U_BD_TX_START(
        .clk(clk),
        .reset(rst),
        .i_btn(btnR),
        .o_btn(w_tx_start)
);

uart_rx U_UART_RX(
        .clk(clk),
        .rst(rst),
        .b_tick(w_b_tick),
        .rx(rx),
        .rx_data(),
        .rx_done()
    );


uart_tx U_UART_TX(
    .clk(clk),
    .rst(rst),
    .tx_start(w_tx_start),
    .tx_data(8'h30),
    .b_tick(w_b_tick),
    .tx(tx),
    .tx_busy(led)
);

baud_tick_gen U_BAUD_TICK_GEN(
    .clk(clk),
    .rst(rst),
    .b_tick(w_b_tick)
);

endmodule

module baud_tick_gen(
    input clk,
    input rst,
    output reg b_tick
);

    // 100Mhz -> 9600hz + 16
    parameter F_COUNT = 100_000_000 / (9600 *16);
    reg [$clog2(F_COUNT)-1:0] counter_reg;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            counter_reg <=0;
            b_tick <=1'b0;
        end else begin
            counter_reg <=counter_reg + 1;

            if(counter_reg == F_COUNT-1) begin
                counter_reg <= 0;
                b_tick <=1'b1;
            end else begin
                b_tick <= 1'b0;
            end
        end
    end
endmodule