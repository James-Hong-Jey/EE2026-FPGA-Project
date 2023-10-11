`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME: Barbara Chong
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////

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

module Top_Student (
    input clock, 
    input [15:0] sw,
    input btnC,
    input btnL,
    input btnR,
    output [7:0] JB
    );

    wire frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    
    wire [15:0] oled_data;
    task_4b (clock, btnC, btnL, btnR, pixel_index, oled_data);
    wire clk;
    new_clock clk6p25m (6250000, clock, clk);
    Oled_Display(clk, btnC, frame_begin, sending_pixels, sample_pixel, pixel_index, oled_data,
                JB[0], JB[1], JB[3], JB[4], JB[5], JB[6], JB[7]);
endmodule