`timescale 1ns / 1ps

module tb_sr04 ();
    reg clk, rst, sr04_start, echo;
    wire trig;

    top_sr04 dut (
        .clk(clk),
        .rst(rst),
        .sr04_start(sr04_start),
        .echo (echo),
        .trig (trig)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        sr04_start = 0;
        echo = 0;

        #10;
        rst = 0;
        #10;

        //sr04 start
        @(negedge clk);
        sr04_start = 1;
        @(negedge clk);

        // monitor, sr04 trigger
        @(posedge trig);
        @(negedge trig);
    
        #(2000);

        echo = 1;
        #(6000*1_000); // 10cm, 600*1usec

        echo = 0;

        #(10_000_000);
        #(2000);
        $finish;

    end
endmodule
