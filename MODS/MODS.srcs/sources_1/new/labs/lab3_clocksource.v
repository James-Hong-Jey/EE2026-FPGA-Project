`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2023 09:34:40
// Design Name: 
// Module Name: clock_source
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

module blinky(
    input CLOCK,
    output [0:0]led
    );
    wire SLOW_CLOCK;

    slow_blinky sb1 (CLOCK, SLOW_CLOCK);
    assign led[0] = SLOW_CLOCK;
endmodule


module slow_blinky(
    input CLOCK,
    output OUT
    );
    reg [4:0] COUNT = 0;
    reg SLOW_CLOCK = 0;

    assign OUT = SLOW_CLOCK;

    always @ (posedge CLOCK) begin
        COUNT <= COUNT + 1; // Note: this will only reset on overflow, making COUNT large means never reset
        SLOW_CLOCK <= ( COUNT == 4'b0000 ) ? ~SLOW_CLOCK : SLOW_CLOCK;
    end
endmodule


// IMPORTANT NOTE clock period is 10ns (100MHz) so all calc below /10

module twenty_hertz (
    input CLOCK,
    output reg SLOW_CLOCK
    );
    reg [32:0] COUNT = 0;

    // 1/20 = 0.05
    // 0.05 / 2 / 10^-9 = 25 million

    always @ (posedge CLOCK) begin
        COUNT <= ( COUNT == 2500000 - 1 ) ? 0 : COUNT + 1;
        SLOW_CLOCK <= ( COUNT == 0 ) ? ~SLOW_CLOCK : SLOW_CLOCK;
    end
endmodule

module five_hertz (
    input CLOCK,
    output reg SLOW_CLOCK
    );
    reg [32:0] COUNT = 0;

    // 1/5 / 2 / 10^-9 = 100 million

    always @ (posedge CLOCK) begin
        COUNT <= ( COUNT == 10000000 - 1) ? 0 : COUNT + 1;
        SLOW_CLOCK <= ( COUNT == 0 ) ? ~SLOW_CLOCK : SLOW_CLOCK;
    end
endmodule

module one_hertz(
    input CLOCK,
    output reg SLOW_CLOCK
    );
    reg [32:0] COUNT = 0;

    // 500 million

    always @ (posedge CLOCK) begin
        COUNT <= (COUNT == 50000000 - 1) ? 0 : COUNT + 1;
        SLOW_CLOCK <= (COUNT == 0) ? ~SLOW_CLOCK : SLOW_CLOCK;
    end
endmodule

module multiplexer (
    input CLOCK,
    input [2:0] sw,
    output reg led
    );

    wire sc20, sc5, sc1, clk;
    reg clk_main = 0;
    reg [32:0] count = 0;

    // Instantiate
    twenty_hertz j (CLOCK, sc20);
    five_hertz k (CLOCK, sc5);
    one_hertz l (CLOCK, sc1);

    always @ (posedge CLOCK) begin
        count <= (count == 3) ? 0 : count + 1;
        clk_main <= (count == 0) ? ~clk_main : clk_main;
    end

    always @ (*) begin
        case(sw)
            3'b001:
                begin
                    led  <= sc20;
                end
            3'b010:
                begin
                    led <= sc5;
                end
            3'b100:
                begin
                    led <= sc1;
                end
            default:
                led <= 0;
        endcase
    end
endmodule

// Task 5: depending on switch config, make the led flicker at 20Hz, 5Hz, or 1Hz
module task_5_control_module (
    input CLOCK,
    input [2:0] sw,
    output [0:0] led
    );
    
    multiplexer m1 (CLOCK, sw, led);
    
endmodule