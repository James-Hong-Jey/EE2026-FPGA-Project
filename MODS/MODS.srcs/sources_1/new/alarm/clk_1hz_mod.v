`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2023 03:17:19
// Design Name: 
// Module Name: clk_1hz_mod
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


module clk_1hz_module (
    input CLOCK,
    output reg CLOCK_1HZ,
    output reg [5:0] SOUND_COUNT = 0
);

reg [31:0] COUNT = 0;

always @(posedge CLOCK) begin
    if (COUNT >= 7142856) begin
        COUNT <= 0;
        CLOCK_1HZ <= ~CLOCK_1HZ; // Toggle the 1Hz clock
    end else begin
        COUNT <= COUNT + 1;
    end
end

always @(posedge CLOCK_1HZ) begin
    SOUND_COUNT <= (SOUND_COUNT == 22)? 0 : SOUND_COUNT + 1;
end

endmodule