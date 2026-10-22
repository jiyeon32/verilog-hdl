`timescale 1ns / 1ps

module tb_ram();

    reg clk, we;
    reg [7:0] addr, wdata;
    wire [7:0] rdata;

    bram_ip dut(
    .clk(clk),
    .we(we),
    .addr(addr),
    .wdata(wdata),
    .rdata(rdata)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        we = 0;
        addr = 0;
        wdata = 0;

        // write to ram
        @(negedge clk);
        we = 1;
        addr = 10;
        wdata = 8'h0a;

        @(negedge clk);
        addr = 11;
        wdata = 8'h0b;
    end

endmodule
