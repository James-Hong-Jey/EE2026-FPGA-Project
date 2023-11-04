`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2023 12:59:51
// Design Name: 
// Module Name: clk_1hz_module
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


module clk_sound (
    input CLOCK,
    output reg SLOW_CLOCK,
    output reg [3:0] COUNT_Z = 0
);

reg [31:0] COUNT = 0;

always @(posedge CLOCK) begin
    if (COUNT >= 49999999) begin
        COUNT <= 0;
        SLOW_CLOCK <= ~SLOW_CLOCK; // Toggle the 1Hz clock
    end else begin
        COUNT <= COUNT + 1;
    end
end

always @(posedge SLOW_CLOCK) begin
    COUNT_Z <= (COUNT_Z >= 1)? 0 : COUNT_Z + 1;
    
end

endmodule
