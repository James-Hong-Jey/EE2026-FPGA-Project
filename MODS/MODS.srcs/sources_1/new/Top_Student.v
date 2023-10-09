`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: James Hong Jey
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
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

module border (
    input [15:0] main_col, bg_col,
    input [1:0] thickness,
    input [6:0] x, y, 
    output [15:0] oled_data
    );

    // thickness && (x <= thickness - 1 || x >= `WIDTH - thickness || y <= thickness - 1 || y >= `HEIGHT - thickness)
    assign oled_data = thickness ? main_col : bg_col;

endmodule

module Top_Student (
    input clock, 
    input [15:0] sw,
    input [6:0] seg,
    input btnC, // used as reset

    inout PS2Clk,
    inout PS2Data,

    output [7:0] JB,
    output [15:0] led
    );

    // 3.A
    wire clk, frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    new_clock clk6p25m (6250000, clock, clk);
    // wire [15:0] oled_data = sw[4] == 1 ? 16'hF800 : 16'h07E0;
    wire [15:0] oled_data = sw[4] == 1 ? `RED : `GREEN;
    Oled_Display(clk, btnC, frame_begin, sending_pixels, sample_pixel, pixel_index, oled_data,
                JB[0], JB[1], JB[3], JB[4], JB[5], JB[6], JB[7]);

    // 3.B
    // UNTESTED

    wire clk100;
    new_clock clk100m (100000000, clock, clk100); 

    wire [11:0] xpos, ypos;
    wire [3:0] zpos;
    wire left, middle, right, new_event;
    wire [11:0] value = 0;
    wire setx, sety, setmax_x, setmax_y;
    assign setx = 0;
    assign sety = 0;
    assign setmax_x = 0;
    assign setmax_y = 0;

    // clk, rst, [11:0] xpos, [11:0] ypos, [3:0] zpos, left, middle, right, new_event
    // [11:0] value, setx, sety, setmax_x, setmax_y, ps2_clk, ps2_data
    MouseCtl(clk100, btnC, xpos, ypos, zpos, left, middle, right, new_event, 
                    value, setx, sety, setmax_x, setmax_y, PS2Clk, PS2Data);
                    
    assign led[15] = left;
    assign led[14] = middle;
    assign led[13] = right;

    // 3.C
    // UNTESTED

    // wire [11:0] mouse_press_x, mouse_press_y;
    // paint paint1(clk100, new_event, btnC, xpos, ypos, pixel_index, 
        // led, left, right, mouse_press_x, mouse_press_y, seg, oled_data);

endmodule