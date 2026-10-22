`timescale 1ns / 1ps

module fifo (
    input        clk,
    input        rst,
    input        push,
    input        pop,
    input  [7:0] push_data,
    output [7:0] pop_data,
    output       full,
    output       empty
);
endmodule

module register_file #(
    parameter DEPTH = 4,
    BIT_WIDTH = $clog2(DEPTH)
) (
    input                     clk,
    input                     we,
    input  [             7:0] wdata,
    input  [BIT_WIDTH -1 : 0] waddr,
    input  [BIT_WIDTH -1 : 0] raddr,
    output [             7:0] rdata
);

    // ram
    reg [7:0] register_file[0:DEPTH-1];

    //write SL

    // read CL

endmodule


