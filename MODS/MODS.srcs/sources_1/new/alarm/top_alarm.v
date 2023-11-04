`timescale 1ns / 1ps

module top_alarm(
    input clk_100MHz,       // from Basys 3
    input reset,            // btnC
    input sw0,

    input left,
    input [12:0] pixel_index,
    
    output [6:0] seg,       // 7 segment display segment pattern
    output [3:0] an,      // 7 segment display anodes
    output led0,
    //for the alarm
    output [15:1] led,
    output [3:0] JXADC,
    //for the animation
    output [15:0] oled_data,
    input sw1,
    inout PS2Clk,
    inout PS2Data
    );
    
    // Internal wires for connecting inner modules
    wire w_10Hz;
    wire [3:0] w_1s, w_10s, w_100s, w_1000s;
    wire w_alarm_unlocked;
    wire [31:0] spider_timer;
    
    // Instantiate inner design modules
    tenHz_gen hz10(.clk_100MHz(clk_100MHz), .reset(reset), .clk_10Hz(w_10Hz));
    
    digits digs(.clk_10Hz(w_10Hz), .reset(reset), .switch_down(sw0), .ones(w_1s), 
                    .tens(w_10s), .hundreds(w_100s), .thousands(w_1000s), .alarm_unlocked(w_alarm_unlocked), .sw1(sw1));
    
    seg7_control seg7(.clk_100MHz(clk_100MHz), .reset(reset), .ones(w_1s), .tens(w_10s),
                      .hundreds(w_100s), .thousands(w_1000s), .seg(seg), .an(an));
                      
    alarm_starter a1(clk_100MHz, led0, sw0, w_1s, w_10s, w_100s, w_1000s, w_alarm_unlocked);
    
    alarm a2 (
        .clock_100Mhz(clk_100MHz),
        .led(led),
        .JXADC(JXADC), .alarm_unlocked(w_alarm_unlocked)
    );
    
    animation a3(.clock(clk_100MHz), .pixel_index(pixel_index), .oled_data(oled_data), .btnC(reset), .left(left), .alarm_unlocked(w_alarm_unlocked), .PS2Clk(PS2Clk), .PS2Data(PS2Data));

 
endmodule