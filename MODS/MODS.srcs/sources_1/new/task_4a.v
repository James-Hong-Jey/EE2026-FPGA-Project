`timescale 1ns / 1ps

`include "constants.vh"
`include "Top_Student.v"

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

    assign oled_data = (thickness != 0) && 
        (x > offset - 1 && x < `WIDTH - offset && y > offset - 1 && y < `HEIGHT - offset) && (
        (x <= thickness + offset - 1) || // Left
        (x >= `WIDTH - thickness - offset) || // Right
        (y <= thickness + offset - 1) || // Bottom
        (y >= `HEIGHT - offset - thickness) ) // Top
        ? main_col : bg_col;
endmodule

module square (
    input [15:0] main_col, bg_col,
    input [32:0] width,
    input [6:0] x, y,
    output [15:0] oled_data
    );

    assign oled_data = (width != 0) && 
        (x >= `WIDTH / 2 - width / 2) && (x <= `WIDTH / 2 + width / 2) &&
        (y >= `HEIGHT / 2 - width / 2) && (y <= `HEIGHT / 2 + width / 2)
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

    reg [32:0] DEBOUNCE = 0;
    wire [6:0] x, y;
    xy xy_converter (.pixel_index(pixel_index), .x(x), .y(y));

    wire [15:0] red_border, orange_border, green_border_1, green_border_2, green_border_3, red_square;
    border red(.main_col(`RED), .bg_col(`BLACK), .thickness(1), .offset(3), .x(x), .y(y), .oled_data(red_border));
    border orange(.main_col(`ORANGE), .bg_col(`BLACK), .thickness(3), .offset(6), .x(x), .y(y), .oled_data(orange_border));
    border green1(.main_col(`GREEN), .bg_col(`BLACK), .thickness(1), .offset(11), .x(x), .y(y), .oled_data(green_border_1));
    border green2(.main_col(`GREEN), .bg_col(`BLACK), .thickness(2), .offset(14), .x(x), .y(y), .oled_data(green_border_2));
    border green3(.main_col(`GREEN), .bg_col(`BLACK), .thickness(3), .offset(19), .x(x), .y(y), .oled_data(green_border_3));
    square redsq(.main_col(`RED), .bg_col(`BLACK), .width(6), .x(x), .y(y), .oled_data(red_square));

    wire SLOW_CLOCK;
    new_clock twohertz (.frequency(2), .clock(clock), .SLOW_CLOCK(SLOW_CLOCK));
    
    reg [32:0] halfsecs = 0;
    always @ (posedge SLOW_CLOCK) begin
        halfsecs <= (halfsecs == 11) ? 0 : halfsecs + 1;
    end

    reg orange_on = 0;
    reg red_on = 0;

    always @ (posedge clock) begin

        // Button Debouncing
        if(DEBOUNCE > 0) begin
            DEBOUNCE <= DEBOUNCE - 1;
        end

        if(btnU == 1 && DEBOUNCE == 0) begin
            // 500ms debounce -> 500 * 10^-3 / 10^-8
            DEBOUNCE <= 50000000;
            red_on <= ~red_on;
        end

        // Set orange_on once
        if(btnC == 1) orange_on <= 1;

        // TODO: Figure out why the slow clock is not working

        // SLOW_CLOCK is for green borders to slowly turn on
        // Every SLOW_CLOCK is 0.5 seconds

        // Actual Operation
        if(red_border != `BLACK) begin
            oled_data <= red_border;
        end else if (orange_on) begin // btnC pressed

            // halfsecs <= 0;

            if(red_on && red_square != `BLACK) begin // btnU pressed - toggle red square
                oled_data = red_square;
            end else if(orange_border != `BLACK) begin
                oled_data = orange_border;
            end else if (halfsecs >= 4 && green_border_1 != `BLACK) begin
            //end else if (green_border_1 != `BLACK) begin
                oled_data <= green_border_1;
            end else if (halfsecs >= 7 && green_border_2 != `BLACK) begin
            // end else if (green_border_2 != `BLACK) begin
                oled_data <= green_border_2;
            end else if (halfsecs >= 9 && green_border_3 != `BLACK) begin
            // end else if (green_border_3 != `BLACK) begin
                oled_data <= green_border_3;
            // end else if (red_square != `BLACK) begin
                // oled_data <= red_square;
            end else oled_data = `BLACK;

        end else begin
            oled_data <= `BLACK;
        end
    end
endmodule
