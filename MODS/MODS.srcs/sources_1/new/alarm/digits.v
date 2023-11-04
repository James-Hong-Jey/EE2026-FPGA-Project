`timescale 1ns / 1ps

module digits(
    input clk_10Hz,
    input reset,
    input switch_down,  // New input for counting direction control
    output reg [3:0] ones,
    output reg [3:0] tens,
    output reg [3:0] hundreds,
    output reg [3:0] thousands,
    input alarm_unlocked,
    input sw1
    );
   
    
    // ones reg control
    always @(posedge clk_10Hz or posedge reset)
        if(sw1 == 0)     
        if(alarm_unlocked == 0)
        if (reset)
            ones <= 0;
        else if (switch_down)
            if (ones == 0)
                ones <= 9;
            else
                ones <= ones - 1;
        else
            if (ones == 9)
                ones <= 0;
            else
                ones <= ones + 1;
         
// tens reg control       
    always @(posedge clk_10Hz or posedge reset)
    if(sw1 == 0)  
    if(alarm_unlocked == 0)
        if (reset) begin
            tens <= 0;
        end else if (switch_down) begin
            if (ones == 0)
                if (tens == 0)
                    tens <= 9;
            else
                tens <= tens - 1;
        end else begin
            if (ones == 9)
                if (tens == 9)
                    tens <= 0;
                else
                    tens <= tens + 1;
        end


      
    // hundreds reg control              
    always @(posedge clk_10Hz or posedge reset)
    if(sw1 == 0)  
    if(alarm_unlocked == 0)
        if (reset) begin
            hundreds <= 0;
        end else if (switch_down) begin
            if (ones == 0)
                if (tens == 0)
                    if (hundreds == 0)
                            hundreds <= 9;
                        else
                        hundreds <= hundreds - 1;
        end else begin
            if (tens == 9 && ones == 9)
                if (hundreds == 9)
                    hundreds <= 0;
                else
                    hundreds <= hundreds + 1;
        end
     
    // thousands reg control                
    always @(posedge clk_10Hz or posedge reset)
    if(sw1 == 0) 
    if(alarm_unlocked == 0)
        if (reset) begin
            thousands <= 0;
        end else if (switch_down) begin
            if (ones == 0)
                if(tens == 0)
                    if(hundreds == 0)
                        if(thousands == 0)
                        thousands <= 9;
            else
                thousands <= thousands - 1;
        end else begin
            if (hundreds == 9 && tens == 9 && ones == 9)
                if (thousands == 9)
                    thousands <= 0;
                else
                    thousands <= thousands + 1;
       end
endmodule
