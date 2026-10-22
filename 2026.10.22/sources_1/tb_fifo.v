`timescale 1ns / 1ps

module tb_fifo ();

    reg clk, rst, push, pop;
    reg  [7:0] push_data;
    wire [7:0] pop_data;
    wire full, empty;

    integer i;

    fifo dut (
        .clk      (clk),
        .rst      (rst),
        .push     (push),
        .pop      (pop),
        .push_data(push_data),
        .pop_data (pop_data),
        .full     (full),
        .empty    (empty)
    );

    always #5 clk = ~clk;


    /*
        // 시나리오1
    initial begin
        clk       = 0;
        rst       = 1;
        push      = 0;
        pop       = 0;
        push_data = 0;
        @(negedge clk);
        @(negedge clk);

        rst = 0;
        @(negedge clk);
        if(full == 0) begin
            $display("%t : pass full signal", $stime);
        end else begin
            $display("%t : fail full signal", $time);
        end

        if(empty == 1) begin
            $display("%t : pass empty signal", $time);
        end else begin
            $display("%t : fail empty signal", $time);
        end

        #10;
        $finish;
    end*/

    //push only

     initial begin
        clk       = 0;
        rst       = 1;
        push      = 0;
        pop       = 0;
        push_data = 0;
        i = 0;
        @(negedge clk);
        @(negedge clk);

        rst = 0;
        @(negedge clk);
        if(full == 0) begin
            $display("%t : pass full signal", $stime);
        end else begin
            $display("%t : fail full signal", $time);
        end

        if(empty == 1) begin
            $display("%t : pass empty signal", $time);
        end else begin
            $display("%t : fail empty signal", $time);
        end

        for (i = 0; i<5; i = i+1) begin
             @(negedge clk);
             push_data = 8'h0a + i;
             push = 1'b1;
        end 
        @(negedge clk);
        push = 1'b0;
        #10;
        $finish;
    end


endmodule
