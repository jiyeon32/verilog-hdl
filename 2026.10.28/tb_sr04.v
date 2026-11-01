`timescale 1ns / 1ps

module tb_sr04 ();
    reg clk, rst, sr04_start, echo, ready;
    wire trig,done,us_tick;
    wire [8:0] distance;

    sr04_controller DUT_SR04_CNTL (
        .clk(clk),
        .rst(rst),
        .sr04_start(sr04_start),
        .echo(echo),
        .us_tick(us_tick),
        .ready(ready),
        .trig(trig),
        .distance(distance),
        .done(done)
);

    tick_gen_us DUT_TICK_GEN_US (
        .clk(clk),
        .rst(rst),
        .us_tick(us_tick)
);
 always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        sr04_start = 0;
        echo = 0;
        ready = 1;

        #10;
        rst = 0;
        #10;

        
        // #1

        //sr04 start
        @(negedge clk);
        sr04_start = 1;
        @(negedge clk);
        sr04_start = 0;

        // monitor, sr04 trigger
        @(posedge trig);
        @(negedge trig);
    
        #(2000);

        echo = 1;
        #(600*1_000); // 10cm, 600*1usec

        echo = 0;
        @(posedge done);
        $display("#1 distance = %d", distance);

        wait (DUT_SR04_CNTL.c_state == 0);
        #(2000);

        // #2
        @(negedge clk);
        sr04_start = 1;
        @(negedge clk);
        sr04_start = 0;

        
        @(posedge trig);
        @(negedge trig);
    

        @(posedge done);
        $display("#2 distance = %d", distance);

        wait (DUT_SR04_CNTL.c_state == 0);
        #(2000);

        // #3
        @(negedge clk);
        sr04_start = 1;
        @(negedge clk);
        sr04_start = 0;

     
        @(posedge trig);
        @(negedge trig);
    
        #(2000);

        echo = 1;
        #(38*1_000_000);
        $display("#3 distance = %d", distance);
        echo = 0;
        wait (DUT_SR04_CNTL.c_state == 0);
        #(2000);

        //#4
        ready = 0;
        @(negedge clk);
        sr04_start = 1;
        @(negedge clk);
        sr04_start = 0;

       
        @(posedge trig);
        @(negedge trig);
    
        #(2000);

        echo = 1;
        #(800*1_000); 

        echo = 0;
        @(posedge done);
        $display("#4 distance = %d", distance);
        #(20*1_000_000);
        ready=1;

        wait (DUT_SR04_CNTL.c_state == 0);
        #(2000);
        $finish;

    end
endmodule
