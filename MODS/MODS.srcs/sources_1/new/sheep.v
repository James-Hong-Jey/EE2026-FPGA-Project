`timescale 1ns / 1ps
`include "constants.vh"

module sheep (
    input clock, 
    input [12:0] pixel_index,
    input [15:0] sw,
    input left,
    inout PS2Clk,
    inout PS2Data,
    output reg [15:0] led_values,
    output [3:0] an,
    output reg [6:0]seg = 7'b1111111,
    output reg [15:0] oled_data
);
    wire clk2500;
    new_clock(.frequency(5000), .clock(clock), .SLOW_CLOCK(clk2500));
    
    wire [6:0] x, y;
    xy(pixel_index, x, y);

    // Define colors for sky, grass, and clouds
    wire [15:0] sky_color = 16'h00FF; // Blue sky
    wire [15:0] grass_color = 16'h03E0; // Green grass
    wire [15:0] clouds_color = 16'hFFFF; // White clouds

    // Define colors for the sheep's body and head
    wire [15:0] sheep_body_color = 16'hFFFF; // Light brown
    wire [15:0] sheep_head_color = 16'h0000; // White

    // Define the initial position and boundaries of the sheep
    reg [6:0] sheep_x = 0; // X-coordinate of the sheep
    reg [6:0] sheep_y = 30; // Y-coordinate of the sheep (constant)
    reg [6:0] sheep_left_bound = 0; // Left boundary
    reg [6:0] sheep_right_bound = 80; // Right boundary

    // Counter for sheep movement
    reg [7:0] sheep_move_counter = 0;
    reg [7:0] sheep_jump_counter = 0; // Counter for the jumping motion
    reg [15:0] sheep_jump_timer = 0;
    reg sheep_jumping = 0;
    parameter sheep_ground_y = 30;
    
    // Define the fence position
    reg [6:0] fence_x = 45; // X-coordinate of the fence
    reg [6:0] fence_top = 42; // Top boundary of the fence
    reg [6:0] fence_bottom = 55; // Bottom boundary of the fence
    
    // Declare sun parameters
    parameter sun_x = 50; // X-coordinate of the sun
    parameter sun_y = 7; // Y-coordinate of the sun
    parameter sun_radius = 10; // Radius of the sun
    parameter sun_color = 16'hFFE0; // Color of the sun (for example, yellow)
    
    // Update the pixel color based on the sheep's position
    always @* begin
        if (x >= sheep_x && x <= sheep_x + 20 && y >= sheep_y && y <= sheep_y + 20) begin
            oled_data = sheep_body_color; // Set the sheep body color
    
            // Create a face shape on the right side of the sheep
            if (x >= sheep_x + 15 && x <= sheep_x + 20 && y >= sheep_y + 8 && y <= sheep_y + 16) begin
                oled_data = 16'h0000; // Set the color for the face
            end
    
            // Create two small squares at the bottom to represent the legs
            if ((x >= sheep_x + 8 && x <= sheep_x + 10) && (y >= sheep_y + 18 && y <= sheep_y + 21)) begin
                oled_data = 16'h0000; // Set the color for the legs
            end
    
            if ((x >= sheep_x + 13 && x <= sheep_x + 15) && (y >= sheep_y + 18 && y <= sheep_y + 21)) begin
                oled_data = 16'h0000; // Set the color for the legs
            end
        end else if (x >= fence_x && x <= fence_x + 5 && y >= fence_top && y <= fence_bottom) begin
            oled_data = 16'h8B45; // Brown color for the fence
        end else if (x >= sun_x && x <= sun_x + sun_radius && y >= sun_y && y <= sun_y + sun_radius) begin
            oled_data = sun_color; // Set the sun color
        end else if (y >= 48) begin
            oled_data = grass_color; // Set the grass color
        end else begin
            oled_data = sky_color; // Default to the sky color
        end
    end


    reg [11:0] sheep_x_counter = 0;
    // Definitions
    reg [15:0] sheep_jump_timer;
    reg [15:0] max_jump_height;
    reg [7:0] sheep_passed_counter = 0; // Counter for sheep that passed the fence
    
    always @(posedge clk2500) begin
        sheep_move_counter <= sheep_move_counter + 1;
        sheep_x_counter <= sheep_x_counter + 1;
    
        // Handle sheep movement
        if (sheep_x_counter >= 100) begin
            if (sheep_x == sheep_right_bound) begin
                sheep_x <= sheep_left_bound;
                // Increment the counter when the sheep crosses the fence
                sheep_passed_counter <= sheep_passed_counter + 1;
            end else begin
                sheep_x <= sheep_x + 1;
            end
            sheep_x_counter <= 0;
        end
    
        // Handle sheep jumping
        if (left && !sheep_jumping && sheep_y == sheep_ground_y) begin
            sheep_jump_timer <= 3500; // Set the jump duration to 1 second (assuming a 5 MHz clock)
            sheep_jumping <= 1; // Set the jumping state
            max_jump_height <= sheep_y - 7; // Set the maximum jump height
        end
        
        // If jump timer is active, move the sheep up, check for maximum height, and decrement the timer
        if (sheep_jump_timer > 0) begin
            sheep_y <= sheep_ground_y - 17;
            
            // Check if the sheep has reached the maximum jump height
            if (sheep_y == max_jump_height) begin
                // If it has, reset the jump counter and timer
                sheep_jump_counter <= 0;
                sheep_jump_timer <= 0;
            end
            
            sheep_jump_timer <= sheep_jump_timer - 1;
        end
        
        // If the jump timer is not active and the sheep is not at the ground, move it down
        if (!sheep_jumping && sheep_y > sheep_ground_y) begin
            sheep_y <= sheep_y + 1;
        end
    
        // If the jump timer reaches zero, reset the jumping state
        if (sheep_jump_timer == 0) begin
            sheep_jumping <= 0;
            sheep_y <= sheep_ground_y; // Reset sheep to ground level
        end
        
        // Handle sheep-fence collision (reset to starting position)
            if (sheep_x + 20 >= fence_x && sheep_jumping == 0 && sheep_x <= fence_x) begin
                sheep_x <= sheep_left_bound;
                sheep_y <= sheep_ground_y; // Reset the sheep to ground level
                sheep_x_counter <= 0; // Reset the x counter
            end
    end
    
    // Intermediate reg to hold LED values
    reg [8:0] led_values;
    
    // Parameters for segment patterns
    parameter ZERO  = 7'b100_0000;  // 0
    parameter ONE   = 7'b111_1001;  // 1
    parameter TWO   = 7'b010_0100;  // 2 
    parameter THREE = 7'b011_0000;  // 3
    parameter FOUR  = 7'b001_1001;  // 4
    parameter FIVE  = 7'b001_0010;  // 5
    parameter SIX   = 7'b000_0010;  // 6
    parameter SEVEN = 7'b111_1000;  // 7
    parameter EIGHT = 7'b000_0000;  // 8
    parameter NINE  = 7'b001_0000;  // 9
    
    always @* begin
        case (sheep_passed_counter)
            0 : begin
                seg = NINE;
                led_values <= 9'b1_1111_1111;
            end
            1 : begin
                seg = EIGHT;
                led_values <= 9'b0_1111_1111;
            end
            2 : begin
                seg = SEVEN;
                led_values <= 9'b0_0111_1111;
            end
            3 : begin
                seg = SIX;
                led_values <= 9'b0_0011_1111;
            end
            4 : begin
                seg = FIVE;
                led_values <= 9'b0_0001_1111;
            end
            5 : begin
                seg = FOUR;
                led_values <= 9'b0_0000_1111;
            end
            6 : begin
                seg = THREE;
                led_values <= 9'b0_0000_0111;
            end
            7 : begin
                seg = TWO;
                led_values <= 9'b0_0000_0011;
            end
            8 : begin
                seg = ONE;
                led_values <= 9'b0_0000_0001;
            end
            9 : begin
                seg = ZERO;
                led_values <= 9'b0_0000_0000;
            end
            default: begin
                seg = NINE;
                led_values <= 9'b1_1111_1111;
           end
        endcase
    end
    
    assign an[0] = 0;
    assign an[1] = 1;
    assign an[2] = 1;
    assign an[3] = 1;
endmodule
