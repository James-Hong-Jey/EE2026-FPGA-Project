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

/**
 * This is to turn the pixel index into X and Y coordinates 
 */
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

    output JC_MIC3_Pin1,
    input JC_MIC3_Pin3,
    output JC_MIC3_Pin4,

    output [7:0] JB,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp
    );
    // basic_task_mux(clock, sw, btnU, btnD, btnC, btnL, btnR, PS2Clk, PS2Data, JB, led, seg, an, dp);

    // 3.A Setting up the OLED
    wire clk625, frame_begin, sending_pixels, sample_pixel; // clk625 is the clock speed, rest are irrelevant
    wire [12:0] pixel_index; // where the pixel currently being analysed is
    wire [15:0] oled_data_final; // the colour the current pixel should be 
    reg [15:0] oled_data; 
    assign oled_data_final = oled_data;
    new_clock clk6p25m (6250000, clock, clk625);
    Oled_Display(clk625, rst, frame_begin, sending_pixels, sample_pixel, pixel_index, oled_data_final,
                JB[0], JB[1], JB[3], JB[4], JB[5], JB[6], JB[7]);

    // wire [11:0] mic_data;
    wire [15:0] oled_data_mic;
    mic(.clock(clock), .JC_MIC3_Pin1(JC_MIC3_Pin1), .JC_MIC3_Pin3(JC_MIC3_Pin3), .JC_MIC3_Pin4(JC_MIC3_Pin4), .pixel_index(pixel_index), .oled_data(oled_data_final));

endmodule