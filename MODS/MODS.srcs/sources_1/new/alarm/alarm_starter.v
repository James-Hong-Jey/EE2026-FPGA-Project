`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2023 02:32:06
// Design Name: 
// Module Name: alarm_starter
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


module alarm_starter(
    input clk_100MHz,
    output led0,
    input sw0,
    input [3:0] ones,
    input [3:0] tens,
    input [3:0] hundreds,
    input [3:0] thousands,
    output reg alarm_unlocked = 0
    );
    
    always @ (posedge clk_100MHz) begin
    if (alarm_unlocked == 0) begin
            if (sw0) begin
                if(ones == 0 && tens == 0 && hundreds == 0 && thousands == 0) begin
                alarm_unlocked <= 1;
                end
            end
        end
        
    end
    
    assign led0 = (alarm_unlocked == 1) ? 1 : 0;
    
endmodule
