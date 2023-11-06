`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2023 22:21:29
// Design Name: 
// Module Name: task_6
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Available clocks: twenty_hertz, five_hertz, one_hertz
// Default clock: 100MHz (10ns)

module t6_counter (
    input CLOCK,
    output reg [1:0] COUNT
    );
    wire CLOCK_1HZ;
    one_hertz one_hertz_clock (CLOCK, CLOCK_1HZ); // one_hertz defined in clock_source
    always @ (posedge CLOCK_1HZ) begin
        COUNT <= COUNT + 1;
    end

endmodule

module t6_multiplexer (
    input CLOCK,
    output reg [3:0] LEDS
    );
    wire [1:0] COUNT;
    t6_counter counter (CLOCK, COUNT);
    always @ (posedge CLOCK) begin
        if (COUNT == 2'b00) begin
            LEDS <= 4'b0001;
        end
        if (COUNT == 2'b01) begin
            LEDS <= 4'b0010;
        end
        if (COUNT == 2'b10) begin
            LEDS <= 4'b0100;
        end
        if (COUNT == 2'b11) begin
            LEDS <= 4'b1000;
        end
    end
endmodule

// Task is to make one led light up for each second, in a 4 second cycle
module task_6(
    input CLOCK,
    output [3:0] led
    );
    t6_multiplexer m (CLOCK, led);
endmodule
