`timescale 1ns / 1ps

`include "constants.vh"

module task_5e2 (
    input clock,
    input [6:0] paint_seg, // paint.v returns a 7-segment style digit already
    output reg [6:0] seg,
    output reg [3:0] an,
    output reg dp
    );
    
    initial begin
        seg <= 7'b1111111;
        an <= 4'b1111;
        dp <= 1;
    end
    
    wire SLOW_CLOCK;
    new_clock(.frequency(200), .clock(clock), .SLOW_CLOCK(SLOW_CLOCK));
    reg [1:0] count = 0;
    always @ (posedge SLOW_CLOCK) begin
        count <= (count == 3) ? 0 : count + 1;
    end

    // VAL.(paint_seg)
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
            seg <= paint_seg;
            an <= 4'b1110;
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
    output reg [15:0] led,
    output reg [6:0] seg,
    output reg [3:0] an,
    output reg dp
    );

    wire rst;
    assign rst = 0; // Can assign to any button 

    // 3.A 
    wire clk625, frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    wire [15:0] oled_data_final;
    reg [15:0] oled_data;
    assign oled_data_final = oled_data;
    new_clock clk6p25m (6250000, clock, clk625);
    Oled_Display(clk625, rst, frame_begin, sending_pixels, sample_pixel, pixel_index, oled_data_final,
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
    wire [6:0] paint_seg;
    wire [15:0] oled_data_4e;
    paint pt(clock, left, right, 1'b1, xpos, ypos, pixel_index, led_blink, mouse_press, mouse_reset, mouse_press_x, mouse_press_y, paint_seg, oled_data_4e);

    // 4.A
    wire[15:0] oled_data_4a;
    border_mux task4A (.clock(clock), .rst(rst) .pixel_index(pixel_index), .oled_data(oled_data_4a), .btnC(btnC), .btnU(btnU));

    // 4.B
    wire[15:0] oled_data_4b;
    task_4b (.clock(clock), .rst(rst), .btnL(btnL), .btnR(btnR), .pixel_index(pixel_index), .oled_data(oled_data_4b));

    // 4.E1 Blinking LED 
    wire clk5hz; // will be off or on at 5Hz
    new_clock fivehertz(.frequency(5), .clock(clock), .SLOW_CLOCK(clk5hz));
    // assign led = clk5hz == 1 ? led_blink : 0;

    // 4.E2 VAL + paint.v number on 7 seg 
    wire [6:0] seg_4e2;
    wire [4:0] an_4e2;
    wire dp_4e2;
    task_5e2(.clock(clock), .paint_seg(paint_seg), .seg(seg_4e2), .an(an_4e2), .dp(dp_4e2));

    // Multiplexer 
    always @ (posedge clock) begin
        case(sw) 
            default: begin
                led <= 0;
                seg <= 7'b1111111;
                an <= 4'b1111;
                dp <= 1;
                oled_data <= 0;
            end
            16'b1: begin
                // 4A
                led <= 16'b1;
                seg <= 7'b1111111;
                an <= 4'b1111;
                dp <= 1;
                oled_data <= oled_data_4a;
            end
            16'b10: begin
                // 4B
                led <= 16'b10;
                seg <= 7'b1111111;
                an <= 4'b1111;
                dp <= 1;
                oled_data <= oled_data_4b;
            end
            16'b100: begin
                // 4C
                led <= 16'b100;
                seg <= 7'b1111111;
                an <= 4'b1111;
                dp <= 1;
            end
            16'b1000: begin
                // 4D
                led <= 16'b1000;
                seg <= 7'b1111111;
                an <= 4'b1111;
                dp <= 1;
            end
            16'b10000: begin
                // 4E
                seg <= seg_4e2;
                an <= an_4e2;
                dp <= dp_4e2;
                oled_data <= oled_data_4e;
            end
        endcase
    end

endmodule