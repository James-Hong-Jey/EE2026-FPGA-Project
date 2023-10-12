`timescale 1ns / 1ps

`include "constants.vh"

module task_5e2 (
    input clock,
    input [3:0] digit,
    output reg [6:0] seg,
    output reg [3:0] an,
    output reg dp
    );
    reg [1:0] count = 0;
    
    initial begin
        seg = 7'b1111111;
        an = 4'b1111;
        dp = 1;
    end
    
    wire SLOW_CLOCK;
    new_clock(.frequency(500), .clock(clock), .SLOW_CLOCK(SLOW_CLOCK));
    always @ (posedge SLOW_CLOCK) begin
        count = (count == 3) ? 0 : count + 1;
    end

    // Make VAL.(number)
    always @ (posedge clock) begin
        if(count == 0) begin 
            seg <= `V;
            an <= 4'b0111;
            dp <= 1;
        end else if (count == 1) begin
            seg <= `A;
            an <= 4'b1011;
            dp <= 1;
        end else if (count == 2) begin
            seg <= `L;
            an <= 4'b1101;
            dp <= 0;
        end else if (count == 3) begin // Some number
            an <= 4'b1110;
            case(digit) 
                0: seg <= `DIG0;
                1: seg <= `DIG1;
                2: seg <= `DIG2;
                3: seg <= `DIG3;
                4: seg <= `DIG4;
                5: seg <= `DIG5;
                6: seg <= `DIG6;
                4'b0111: seg <= `DIG7;
                8: seg <= `DIG8;
                9: seg <= `DIG9;
                default: seg <= 7'b0;
            endcase
            dp <= 1;
        end
    end

endmodule

module basic_task_mux(
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

    wire rst;
    assign rst = 0; // Can assign to any button 

    // 3.A 
    wire clk625, frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    wire [15:0] oled_data;
    new_clock clk6p25m (6250000, clock, clk625);
    Oled_Display(clk625, btnC, frame_begin, sending_pixels, sample_pixel, pixel_index, oled_data,
                JB[0], JB[1], JB[3], JB[4], JB[5], JB[6], JB[7]);
    // assign oled_data = sw[0] == 1 ? `RED : `GREEN


    // 3.B left -> led[15] etc
    wire [11:0] xpos, ypos;
    wire [3:0] zpos;
    wire left, middle, right, new_event;
    reg [11:0] value = 0;
    reg setx = 0;
    reg sety = 0;
    reg setmax_x = 0;
    reg setmax_y = 0;

     MouseCtl (.clk(clock), .rst(rst), .xpos(xpos), .ypos(ypos), .zpos(zpos), 
             .left(left), .middle(middle), .right(right), .new_event(new_event), 
             .value(value), .setx(setx), .sety(sety), .setmax_x(setmax_x), .setmax_y(setmax_y), 
             .ps2_clk(PS2Clk), .ps2_data(PS2Data) );
                    
    // assign led[15] = left;
    // assign led[14] = middle;
    // assign led[13] = right;

    // 3.C Paint module -> led
    wire mouse_press, mouse_reset;
    wire [11:0] mouse_press_x, mouse_press_y;
    //paint (.clk_100M(clock), .mouse_1(new_event), .reset(right), .enable(left), .mouse_x(xpos), .mouse_y(ypos), .pixel_index(pixel_index), 
      //  .led(led), .mouse_press(mouse_press), .mouse_reset(mouse_reset), .mouse_press_x(mouse_press_x), .mouse_press_y(mouse_press_y), .seg(seg), .colour_chooser(oled_data));
    // ^ doesn't work for some reason
    wire [15:0] led_blink;
    wire [6:0] seg_blink;
    // paint pt(clock, left, right, 1'b1, xpos, ypos, pixel_index, led_blink, mouse_press, mouse_reset, mouse_press_x, mouse_press_y, seg_blink, oled_data);

    // 4.A
    // border_mux task4A (.clock(clock), .pixel_index(pixel_index), .oled_data(oled_data), .btnC(btnC), .btnU(btnU));

    // 4.B
    // task_4b (.clock(clock), .rst(rst), .btnL(btnL), .btnR(btnR), .pixel_index(pixel_index), .oled_data(oled_data));

    // 4.E1 Blinking LED 
    wire clk5hz; // will be off or on at 5Hz
    new_clock fivehertz(.frequency(5), .clock(clock), .SLOW_CLOCK(clk5hz));
    assign led = clk5hz == 1 ? led_blink : 0;

    // 4.E2 VAL + paint.v number on 7 seg 
    task_5e2(.clock(clock), .digit(4'b0111), .seg(seg), .an(an), .dp(dp));
endmodule
