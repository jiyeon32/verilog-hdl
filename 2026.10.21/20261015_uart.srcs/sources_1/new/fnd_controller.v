`timescale 1ns / 1ps
/*
module fnd_controller(
    input clk,
    input rst,
    input [3:0] fnd_data,
    output [7:0] fnd_font,
    output [3:0] fnd_com
    );

    assign fnd_com = 4'b1110;

    bcd U_BCD (
    .bin(fnd_data),
    .fnd_font(fnd_font)
);
endmodule

module bcd(
    input [3:0] bin,
    output reg [7:0] fnd_font
);
        always @(bin) begin
            case (bin)
                4'h0 : fnd_font = 8'hc0;
                4'h1 : fnd_font = 8'hf9;
                4'h2 : fnd_font = 8'ha4;
                4'h3 : fnd_font = 8'hb0;
                4'h4 : fnd_font = 8'h99;
                4'h5 : fnd_font = 8'h92;
                4'h6 : fnd_font = 8'h82;
                4'h7 : fnd_font = 8'hf8;
                4'h8 : fnd_font = 8'h80;
                4'h9 : fnd_font = 8'h90;
                4'hA : fnd_font = 8'h88;
                4'hB : fnd_font = 8'h83;
                4'hC : fnd_font = 8'hc6;
                4'hD : fnd_font = 8'ha1;
                4'hE : fnd_font = 8'h86;
                4'hF : fnd_font = 8'h8e;
                default : fnd_font = 8'hc0;     
            endcase
        end

endmodule*/

module fnd_controller(
    input clk,
    input rst,
    input [3:0] fnd_data,
    output [7:0] fnd_font,
    output [3:0] fnd_com
    );

    assign fnd_com = 4'b1110;

    bcd U_BCD (
    .bin(fnd_data),
    .fnd_font(fnd_font)
);
endmodule

module bcd(
    input [3:0] bin,
    output reg [7:0] fnd_font
);
        always @(bin) begin
            case (bin)
                4'h0 : fnd_font = 8'hc0;
                4'h1 : fnd_font = 8'hf9;
                4'h2 : fnd_font = 8'ha4;
                4'h3 : fnd_font = 8'hb0;
                4'h4 : fnd_font = 8'h99;
                4'h5 : fnd_font = 8'h92;
                4'h6 : fnd_font = 8'h82;
                4'h7 : fnd_font = 8'hf8;
                4'h8 : fnd_font = 8'h80;
                4'h9 : fnd_font = 8'h90;
                4'hA : fnd_font = 8'h88;
                4'hB : fnd_font = 8'h83;
                4'hC : fnd_font = 8'hc6;
                4'hD : fnd_font = 8'ha1;
                4'hE : fnd_font = 8'h86;
                4'hF : fnd_font = 8'h8e;
                default : fnd_font = 8'hc0;     
            endcase
        end

endmodule
