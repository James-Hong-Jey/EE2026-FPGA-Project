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

    // menu(clock, sw, btnU, btnD, btnC, btnL, btnR, PS2Clk, PS2Data, 
                // //JC_MIC3_Pin1, JC_MIC3_Pin3, JC_MIC3_Pin4, 
                // JB, led, seg, an, dp);


    // Initialise the reset button
    wire rst;
    reg rst_sw; // If sw changes at all, then this is 1 for a clock cycle, else 0
    // TODO: Assign a new button by || btnC
    assign rst = rst_sw || btnD; // Can assign to any button 

    // Initialise everything to blank
    initial begin
        rst_sw <= 0;
        oled_data <= 0;
    end

    // Setting up the OLED
    wire clk625, frame_begin, sending_pixels, sample_pixel; // clk625 is the clock speed, rest are irrelevant
    wire [12:0] pixel_index; // where the pixel currently being analysed is
    wire [15:0] oled_data_final; // the colour the current pixel should be 
    reg [15:0] oled_data; // need a reg so that it can be manipulated in always loop
    assign oled_data_final = oled_data;
    new_clock clk6p25m (6250000, clock, clk625);
    Oled_Display(clk625, rst, frame_begin, sending_pixels, sample_pixel, pixel_index, oled_data_final,
                JB[0], JB[1], JB[3], JB[4], JB[5], JB[6], JB[7]);

    // Setting up the mouse 
    wire [11:0] xpos, ypos;
    wire [3:0] zpos;
    wire left, middle, right, new_event;
    reg [11:0] value = 0;
    reg setx = 0;
    reg sety = 0;
    reg setmax_x = `WIDTH;
    reg setmax_y = `HEIGHT;

     MouseCtl (.clk(clock), .rst(rst), .xpos(xpos), .ypos(ypos), .zpos(zpos), 
             .left(left), .middle(middle), .right(right), .new_event(new_event), 
             .value(value), .setx(setx), .sety(sety), .setmax_x(setmax_x), .setmax_y(setmax_y), 
             .ps2_clk(PS2Clk), .ps2_data(PS2Data) );

    // James
    wire [15:0] oled_data_mic;
    wire [6:0] seg_mic;
    wire [3:0] an_mic;
    mic(.clock(clock), .JC_MIC3_Pin1(JC_MIC3_Pin1), .JC_MIC3_Pin3(JC_MIC3_Pin3), .JC_MIC3_Pin4(JC_MIC3_Pin4), .pixel_index(pixel_index), .oled_data(oled_data_mic), .seg(seg_mic), .an(an_mic));

    // Matin

    // Barbara

    // Karishma

    // Multiplexer 
    reg [15:0] menu [0:6144];
    initial $readmemh ("./pixel_art/menu_draft.mem", menu);
    reg [15:0] select_noise [0:6144];
    initial $readmemh ("./pixel_art/select_noise.mem", select_noise);
    reg [15:0] select_sheep [0:6144];
    initial $readmemh ("./pixel_art/select_sheep.mem", select_sheep);
    reg [15:0] select_alarm [0:6144];
    initial $readmemh ("./pixel_art/select_alarm.mem", select_alarm);
    reg [15:0] select_unlock [0:6144];
    initial $readmemh ("./pixel_art/select_unlock.mem", select_unlock);

    reg [3:0] sequence = 0;
    reg [32:0] debounce = 0;
    reg isActive = 0; // 0 will show the menu, 1 will show the associated screen
    always @ (posedge clock) begin
        // Debounce
        if(debounce > 0) debounce <= debounce - 1;
        if(debounce == 0) begin
            debounce <= 150 * 100000; // 150 ms
            if(btnR) sequence <= sequence == 3 ? 0 : sequence + 1; 
            else if(btnL) sequence <= sequence == 0 ? 3 : sequence - 1; 
            else if(btnC) isActive <= ~isActive;
        end

        case(sequence)
        4'b1: begin 
            if(isActive) oled_data <= oled_data_mic;
            else oled_data <= select_noise[pixel_index];
        end
        4'b10: oled_data <= select_sheep[pixel_index];
        4'b11: oled_data <= select_alarm[pixel_index];
        4'b0: oled_data <= select_unlock[pixel_index];
        default: oled_data <= menu[pixel_index];
        endcase
    end

endmodule

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