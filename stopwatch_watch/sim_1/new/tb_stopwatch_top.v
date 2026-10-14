`timescale 1ns / 1ps


 module tb_stopwatch_top();
    // BD_PUSH_TINE = 10clk * 1mhz
    parameter BD_PUSH_TIME = 10*100;
    parameter MSEC = 100_000 * 10;

    reg clk, reset, btnL, btnR, btnU;
    reg sw_display_mode;
    wire [3:0] fnd_com;
    wire [7:0] fnd_font;

    stopwatch dut(
        .clk(clk),
        .reset(reset),
        .btnR(btnR),
        .btnL(btnL),
        .btnU(btnU),
        .sw_display_mode(sw_display_mode),
        .fnd_com(fnd_com),
        .fnd_font(fnd_font)
    );




    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        btnU = 0;
        btnR = 0;
        btnL = 0;
        sw_display_mode = 0;
        #10;
        reset = 0;

        // senario 0 : runstop btn 1 push / pop
        btnR = 1;
        repeat(BD_PUSH_TIME) @(posedge clk);
        btnR = 0;

        // run 1sec
        repeat(100) begin
            #(MSEC*10);
        end

        #(MSEC);

        // to change of fnd display mode : sec_msec -> hour_min
        sw_display_mode = 1'b1;

        // run 100msec
        repeat(10) begin
            #(MSEC*10);
        end

        #(10 * MSEC);

        // to change of fnd display mode : hour_min -> sec_msec
        sw_display_mode = 1'b0;

        #(MSEC);


        // run to stop state
        btnR = 1;
        repeat(BD_PUSH_TIME) @(posedge clk);
        btnR = 0;
        // stop state

        // clear

        // mode down

        //run 

        //mode change

        //stop

        $stop;
    end
endmodule
        

