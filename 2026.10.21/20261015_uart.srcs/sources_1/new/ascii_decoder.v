`timescale 1ns / 1ps

module ascii_decoder(
    input clk,
    input rst,
    input rx_done,
    input [7:0] rx_data,
    output reg [3:0] fnd_data
    );

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            fnd_data <= 0;
        end else begin
            if(rx_done) begin
                case (rx_data)
                    8'h30:   fnd_data <= 4'h0;
                    8'h31:   fnd_data <= 4'h1;
                    8'h32:   fnd_data <= 4'h2;
                    8'h33:   fnd_data <= 4'h3;
                    8'h34:   fnd_data <= 4'h4;
                    8'h35:   fnd_data <= 4'h5;
                    8'h36:   fnd_data <= 4'h6;
                    8'h37:   fnd_data <= 4'h7;
                    8'h38:   fnd_data <= 4'h8;
                    8'h39:   fnd_data <= 4'h9;
                    8'h41, 8'h61:   fnd_data <= 4'hA;
                    8'h42, 8'h62:   fnd_data <= 4'hB;
                    8'h43, 8'h63:   fnd_data <= 4'hC;
                    8'h44, 8'h64:   fnd_data <= 4'hD;
                    8'h45, 8'h65:   fnd_data <= 4'hE;
                    8'h46, 8'h66:   fnd_data <= 4'hF;
                    default : fnd_data <= 4'h0;
                 endcase
            end 
        end
    end
endmodule
