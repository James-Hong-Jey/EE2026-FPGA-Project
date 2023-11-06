`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2023 14:31:54
// Design Name: 
// Module Name: led_display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module led_display(
    input [15:0] sw,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp
    );
    
    assign led[9:0] = sw[9:0];

    // Password: 55326
    // led 15 will light up when only these are on
    wire pass = ( (sw[5] & sw[3] & sw[2] & sw[6]) & !(sw[0]+sw[1]+sw[4]+sw[7]+sw[8]+sw[9]) );
    assign led[15] = pass;
                     
     // If not correct, display the initialisation display
     // rightmost number = 6
     // 6 -> E without the top horizontal line, on 1st and 4th position
     // (every segment except ABC, AN 0 and 3
     // NOTE - 7 segment display is active low
     assign an[0] = 0;
     assign an[3] = 0;
     assign seg[6:3] = 0;

    // If password is correct, then display
    // E (7-segment looks accurate to the capital letter)
    // The anode it is displayed on is determined by:
    // 2nd rightmost number = 2
    // 2 -> AN0 & AN2 & AN3
     assign an[2] = ~pass;
     assign seg[0] = ~pass;

endmodule