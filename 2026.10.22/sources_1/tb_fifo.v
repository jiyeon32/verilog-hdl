`timescale 1ns / 1ps

module tb_fifo ();

    parameter DEPTH = 4;

    reg clk, rst, push, pop;
    reg  [7:0] push_data;
    wire [7:0] pop_data;
    wire full, empty;

    reg [7:0] compare_buffer[0:DEPTH-1];
    integer i, pass_cnt, fail_cnt;
    reg [1:0] push_cnt, pop_cnt;

    fifo #(
        .DEPTH(DEPTH)
    ) dut (
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

    initial begin
        clk       = 0;
        rst       = 1;
        push      = 0;
        pop       = 0;
        push_data = 0;
        i         = 0;
        pass_cnt  = 0;
        fail_cnt  = 0;
        push_cnt  = 0;
        pop_cnt   = 0;
        @(negedge clk);
        @(negedge clk);

        rst = 0;
        @(negedge clk);
        if (full == 0) begin
            $display("%t : pass full signal", $stime);
        end else begin
            $display("%t : fail full signal", $time);
        end

        if (empty == 1) begin
            $display("%t : pass empty signal", $time);
        end else begin
            $display("%t : fail empty signal", $time);
        end

        // push only, push 5 times
        for (i = 0; i < 5; i = i + 1) begin
            @(negedge clk);
            push_data = 8'h0a + i;
            push = 1'b1;
            if (!full) begin
                compare_buffer[push_cnt] = push_data;
                push_cnt = push_cnt + 1;
            end
        end

        @(negedge clk);
        push = 1'b0;

        // pop only, pop 5times
        for (i = 0; i < 5; i = i + 1) begin
            @(negedge clk);
            pop = 1'b1;
            if (!empty) begin
                if (pop_data == compare_buffer[pop_cnt]) begin
                    $display("%t : pass pop data = %d", $stime, pop_data);
                end else begin
                    $display("%t : fail pop data = %d, compare = %d", $stime,
                             pop_data, compare_buffer[pop_cnt]);
                end
                pop_cnt = pop_cnt + 1;
            end
        end

        // empty state would be '1'
        if (empty) begin
            $display("%t : pass empty signal", $stime);
        end else begin
            $display("%t : fail empty signal", $stime);
        end

        @(negedge clk);
        push = 1'b0;
        pop  = 1'b0;

        // push/pop 5times
        for (i = 0; i < 5; i = i + 1) begin
            @(negedge clk);
            push = 1'b1;
            push_data = 8'h0f - i;
            if (!full) begin
                compare_buffer[push_cnt] = push_data;
                push_cnt = push_cnt + 1;
            end
            pop = 1'b1;

            if (!empty) begin
                if (pop_data == compare_buffer[pop_cnt]) begin
                    $display("%t : pass pop data = %d", $stime, pop_data);
                end else begin
                    $display("%t : fail pop data = %d, compare = %d", $stime,
                             pop_data, compare_buffer[pop_cnt]);
                end
                pop_cnt = pop_cnt + 1;
            end
        end

        //for empty fifo
        @(negedge clk);
        push = 0;
        pop = 1;
        pop_cnt = pop_cnt + 1;
        @(negedge clk);
        pop = 0;
        @(negedge clk);

        $display("To start random test");
        // random test
        for (i = 0; i < 256; i = i + 1) begin
            @(negedge clk);
            push = $random() % 2;
            pop = $random() % 2;
            push_data = $random() % 256;

            // push 1 
            if (push & (~full)) begin
                compare_buffer[push_cnt] = push_data;
                push_cnt = push_cnt + 1;
            end

            // pop 1 
            if (pop & (~empty)) begin
                if (pop_data == compare_buffer[pop_cnt]) begin
                    pass_cnt = pass_cnt + 1;
                    $display("%t :  pass !! ", $time);
                end else begin
                    fail_cnt = fail_cnt + 1;
                    $display("%t :  fail !!! ", $time);
                end
                pop_cnt = pop_cnt + 1;
            end
        end

        #10;
        // report
        $display("*** Random test result ***");
        $display("* total random test = %4d", i);
        $display("* pass count        = %4d", pass_cnt);
        $display("* fail count        = %4d", fail_cnt);
        #10;
        $finish;
    end


endmodule

/*
        // rst
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

/*
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
    end */

/*
    // pop only
    initial begin
        clk       = 0;
        rst       = 1;
        push      = 0;
        pop       = 0;
        push_data = 0;
        i = 0;
        @(negedge clk);
        @(negedge clk);

        // 1. 리셋 확인
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

        // 2. push 4번 -> full
        for (i = 0; i<5; i = i+1) begin
             @(negedge clk);
             push_data = 8'h0a + i;
             push = 1'b1;
        end 

         @(negedge clk);
         push = 1'b0; //push 끄기

        // 3. pop 4번 -> pop하기 전에 값 비교
        for (i = 0; i<4; i = i+1) begin
            if(pop_data == 8'h0a + i) $display("%t : pass pop_data=%h", $time, pop_data);
            else $display("%t : fail pop_data=%h (exp %h)", $time, pop_data, 8'h0a + i);
            pop = 1'b1;
            @(negedge clk);
        end 
        pop = 1'b0;

        // 4. full,empty 확인
        if(full == 0 && empty == 1) $display("%t : pass empty after pop", $time);
        else $display("%t : fail full=%b empty=%b", $time, full, empty);

        #10;
        $finish;
    end */

/*
    // push/pop
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

        // 1. push 4번 → full=1 만들기
        for (i = 0; i<4; i = i+1) begin
             @(negedge clk);
             push_data = 8'h0a + i;
             push = 1'b1;
        end 

         @(negedge clk);
         push = 1'b0; //push 끄기

        // 2. full일 때 push+pop → pop only 처리 확인
            push_data = 8'h0e;
            push = 1'b1;
            pop = 1'b1;
            @(negedge clk);
            push = 1'b0;
            pop  = 1'b0;
            if (full == 0 && empty == 0 && pop_data == 8'h0b)
                $display("%t : pass 2. pop only when full (pop_data=%h)", $time, pop_data);
            else
                $display("%t : fail 2. full=%b empty=%b pop_data=%h", $time, full, empty, pop_data);


        // 3. pop 3번 → empty=1 만들기
        for (i = 0; i<3; i = i+1) begin
            if(pop_data == 8'h0b + i) $display("%t : pass 3. pop_data=%h", $time, pop_data);
            else $display("%t : fail 3. pop_data=%h (exp %h)", $time, pop_data, 8'h0a + i);
            pop = 1'b1;
            @(negedge clk);
        end 
        pop = 1'b0;

        // 4. empty일 때 push+pop → push only 처리 확인
        push_data = 8'h0f;
        push = 1'b1;
        pop = 1'b1;
        @(negedge clk);
        push = 1'b0;
        pop  = 1'b0;
        if (full == 0 && empty == 0 && pop_data == 8'h0f)
            $display("%t : pass 4. push only when empty (pop_data=%h)", $time, pop_data);
        else
            $display("%t : fail 4. full=%b empty=%b pop_data=%h", $time, full, empty, pop_data);

        // 5. 보통일 때 push+pop → 둘 다 처리 확인
        push_data = 8'h10;
        push = 1'b1;
        pop = 1'b1;
        @(negedge clk);
        push = 1'b0;
        pop  = 1'b0;
        if (full == 0 && empty == 0 && pop_data == 8'h10)
            $display("%t : pass 5. push+pop normal (pop_data=%h)", $time, pop_data);
        else
            $display("%t : fail 5. full=%b empty=%b pop_data=%h", $time, full, empty, pop_data);

        #10;
        $finish;
    end */

