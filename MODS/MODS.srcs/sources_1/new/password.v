`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2023 00:34:21
// Design Name: 
// Module Name: password
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


module password (
    input clock,
    input [6:0] paint_seg, // paint.v returns a 7-segment style digit already
    output reg [6:0] seg,
    output reg [3:0] an,
    output reg dp 
    );
    
    // Initialise to blank 7 seg display
    initial begin
        seg <= 7'b1111111;
        an <= 4'b1111;
        dp <= 1;
    end
    
    wire SLOW_CLOCK;
    new_clock(.frequency(200), .clock(clock), .SLOW_CLOCK(SLOW_CLOCK));

// Flags to track if anodes are already set
    reg anode_3_set = 0;
    reg anode_2_set = 0;
    reg anode_1_set = 0;
    reg anode_0_set = 0;

    always @ (posedge SLOW_CLOCK) begin
           // Check the value in paint_seg to determine which anode to activate
            if (paint_seg == 7'b0110000 && !anode_3_set && !anode_2_set && !anode_1_set && !anode_0_set  ) begin // 3
                 an <= 4'b0111; // Anode 3
                 seg <= paint_seg;
                 dp <= 1;
                 anode_3_set <= 1;
           end else if (paint_seg ==  7'b0100100 && anode_3_set && !anode_2_set && !anode_1_set && !anode_0_set ) begin //2
               an <= 4'b1011; // Anode 2
               seg <= paint_seg;
               dp <= 1;
               anode_2_set <= 1;
           end else if (paint_seg == 7'b1000000  && anode_3_set && anode_2_set && !anode_1_set && !anode_0_set) begin //0
               an <= 4'b1101; // Anode 1
               seg <= paint_seg;
               dp <= 1;  
               anode_1_set <= 1;     
           end else if (paint_seg == 7'b0010010 && anode_3_set && anode_2_set && anode_1_set && !anode_0_set) begin //5 
            seg <= paint_seg;
            an <= 4'b1110;
            dp <= 0; // Turn on dp
            anode_0_set <= 1; 
        end
    end
endmodule