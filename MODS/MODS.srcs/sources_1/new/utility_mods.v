/**  
 * usage:
 * new_clock clk625M (6250000, clock, <output>);
 */ 
module new_clock (input [32:0] frequency, input clock, output reg SLOW_CLOCK);
    reg [32:0] COUNT = 0;
    // Equation: 1 / frequency / 2 / 10^-8 / 10
    always @ (posedge clock) begin
        COUNT <= (COUNT == 100000000 / frequency / 2 - 1) ? 0 : COUNT + 1;
        SLOW_CLOCK <= (COUNT == 0) ? ~SLOW_CLOCK : SLOW_CLOCK;
    end
endmodule

/**
 * This is to turn the pixel index into X and Y coordinates 
 */
module xy (input [12:0] pixel_index, output [6:0] x, y);
    assign x = pixel_index % `WIDTH;
    assign y = pixel_index / `WIDTH;
endmodule

/**
 * Makes a 3x3 cursor around the mouse position
 */
module cursor (
    input clock,
    input [15:0] color,
    input [6:0] x, y,
    input [11:0] xpos, ypos,
    output reg [15:0] oled_data
    );
    
    always @ (posedge clock) begin
        if( x >= xpos - 1 && x <= xpos + 1 && y >= ypos - 1 && y <= ypos + 1) begin
            oled_data <= color;
        end else oled_data <= 0;
    end
endmodule