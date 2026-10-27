`timescale 1ns / 1ps

module uart_ascii_decoder (
    input clk,
    input rst,
    input rx,
    output tx,

    //fnd
    output [3:0] fnd_com,
    output [7:0] fnd_font
);

    wire w_rx_done;
    wire [7:0] w_rx_data;
    wire [3:0] w_bin;

    uart_loopback U_UART_LOOPBACK (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_done(w_rx_done),
        .rx_data(w_rx_data),
        .tx(tx)
    );

    ascii_decoder U_ASCII_DECODER(
        .clk(clk),
        .rst(rst),
        .enable(w_rx_done),
        .ascii(w_rx_data),
        .bin(w_bin)
        );

    fnd_controller U_FND_CONTROLLER(
        .clk(clk),
        .rst(rst),
        .fnd_data(w_bin),
        .fnd_font(fnd_font),
        .fnd_com(fnd_com)
    );



endmodule

module ascii_decoder(
    input clk,
    input rst,
    input enable,
    input [7:0] ascii,
    output reg [3:0] bin
);
    reg [7:0] data_reg, data_next;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            data_reg <= 0;
        end else begin
            data_reg <= data_next;
        end
    end

    always @(*) begin
        bin = 4'h0;
        data_next = data_reg;
        if(enable) begin
            data_next = ascii;
        end else begin
            case (data_reg)
                8'h30:   bin = 4'h0;
                8'h31:   bin = 4'h1;
                8'h32:   bin = 4'h2;
                8'h33:   bin = 4'h3;
                8'h34:   bin = 4'h4;
                8'h35:   bin = 4'h5;
                8'h36:   bin = 4'h6;
                8'h37:   bin = 4'h7;
                8'h38:   bin = 4'h8;
                8'h39:   bin = 4'h9;
                8'h41, 8'h61:   bin = 4'hA;
                8'h42, 8'h62:   bin = 4'hB;
                8'h43, 8'h63:   bin = 4'hC;
                8'h44, 8'h64:   bin = 4'hD;
                8'h45, 8'h65:   bin = 4'hE;
                8'h46, 8'h66:   bin = 4'hF;
            endcase
        end
    end

endmodule