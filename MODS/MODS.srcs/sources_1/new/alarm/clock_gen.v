`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.11.2023 03:16:36
// Design Name: 
// Module Name: clock_gen
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



module clock_gen(
    input clock_100Mhz,
    input [31:0] freq, //the number needed for the frequency that you want
    output reg clk
    );
    
    reg [31:0] count = 0;
    reg [31:0] m;
        
    always @ (posedge clock_100Mhz) begin
    m = 100000000/(2*freq) - 1;
    count <= (count == m) ? 0 : count + 1; 
    clk <= (count == 0) ? ~clk : clk;
    end
    
endmodule
