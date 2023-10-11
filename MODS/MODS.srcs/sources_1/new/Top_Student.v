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

module Top_Student (
    input clock, 
    input [15:0] sw,
    input [6:0] seg,
    input btnU, 
    input btnC, 
    inout PS2Clk,
    inout PS2Data,
    output [7:0] JB,
    output [15:0] led
    );

    wire rst;
    assign rst = 0;

    // 3.A
    wire clk, frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    new_clock clk6p25m (6250000, clock, clk);
    // wire [15:0] oled_data = sw[4] == 1 ? 16'hF800 : 16'h07E0;
    wire [15:0] oled_data;
    Oled_Display(clk, rst, frame_begin, sending_pixels, sample_pixel, pixel_index, oled_data,
                JB[0], JB[1], JB[3], JB[4], JB[5], JB[6], JB[7]);


    // 3.B

    wire [11:0] xpos, ypos;
    wire [3:0] zpos;
    wire left, middle, right, new_event;
    reg [11:0] value = 0;
    reg setx = 0;
    reg sety = 0;
    reg setmax_x = 0;
    reg setmax_y = 0;

     MouseCtl (.clk(clk), .rst(rst), .xpos(xpos), .ypos(ypos), .zpos(zpos), 
             .left(left), .middle(middle), .right(right), .new_event(new_event), 
             .value(value), .setx(setx), .sety(sety), .setmax_x(setmax_x), .setmax_y(setmax_y), 
             .ps2_clk(PS2Clk), .ps2_data(PS2Data) );
                    
    // assign led[15] = left;
    // assign led[14] = middle;
    // assign led[13] = right;

    // 3.C

    wire mouse_press, mouse_reset;
    wire [11:0] mouse_press_x, mouse_press_y;
    //paint (.clk_100M(clk), .mouse_1(new_event), .reset(right), .enable(left), .mouse_x(xpos), .mouse_y(ypos), .pixel_index(pixel_index), 
      //  .led(led), .mouse_press(mouse_press), .mouse_reset(mouse_reset), .mouse_press_x(mouse_press_x), .mouse_press_y(mouse_press_y), .seg(seg), .colour_chooser(oled_data));
    // ^ doesn't work for some reason
    paint pt(clk, left, right, 1'b1, xpos, ypos, pixel_index, led, mouse_press, mouse_reset, mouse_press_x, mouse_press_y, seg, oled_data);

    // 4.A
    // border_mux task4A (.clock(clock), .pixel_index(pixel_index), .oled_data(oled_data), .btnC(btnC), .btnU(btnU));

endmodule