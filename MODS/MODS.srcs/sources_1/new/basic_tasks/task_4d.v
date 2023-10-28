`include "constants.vh"

module button_controls (
    input clock, btnC, btnL, btnR, rst,
    output reg start = 0, reg centre = 0, reg [1:0] move = 0
    );
    // TODO: Debounce???
    
    always @ (posedge clock) begin
        if (rst == 1) begin
            start <= 0;
            centre <= 0;
        end else if (start == 0) begin
            start <= (btnC == 1) ? 1 : start;
            centre <= (btnC == 1) ? 1 : centre;
        end else if (start == 1) begin
            centre <= (btnC == 1) ? 1 : (btnL == 1 || btnR == 1) ? 0 : centre;
            move <= (btnC == 1) ? 0 : (btnL == 1) ? 2'b10 : (btnR == 1) ? 2'b01 : move;
        end
    end
endmodule

module square_controls (
    input clock, start, centre, [1:0] move,
    output reg [6:0] square_top_bound = 0, square_bottom_bound = 4, square_left_bound = 0, square_right_bound = 4
    );

    reg [16:0] COUNT = 0;

    wire clk45;
    new_clock(.frequency(45), .clock(clock), .SLOW_CLOCK(clk45));

    always @ (posedge clk45) begin
        // COUNT <= (COUNT == 69443) ? 0 : COUNT + 1;
        if (start == 0) begin
            square_top_bound <= 0;
            square_bottom_bound <= 4;
            square_left_bound <= 0;
            square_right_bound <= 4;
        end
        else if (start == 1) begin
            if (centre == 1) begin
                square_top_bound <= 29;
                square_bottom_bound <= 33;
                square_left_bound <= 46;
                square_right_bound <= 50;
            end
            else if (COUNT == 0) begin
            // else begin
                if (move == 2'b10 && square_left_bound > 0) begin
                    square_left_bound <= square_left_bound - 1;
                    square_right_bound <= square_right_bound - 1;
                end
                else if (move == 2'b01 && square_right_bound < 95) begin
                    square_left_bound <= square_left_bound + 1;
                    square_right_bound <= square_right_bound + 1;
                end
            end
        end
    end
endmodule

/*
module draw_box (
    input [6:0] x, y,
    input [15:0] main_col, bg_col,
    input [6:0] square_top_bound, square_bottom_bound, square_left_bound, square_right_bound,
    output [15:0] oled_data
    );
    assign oled_data = (x >= square_left_bound && x <= square_right_bound && y <= square_bottom_bound && y >= square_top_bound)
            ? main_col : bg_col;
endmodule
*/

module task_4d (
    input clock, rst, btnC, btnL, btnR, btnU,
    input [12:0] pixel_index,
    output [15:0] oled_data
    );

    wire start, centre;
    wire [1:0] move;
    button_controls (clock, btnC, btnL, btnR, rst, start, centre, move);

    wire [6:0] square_top_bound, square_bottom_bound, square_left_bound, square_right_bound;
    square_controls (clock, start, centre, move, square_top_bound, square_bottom_bound, square_left_bound, square_right_bound);

    wire [6:0] x, y;
    xy(pixel_index, x, y);
    wire [15:0] oled_blue, oled_green;
    draw_box(x, y, `BLUE, `BLACK, square_top_bound, square_bottom_bound, square_left_bound, square_right_bound, oled_blue);
    draw_box(x, y, `GREEN, `BLACK, square_top_bound, square_bottom_bound, square_left_bound, square_right_bound, oled_green);
    assign oled_data = start ? oled_green : oled_blue;
endmodule