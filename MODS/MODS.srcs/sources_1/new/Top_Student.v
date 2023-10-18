`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: James Hong Jey
//  STUDENT B NAME: Barbara Chong
//  STUDENT C NAME: Karishma T
//  STUDENT D NAME: Azfarul Matin
//
//////////////////////////////////////////////////////////////////////////////////
`include "constants.vh"

/**  
 * usage:
 * new_clock clk625M (6250000, clock, <output>);
 */ 
module new_clock (input [32:0] frequency, input clock, output reg SLOW_CLOCK);
    reg [32:0] COUNT = 0;
    // Equation: 1 / frequency / 2 / 10^-8 / 10
    always @ (posedge clock) begin
        COUNT <= (COUNT == 100000000 / frequency / 2 - 1) ? 0 : COUNT + 1;
        SLOW_CLOCK <= (COUNT == 0) ? ~SLOW_CLOCK : SLOW_CLOCK;
    end
endmodule

module xy (input [12:0] pixel_index, output [6:0] x, y);
    assign x = pixel_index % `WIDTH;
    assign y = pixel_index / `WIDTH;
endmodule

module Top_Student (
    input clock, 
    input [15:0] sw,
    input btnU, 
    input btnD,
    input btnC,
    input btnL,
    input btnR,

    inout PS2Clk,
    inout PS2Data,

    output [7:0] JB,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp
    );

    basic_task_mux(clock, sw, btnU, btnD, btnC, btnL, btnR, PS2Clk, PS2Data, JB, led, seg, an, dp);

endmodule