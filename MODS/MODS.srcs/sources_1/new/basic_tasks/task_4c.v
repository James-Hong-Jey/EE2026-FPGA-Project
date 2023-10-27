module task_4c(
    input clock,
    input rst, 
    input [12:0] pixel_index,
    input btnC,
    input btnU,
    output reg [15:0] oled_data
    );

    // Define constants for colors
    `include "constants.vh"

    wire [6:0] x, y;
    xy xy_converter (.pixel_index(pixel_index), .x(x), .y(y));

    // Define the red square color
    wire [15:0] red_square_color = `RED;

    // Counter to control the square's movement
    reg [30:0] height_counter = 2; // Initial height is 3
    reg [5:0] square_x = `WIDTH / 2;
    reg [5:0] square_y = 0; // Start at the top

    // Counter for the second rectangle's width increase
    reg [4:0] second_rect_width_counter = 0;
    wire second_rect_activated = (height_counter >= 27) && (square_y + height_counter >= 3);

    // Counter for time
    reg [27:0] time_counter = 0;
    reg [27:0] target_time = 5000000; // 0.5 seconds in 100ns units

    reg btnC_prev = 0; // Previous state of btnC, initialized to 0
    reg btnC_pressed = 0; // Flag to track if btnC has been pressed

    always @(posedge clock) begin

        if(rst) begin
            btnC_prev <= 0; // Previous state of btnC, initialized to 0
            btnC_pressed <= 0; // Flag to track if btnC has been pressed
            second_rect_width_counter <= 0;
            time_counter <= 0;
            target_time <= 5000000; // 0.5 seconds in 100ns units
            height_counter <= 2; // Initial height is 3
            square_x <= `WIDTH / 2;
            square_y <= 0; // Start at the top
        end
        time_counter <= time_counter + 1;

        // Check if btnC is pressed (not held) and if height_counter is still less than 30
        if (btnC && !btnC_prev && height_counter < 30) begin
            // Set the btnC_pressed flag to indicate the button press
            btnC_pressed <= 1;
            time_counter <= 0; // Reset the time counter when button is pressed
        end

        // If btnC was pressed and height_counter is less than 30, increase height
        if (btnC_pressed && height_counter < 30 && time_counter >= target_time) begin
            // Update the square's height
            height_counter <= height_counter + 1;
            time_counter <= 0; // Reset the time counter
        end

        // Update the width increase for the second rectangle only when it's activated
        if (second_rect_activated && second_rect_width_counter < 15 && time_counter >= target_time) begin
            second_rect_width_counter <= second_rect_width_counter + 1;
            time_counter <= 0;
        end

        btnC_prev <= btnC; // Update btnC_prev

        if (time_counter >= target_time) begin
            time_counter <= 0;
        end
    end

    always @* begin
        // Display logic
        if (x >= square_x - 1 && x <= square_x + 1 && y >= square_y && y <= square_y + height_counter) begin
            // Display the red square at the new position
            oled_data <= red_square_color;
        end else if (second_rect_activated && x >= square_x - 1 && x <= square_x + second_rect_width_counter && y >= square_y + 27 && y <= square_y + 30) begin
            // Display the second rectangle at the bottom with a width increase
            oled_data <= red_square_color;
        end else begin
            // Set to black or other background color
            oled_data <= `BLACK;
        end
    end
endmodule