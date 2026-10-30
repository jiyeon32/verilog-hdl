`timescale 1ns / 1ps
module tb_dht11 ();
    reg [15:0] humidity, temperature;
    reg [ 7:0] check_sum;
    reg [39:0] sensor_data;
    reg clk, rst, btnR;
    reg sensor_io;
    wire dht11_io;
    integer i;
    top_dht11 DUT (
        .clk     (clk),
        .rst     (rst),
        .btnR    (btnR),
        .dht11_io(dht11_io)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        btnR = 1'b0;
        sensor_io = 1;
        i = 0;
        humidity = {8'd50, 8'd05};
        temperature = {8'd25, 8'd01};
        check_sum = humidity[15:8] + humidity[7:0] + temperature[15:8] + temperature[7:0];
        sensor_data = {humidity, temperature, check_sum};
        #10;
        rst = 0;

        #10;
        btnR = 1;
        #10_000;
        btnR = 0;

        // start signal
        @(posedge dht11_io);

        #(20_000);  // 20usec wait
        // 
        force DUT.dht11_io = sensor_io;
        // sensor io pattern
        // sync, repose sensor
        sensor_io = 1'b0;
        #(80_000);  // 80usec low
        sensor_io = 1'b1;
        #(80_000);  // 80usec high

        for (i = 0; i < 40; i = i + 1) begin
            // data sync 50usec
            sensor_io = 1'b0;
            #(50_000);
            if (sensor_data[39-i]) begin
                // data bit '1'
                sensor_io = 1'b1;
                #(70_000);
            end else begin
                // data bit '0'
                sensor_io = 1'b1;
                #(30_000);
            end
            sensor_io = 1'b0;
            #(50_000);

        end

        release DUT.dht11_io;
        #(1000);
        $finish;
    end
endmodule
