`timescale 1ns / 1ps

module uart_fnd(
    input clk,
    input rst,
    input rx,
    output tx,
    output [7:0] fnd_font,
    output [3:0] fnd_com
    );

    
    wire w_rx_done;
    wire [7:0] w_rx_data;
    wire [3:0] w_fnd_data;
    
    uart_loopback U_UART_LOOPBACK (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .tx(tx),
        .rx_done(w_rx_done),
        .rx_data(w_rx_data)
    );

    ascii_decoder U_ASCII_DECODER(
        .clk(clk),
        .rst(rst),
        .rx_done(w_rx_done),
        .rx_data(w_rx_data),
        .fnd_data(w_fnd_data)
        );

    fnd_controller U_FND_CONTROLLER(
        .clk(clk),
        .rst(rst),
        .fnd_data(w_fnd_data),
        .fnd_font(fnd_font),
        .fnd_com(fnd_com)
    );

endmodule
