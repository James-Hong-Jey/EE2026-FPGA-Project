`timescale 1ns / 1ps

module task_4b (
    input clock, btnC, btnL, btnR, 
    input [12:0] pixel_index, 
    output reg [15:0] oled_data
    );

    //for debouncing
    reg [32:0] DEBOUNCE_LEFT = 0;
    reg [32:0] DEBOUNCE_RIGHT = 0;
    
    reg [15:0] white_colour = 16'hFFFF;
    reg [15:0] black_colour = 16'h0000;
    reg [15:0] green_colour = 16'h07E0;
    
    //squares
    reg [12:0] square_1 = 2701;
    reg [12:0] square_2 = 2718;
    reg [12:0] square_3 = 2735;
    reg [12:0] square_4 = 2752;
    reg [12:0] square_5 = 2769;

    //counter for the square 0 to 4
    reg [2:0] counter = 2;
    
    // Delay counter
    reg [31:0] delay_counter = 0;
    reg delay_done = 0;
    
    initial begin 
        oled_data = 16'h0000; // the specific colour
    end

    always @(posedge clock) begin
        //delay clock
        if (!delay_done) begin
            delay_counter <= delay_counter + 1;
            if (delay_counter == 3 * 100000000) begin
                delay_done <= 1;
            end
        end

        //green border initially
        if (pixel_index >= ((square_3 - (5*96)) - 5) && (pixel_index < square_3 + 1152 + 18) && (pixel_index % 96 >= ((square_3 - (5*96)) - 5) % 96) && (pixel_index % 96 <= ((((square_3 - (5*96)) - 5) % 96) + 18)) &&
                    !((pixel_index >= ((square_3 - (2*96)) - 2) && (pixel_index < square_3 + 864 + 12) && (pixel_index % 96 >= ((square_3 - (2*96)) - 2) % 96) && (pixel_index % 96 <= (((square_3 - (2*96)) - 2) % 96) + 12)))) begin
                        oled_data <= green_colour;
        end else begin
            oled_data <= 16'h0000;
        end  
        if (delay_done == 1) begin
            //start the drawing
            if ((pixel_index >= 0 && pixel_index < 2688) || (pixel_index >= 3455 && pixel_index <= 6145)) begin
                // If pixel_index is in one of the black segments, set oled_data to black
                oled_data <= black_colour;
            end else begin
                // If not in a black segment, check if it's in a white segment
                if (
                //square 1
                (pixel_index >= square_1) && (pixel_index < square_1 + 768 + 8) && (pixel_index % 96 >= square_1 % 96) && (pixel_index % 96 <= ((square_1 % 96) + 8)) ||
                //square 2
                (pixel_index >= square_2) && (pixel_index < square_2 + 768 + 8) && (pixel_index % 96 >= square_2 % 96) && (pixel_index % 96 <= ((square_2 % 96) + 8)) || //mod it for the column number
                //square 3
                (pixel_index >= square_3) && (pixel_index < square_3 + 768 + 8) && (pixel_index % 96 >= square_3 % 96) && (pixel_index % 96 <= ((square_3 % 96) + 8)) ||
                //square 4
                (pixel_index >= square_4) && (pixel_index < square_4 + 768 + 8) && (pixel_index % 96 >= square_4 % 96) && (pixel_index % 96 <= ((square_4 % 96) + 8)) ||
                //square 5
                (pixel_index >= square_5) && (pixel_index < square_5 + 768 + 8) && (pixel_index % 96 >= square_5 % 96) && (pixel_index % 96 <= ((square_5 % 96) + 8))
            
                ) 
                    begin
                    // If in a white segment, set oled_data to white
                    oled_data <= white_colour;
                end else begin

                        // If not in a white segment, set oled_data to black
                        oled_data <= black_colour;
                    end
                end
                
            // Debounce btnL
            if(DEBOUNCE_LEFT > 0) begin
                DEBOUNCE_LEFT <= DEBOUNCE_LEFT - 1;
                
            end
            if(btnL == 1 && DEBOUNCE_LEFT == 0 && counter > 0) begin
            // 500ms debounce -> 100 * 10^-3 / 10^-8
                DEBOUNCE_LEFT <= 20000000;    
                counter <= counter - 1;              
            end
                
            // Debounce btnR
            if(DEBOUNCE_RIGHT > 0) begin
                DEBOUNCE_RIGHT <= DEBOUNCE_RIGHT - 1;
            end
            if(btnR == 1 && DEBOUNCE_RIGHT == 0 && counter < 4) begin
            // 500ms debounce -> 100 * 10^-3 / 10^-8
                DEBOUNCE_RIGHT <= 20000000;    
                counter <= counter + 1;                     
            end
            
            //set the border for the different counters
            if (counter == 0) begin
                if (pixel_index >= ((square_1 - (5*96)) - 5) && (pixel_index < square_1 + 1152 + 18) && (pixel_index % 96 >= ((square_1 - (5*96)) - 5) % 96) && (pixel_index % 96 <= ((((square_1 - (5*96)) - 5) % 96) + 18)) &&
                !((pixel_index >= ((square_1 - (2*96)) - 2) && (pixel_index < square_1 + 864 + 12) && (pixel_index % 96 >= ((square_1 - (2*96)) - 2) % 96) && (pixel_index % 96 <= (((square_1 - (2*96)) - 2) % 96) + 12)))) begin
                    oled_data <= green_colour;
                end
            end

            if (counter == 1) begin
                if (pixel_index >= ((square_2 - (5*96)) - 5) && (pixel_index < square_2 + 1152 + 18) && (pixel_index % 96 >= ((square_2 - (5*96)) - 5) % 96) && (pixel_index % 96 <= ((((square_2 - (5*96)) - 5) % 96) + 18)) &&
                    !((pixel_index >= ((square_2 - (2*96)) - 2) && (pixel_index < square_2 + 864 + 12) && (pixel_index % 96 >= ((square_2 - (2*96)) - 2) % 96) && (pixel_index % 96 <= (((square_2 - (2*96)) - 2) % 96) + 12)))) begin
                    oled_data <= green_colour;
                end
            end
            if (counter == 2) begin
                if (pixel_index >= ((square_3 - (5*96)) - 5) && (pixel_index < square_3 + 1152 + 18) && (pixel_index % 96 >= ((square_3 - (5*96)) - 5) % 96) && (pixel_index % 96 <= ((((square_3 - (5*96)) - 5) % 96) + 18)) &&
                    !((pixel_index >= ((square_3 - (2*96)) - 2) && (pixel_index < square_3 + 864 + 12) && (pixel_index % 96 >= ((square_3 - (2*96)) - 2) % 96) && (pixel_index % 96 <= (((square_3 - (2*96)) - 2) % 96) + 12)))) begin
                        oled_data <= green_colour;
                end
            end
            if (counter == 3) begin
                if (pixel_index >= ((square_4 - (5*96)) - 5) && (pixel_index < square_4 + 1152 + 18) && (pixel_index % 96 >= ((square_4 - (5*96)) - 5) % 96) && (pixel_index % 96 <= ((((square_4 - (5*96)) - 5) % 96) + 18)) &&
                    !((pixel_index >= ((square_4 - (2*96)) - 2) && (pixel_index < square_4 + 864 + 12) && (pixel_index % 96 >= ((square_4 - (2*96)) - 2) % 96) && (pixel_index % 96 <= (((square_4 - (2*96)) - 2) % 96) + 12)))) begin
                        oled_data <= green_colour;
                end
            end
            if (counter == 4) begin
                if (pixel_index >= ((square_5 - (5*96)) - 5) && (pixel_index < square_5 + 1152 + 18) && (pixel_index % 96 >= ((square_5 - (5*96)) - 5) % 96) && (pixel_index % 96 <= ((((square_5 - (5*96)) - 5) % 96) + 18)) &&
                    !((pixel_index >= ((square_5 - (2*96)) - 2) && (pixel_index < square_5 + 864 + 12) && (pixel_index % 96 >= ((square_5 - (2*96)) - 2) % 96) && (pixel_index % 96 <= (((square_5 - (2*96)) - 2) % 96) + 12)))) begin
                        oled_data <= green_colour;
                end
            end
        end
    //end module
    end    
endmodule