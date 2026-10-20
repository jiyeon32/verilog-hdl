`timescale 1ns / 1ps

module tb_uart ();

    parameter BAUD_BIT_PERIOD = 100_000_000 / 9600 * 10;

    reg clk, rst, btnR;
    reg [7:0] result_data;
    wire led, tx;

    uart dut (
        .clk (clk),
        .rst (rst),
        .btnR(btnR),
        .led (led),   // tx_busy
        .tx  (tx)
    );


    always #5 clk = ~clk;

    task receive_uart();
        integer i;
        begin
            wait (~tx);
            #(BAUD_BIT_PERIOD / 2);
            //check start bit 0
            if (tx != 0) $display("error start bit error");
            for (i = 0; i < 8; i = i + 1) begin
                #(BAUD_BIT_PERIOD);
                result_data[i] = tx;
            end
            #(BAUD_BIT_PERIOD);
            if (!tx) $display("error stop bit");
        end
    endtask

    initial begin
        clk  = 0;
        rst  = 1;
        btnR = 0;
        #10 rst = 0; #10;

        // push button tx_start

        btnR = 1;
        #(10 * 100 * 10);
        btnR = 0;


        // uart tx 1frame 10bit
        //   #(BAUD_BIT_PERIOD * 10);
        // uart receive
        receive_uart();

        #100;
        // To compare result data and expected data
        if (result_data == 8'h30) $display("pass!!!");
        else $display("fail!!!");
        $stop;

    end
endmodule
