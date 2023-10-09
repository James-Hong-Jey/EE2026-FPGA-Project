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

/**
 * This function runs once per pixel,
 * Checks whether that pixel is within the border,
 * and colors it main_col, bg_col if not
 *
 * Now supports .offset(1) which will shift the border down by 1
 */
module border (
    input [15:0] main_col, bg_col,
    input [1:0] thickness,
    input [32:0] offset,
    input [6:0] x, y, 
    output [15:0] oled_data
    );

    // TODO: Figure out why even numbers don't work
    assign oled_data = thickness && 
        (x > offset - 1 && x < `WIDTH - offset && y > offset - 1 && y < `HEIGHT - offset) && (
        (x <= thickness + offset - 1) || // Left
        (x >= `WIDTH - thickness - offset) || // Right
        (y <= thickness + offset - 1) || // Bottom
        (y >= `HEIGHT - offset - thickness) ) // Top
        ? main_col : bg_col;
endmodule

/**
 * Function specific to Task 4.A
 * Starts with a 1 thickness red border
 * Once btnC is pressed, orange_on is enabled
 * Instantly turns out 3 thickness orange border
 * 2s: 1px, 3.5s: 2px, 4.5s: 3px, (all green) 
 * 5.5s: all green borders disappear
 */ 
module border_mux (
    input clock,
    input [12:0] pixel_index,
    output reg [15:0] oled_data,
    input btnC, 
    input btnU
    );

    reg [32:0] COUNT, DEBOUNCE = 0;
    reg [3:0] SLOW_CLOCK = 0;
    wire [6:0] x, y;
    xy xy_converter (.pixel_index(pixel_index), .x(x), .y(y));

    wire [15:0] red_border, orange_border, green_border_1, green_border_2, green_border_3;
    border red(.main_col(`RED), .bg_col(`BLACK), .thickness(1), .offset(3), .x(x), .y(y), .oled_data(red_border));
    border orange(.main_col(`ORANGE), .bg_col(`BLACK), .thickness(3), .offset(6), .x(x), .y(y), .oled_data(orange_border));
    border green1(.main_col(`GREEN), .bg_col(`BLACK), .thickness(1), .offset(11), .x(x), .y(y), .oled_data(green_border_1));
    border green2(.main_col(`GREEN), .bg_col(`BLACK), .thickness(3), .offset(18), .x(x), .y(y), .oled_data(green_border_2));
    border green3(.main_col(`GREEN), .bg_col(`BLACK), .thickness(3), .offset(27), .x(x), .y(y), .oled_data(green_border_3));

    reg orange_on = 0;
    reg red_on = 0;
    reg orange_on = 0;

    always @ (posedge clock) begin

        // Button Debouncing
        if(DEBOUNCE > 0) begin
            DEBOUNCE <= DEBOUNCE - 1;
        end

        if(btnU == 1 && DEBOUNCE == 0) begin
            // 50ms debounce -> 50 * 10^-3 / 10^-8
            DEBOUNCE <= 5000000;
            red_on <= ~red_on;
        end

        // Set orange_on once
        if(btnC == 1) orange_on <= 1;

        // TODO: Figure out why the slow clock is not working

        // SLOW_CLOCK is for green borders to slowly turn on
        // Every SLOW_CLOCK is 0.5 seconds
        // Equation: 1 / frequency / 2 / 10^-8 / 10
        COUNT <= (COUNT == 100000000 / 2 / 2 - 1) ? 0 : COUNT + 1;
        SLOW_CLOCK <= (COUNT == 0) ? SLOW_CLOCK + 1 : SLOW_CLOCK;

        // Actual Operation
        if(red_border != `BLACK) begin
            oled_data <= red_border;
        end else if (orange_on) begin // btnC pressed

            COUNT <= 0; // Reset timer
            SLOW_CLOCK <= 0;

            if(SLOW_CLOCK > 11) begin
                COUNT <= 0;
                SLOW_CLOCK <= 0;
            end

            if(red_on) begin // btnU pressed - toggle red square
                //oled_data = red_square;
            end

            if(orange_border != `BLACK) begin
                oled_data = orange_border;
            //end else if (SLOW_CLOCK >= 4 && green_border_1 != `BLACK) begin
            end else if (green_border_1 != `BLACK) begin
                oled_data <= green_border_1;
            // end else if (SLOW_CLOCK >= 7 && green_border_2 != `BLACK) begin
            end else if (green_border_2 != `BLACK) begin
                oled_data <= green_border_2;
            //end else if (SLOW_CLOCK >= 9 && green_border_3 != `BLACK) begin
            end else if (green_border_3 != `BLACK) begin
                oled_data <= green_border_3;
            end else oled_data = `BLACK;

        end else begin
            oled_data <= `BLACK;
        end
    end
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

     MouseCtl (.clk(clk100), .rst(rst), .xpos(xpos), .ypos(ypos), .zpos(zpos), 
             .left(left), .middle(middle), .right(right), .new_event(new_event), 
             .value(value), .setx(setx), .sety(sety), .setmax_x(setmax_x), .setmax_y(setmax_y), 
             .ps2_clk(PS2Clk), .ps2_data(PS2Data) );
                    
    assign led[15] = left;
    assign led[14] = middle;
    assign led[13] = right;

    // 3.C
    // UNTESTED

    // wire [11:0] mouse_press_x, mouse_press_y;
    // paint paint1(clk100, new_event, btnC, xpos, ypos, pixel_index, 
        // led, left, right, mouse_press_x, mouse_press_y, seg, oled_data);

    // 4.A
    border_mux task4A (.clock(clock), .pixel_index(pixel_index), .oled_data(oled_data), .btnC(btnC), .btnU(btnU));

endmodule