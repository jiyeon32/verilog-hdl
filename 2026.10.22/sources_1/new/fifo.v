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
    A_BIT_BIT_WIDTH = $clog2(DEPTH),
    D_BIT_WIDTH = 8
) (
    input                           clk,
    input                           we,
    input  [A_BIT_BIT_WIDTH-1:0] waddr,
    input  [A_BIT_BIT_WIDTH-1:0] raddr,
    output [    D_BIT_WIDTH-1:0] rdata,
    input  [    D_BIT_WIDTH-1:0] wdata
);

    // ram
    reg [D_BIT_WIDTH-1:0] register_file[0:DEPTH-1];

    //write SL
    always @(posedge clk) begin
        if (we) begin
            register_file[waddr] <= wdata;
        end

    end

    // read CL
    assign rdata = register_file[raddr];
endmodule

module control_unit #(
    parameter A_BIT_WIDTH = 2
) (
    input                       clk,
    input                       rst,
    input                       push,
    input                       pop,
    output [A_BIT_WIDTH -1 : 0] wptr,
    output [A_BIT_WIDTH -1 : 0] rptr,
    output                      we,
    output                      full,
    output                      empty
);

    reg[1:0] c_state, n_state;
    reg [A_BIT_WIDTH-1:0] wptr_reg, wptr_next;
    reg [A_BIT_WIDTH-1:0] rptr_reg, rptr_next;




endmodule
