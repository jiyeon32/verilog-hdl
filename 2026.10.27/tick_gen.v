`timescale 1ns / 1ps

module tick_gen #(
    parameter FREQUENCY = 100
) (
    input clk,
    input rst,
    input run_stop,
    input clear,
    output o_tick  // 100hz tick
);


  localparam F_COUNT = 100_000_000 / FREQUENCY;

  reg [$clog2(F_COUNT)-1:0] counter_reg;
  reg reg_tick;

  always @(posedge clk, posedge rst) begin
    if (rst | clear) begin
      counter_reg <= 0;
      reg_tick <= 0;
    end else begin
      if (run_stop) begin
        counter_reg <= counter_reg + 1;
        reg_tick <= 1'b0;
        if (counter_reg == (F_COUNT - 1)) begin
          counter_reg <= 0;
          reg_tick <= 1'b1;
        end
      end else begin
        // run_stop 이 1이고, o_tick이 1일 때 run_stop이 0으로 바뀌면
        // 계속 o_tick이 1로 남는 경우 해결하기 위함.
        reg_tick <= 1'b0;
      end
    end
  end

  assign o_tick = reg_tick;

endmodule
