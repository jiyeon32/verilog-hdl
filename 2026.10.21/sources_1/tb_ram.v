`timescale 1ns / 1ps

module tb_ram();

    reg clk, we;
    reg [7:0] addr, wdata;
    wire [7:0] rdata;

    bram_ip dut(
    .clk(clk),
    .we(we),
    .addr(adder),
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
        @(posedge clk);
        we = 1;
        addr = 10;
        wdata = 8'h0a;
        @(posedge clk);
        addr = 11;
        wdata = 8'h0b;
        @(posedge clk);
        addr = 31;
        wdata = 8'h0c;
        @(posedge clk);
        addr = 32;
        wdata = 8'h0d;
        // read from ram
        @(posedge clk);
        we = 0;
        @(posedge clk);
        addr = 10;
        @(posedge clk);
        addr = 11;
        @(posedge clk);
        addr = 30;
        @(posedge clk);
        addr = 31;
        @(posedge clk);
        $stop;
    end

endmodule
