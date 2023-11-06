`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2023 23:17:25
// Design Name: 
// Module Name: postlab
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

// Subtask B: 2nd rightmost    2
// Subtask D: 5 rightmost      55326
// Subtask D: alphabet         E

module one_hertz(
    input CLOCK,
    input killswitch,
    output reg SLOW_CLOCK
    );
    reg [32:0] COUNT = 0;

    // 500 million

    always @ (posedge CLOCK) begin
        if(killswitch == 0) begin
        COUNT <= (COUNT == 50000000 - 1) ? 0 : COUNT + 1;
        SLOW_CLOCK <= (COUNT == 0) ? ~SLOW_CLOCK : SLOW_CLOCK;
        end
    end
endmodule

module ten_hertz (
    input CLOCK,
    input killswitch,
    output reg SLOW_CLOCK
    );
    reg [32:0] COUNT = 0;

    // 1/10 = 0.1
    // 0.1 / 2 / 10^-8 = 5 million

    always @ (posedge CLOCK) begin
        if(killswitch == 0) begin
        COUNT <= ( COUNT == 5000000 - 1 ) ? 0 : COUNT + 1;
        SLOW_CLOCK <= ( COUNT == 0 ) ? ~SLOW_CLOCK : SLOW_CLOCK;
        end
    end
endmodule

module hundred_hertz (
    input CLOCK,
    input killswitch, 
    output reg SLOW_CLOCK
    );
    reg [32:0] COUNT = 0;

    // 1/100 = 0.01
    // 0.01 / 2 / 10^-8 =  500000

    always @ (posedge CLOCK) begin
        if(killswitch == 0 ) begin
        COUNT <= ( COUNT == 500000 - 1 ) ? 0 : COUNT + 1;
        SLOW_CLOCK <= ( COUNT == 0 ) ? ~SLOW_CLOCK : SLOW_CLOCK;
        end
    end
endmodule

module multiplex (
    input CLOCK,
    input [2:0] sw,
    input killswitch,
    output reg SLOW_CLOCK
    );
    wire clock1, clock10, clock100;
    one_hertz c1 (CLOCK, killswitch, clock1);
    ten_hertz c10 (CLOCK, killswitch, clock10);
    hundred_hertz c100 (CLOCK, killswitch, clock100);

    always @ (posedge CLOCK) begin
        if(sw[2] == 1) SLOW_CLOCK <= clock100;
        else if(sw[1] == 1) SLOW_CLOCK <= clock10;
        else if(sw[0] == 1) SLOW_CLOCK <= clock1;
    end

endmodule

module count_111 (
    input CLOCK,
    input killswitch,
    output reg [3:0] COUNTER
    );
    reg [32:0] COUNT = 0;
    initial COUNTER = 0;

    // 1.11 / 10^-8 = 55500000

    always @ (posedge CLOCK) begin
        if(killswitch == 0) begin
            COUNT <= (COUNT == 111000000 - 1) ? 0 : COUNT + 1;
            COUNTER <= (COUNT == 0 && COUNTER < 9) ? COUNTER + 1 : COUNTER;
        end
    end
endmodule

module led_multiplexer(
    input CLOCK,
    input [15:0] sw,
    output reg [8:0] led
    );
    wire [3:0] led_index;

    // Subtask D
    wire killswitch;
    killCounter k (CLOCK, sw[15], killswitch);

    count_111 c1 (CLOCK, killswitch, led_index);

    wire CLOCK_1HZ;
    one_hertz hz_1 (CLOCK, killswitch, CLOCK_1HZ);
    wire CLOCK_10HZ;
    ten_hertz hz_10 (CLOCK, killswitch, CLOCK_10HZ);
    wire CLOCK_100HZ;
    hundred_hertz hz_100 (CLOCK, killswitch, CLOCK_100HZ);
    

    always @ (posedge CLOCK) begin
        if(killswitch) led <= 9'b001101100;
        else begin
        case(led_index) 
            4'b0000: led = 9'b000000000;
            4'b0001: led = 9'b000000001;
            4'b0010: led = 9'b000000011;
            4'b0011: led = 9'b000000111;
            4'b0100: led = 9'b000001111;
            4'b0101: led = 9'b000011111;
            4'b0110: led = 9'b000111111;
            4'b0111: led = 9'b001111111;
            4'b1000: led = 9'b011111111;
            4'b1001: 
                begin
                    if(sw[2] == 1)
                    begin
                        led[8:3] = 7'b1111111;
                        led[1:0] = 2'b11;
                        led[2] = CLOCK_100HZ;
                    end
                    else if(sw[1] == 1)
                    begin
                        led[8:2] = 7'b1111111;
                        led[0] = 1;
                        led[1] = CLOCK_10HZ;
                    end
                    else if(sw[0] == 1)
                    begin
                        led[8:1] = 8'b11111111;
                        led[0] = CLOCK_1HZ;
                    end
                    else led = 9'b111111111;
                end
            endcase
        end
        end
endmodule

module killCounter (
    input CLOCK,
    input sw15,
    output reg kill
    );

    reg [32:0] counter = 0;
    always @ (posedge CLOCK) begin
        counter <= (sw15 == 1) ? (counter + 1) : 0;
        kill <= (sw15 == 1 && counter > 300000000) ? 1 : 0; 
    end
endmodule

module subtaskb (
    input CLOCK,
    input [4:0] btn, // C U L R D
    input [8:0] led,
    input [2:0] sw,
    input sw15,
    output reg [6:0] seg,
    output reg [3:0] an,
    output reg ledOut
    );

    // Remember: active high
    // These cannot be assigned AFAIK but reference:
    // reg cSeg = 7'b0100111;
    // reg cAn = 4'b1110;
    // reg rSeg = 7'b0101111;
    // reg rAn = 4'b1101;
    // reg dSeg = 7'b0100001;
    // reg dAn = 4'b1011;
    // reg lSeg = 7'b1001111;
    // reg lAn = 4'b0111;

    reg [2:0] step = 0;
    initial begin
        ledOut = 0;
        seg = 7'b1111111;
        an = 4'b1111;
    end

    // Subtask D
    wire killswitch;
    killCounter k (CLOCK, sw15, killswitch);

    // Subtask C
    reg [2:0] counter = 0;
    wire SLOW_CLOCK;
    multiplex m (CLOCK, sw, killswitch, SLOW_CLOCK);
    always @ (posedge SLOW_CLOCK) begin
        if(killswitch == 0) counter <= (counter == 2) ? 0 : counter + 1;
    end

    always @ (posedge CLOCK) begin
        if(killswitch == 1) begin
            seg = 7'b0000110;
            an = 4'b0000;
        end
        else if(led[8] == 1) begin
            if(step == 0) begin
                seg <= 7'b0100111;
                an <= 4'b1110;
                if(btn[0]) step = step + 1;
            end
            else if(step == 1) begin
                seg <= 7'b0101111;
                an <= 4'b1101;
                if(btn[3]) step = step + 1;
            end
            else if(step == 2) begin
                seg <= 7'b0100001;
                an <= 4'b1011;
                if(btn[4]) step = step + 1;
            end
            else if(step == 3) begin
                seg <= 7'b1001111;
                an <= 4'b0111;
                if(btn[2]) step = step + 1;
            end
            else if(step == 4) begin
                seg <= 7'b0101111;
                an <= 4'b1101;
                if(btn[3]) step = step + 1;
            end
            else if (step > 4) begin
                ledOut = 1;
                if(counter == 2) begin
                    seg <= 7'b0100111;
                    an <= 4'b1110;
                end
                else if(counter == 0) begin
                    seg <= 7'b0101111;
                    an <= 4'b1101;
                end
                else if(counter == 1) begin
                    seg <= 7'b0100001;
                    an <= 4'b1011;
                end
            end
            else begin
                // Should never reach this point
                seg = 7'b0101111;
                an = 4'b1101;
            end
        end
        else 
        begin
            // Off
            seg = 7'b1111111;
            an = 4'b1111;
        end
    end
endmodule


module main (
    input CLOCK,
    input [15:0] sw,
    input [4:0] btn,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an
    );
    // Initialisation
    // Subtask D

    
    // Subtask A: 1st rightmost    6
    // LD8 (including) 1.11s
    led_multiplexer m1 (CLOCK, sw, led[8:0]);

    // Subtask B: 2nd Rightmost    2
    // c r d l r
    // Subtask C
    subtaskb b (CLOCK, btn, led[8:0], sw, sw[15], seg, an, led[15]);

    // Test function
    wire killswitch = 0; 
    killCounter k (CLOCK, sw[15], killswitch);

    // Subtask D


endmodule
