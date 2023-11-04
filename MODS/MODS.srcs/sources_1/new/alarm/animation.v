`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2023 22:36:03
// Design Name: 
// Module Name: main_mod
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


module animation (
    input clock, 
    input [12:0] pixel_index,
    output reg [15:0] oled_data,
    input btnC,
    input left,
    input alarm_unlocked,
    inout PS2Clk,
    inout PS2Data
);

//for the mouse
    // wire [11:0] xpos, ypos;    
    // wire [3:0] zpos;
    // wire left, middle, right, new_event;    
    // reg [11:0] value = 0;
    // reg setx = 0;    
    // reg sety = 0;
    // reg setmax_x = 0;    
    // reg setmax_y = 0;
    // wire rst;

    reg spider_button = 0;
    reg [31:0] spider_timer = 0; //change to spider-timer instead of spider_button
    
    wire [3:0] COUNT_Z;
    wire CLOCK_1HZ;
    clk_sound c4 (clock, CLOCK_1HZ, COUNT_Z);

    wire clk, frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    reg [15:0] white_colour = 16'hFFFF;
    reg [15:0] black_colour = 16'h0000;
    reg [15:0] green_colour = 16'h07E0;
    reg [15:0] brown_colour = 16'h8080;
    reg [15:0] purple_colour = 16'b1011100110011111;
    reg [15:0] yellow_colour = 16'hFF80;
    reg [15:0] darkblue_colour = 16'b0001000101101000;
    reg [15:0] beige_colour = 16'b1111111101010001;
    reg [15:0] turquoise_colour = 16'b1010111011111011;
    reg [15:0] bluewall_colour = 16'b0000000001101001;
    reg [15:0] lightbluewall_colour = 16'b0110101110111000;
    
    reg [12:0] window_border = (96*10) + 8;
    reg [12:0] floor = 5376;
    reg [12:0] bed_leg_1 = 4800 + 52;
    reg [12:0] bed_leg_2 = 4800 + 52 + 40;
    reg [12:0] bed_body = (47*96) + 52;
    reg [12:0] bed_frame = (40*96) + 52 + 40;
    reg [12:0] bedsheet = (44*96) + 52;
    reg [12:0] square_1 = (12*96) + 8 + 2;
    reg [12:0] square_2 = (12*96) + 8 + 2 + 17 + 2;
    reg [12:0] square_3 = (21*96) + 8 + 2;
    reg [12:0] square_4 = (21*96) + 8 + 2 + 17 + 2;
    reg [12:0] body = (38*96) + 52;
    reg [12:0] head_vert = (36*96) + 80;
    reg [12:0] head_horz = (37*96) + 79;
    reg [12:0] z_1_top = (13*96) + 62;
    reg [12:0] z_1_bottom = (18*96) + 62;
    reg [12:0] z_2_top = (21*96) + 69;
    reg [12:0] z_2_bottom = (26*96) + 69;
    reg [12:0] moon_vert = (14*96) + 8 + 2 + 2;
    reg [12:0] moon_horz = (15*96) + 8 + 2 + 1;
    reg [12:0] hair_1 = (36*96) + 88;
    reg [12:0] hair_2 = (37*96) + 90;
    reg [12:0] eyes = (36*96) + 85;
    
    reg [12:0] head_vert_up = (34*96) + 80;
    reg [12:0] head_horz_up = (35*96) + 79;
    reg [12:0] hair_1_up = (34*96) + 88;
    reg [12:0] hair_2_up = (35*96) + 90;
    reg [12:0] eyes_up = (34*96) + 85;
    
    reg [12:0] spider_body = (34*96) + 15;
    reg [12:0] spider_leg1 = (34*96) + 10;
    reg [12:0] spider_legsmall_1 = (36*96) + 9; 
    reg [12:0] spider_leg2 = (39*96) + 10;
    reg [12:0] spider_legsmall_2 = (41*96) + 9;
    reg [12:0] spider_leg3 = (44*96) + 10;
    reg [12:0] spider_legsmall_3 = (46*96) + 9;
    reg [12:0] spider_leg4 = (49*96) + 10;
    reg [12:0] spider_legsmall_4 = (51*96) + 9; 
    reg [12:0] spider_leg5 = (34*96) + 33;
    reg [12:0] spider_legsmall_5 = (36*96) + 37;    
    reg [12:0] spider_leg6 = (39*96) + 33;
    reg [12:0] spider_legsmall_6 = (41*96) + 37; 
    reg [12:0] spider_leg7 = (44*96) + 33;
    reg [12:0] spider_legsmall_7 = (46*96) + 37;
    reg [12:0] spider_leg8 = (49*96) + 33;
    reg [12:0] spider_legsmall_8 = (51*96) + 37;
    reg [12:0] spider_web = (0*96) + 24; 
    reg [12:0] spider_eye_1 = (46*96) + 19;
    reg [12:0] spider_eye_2 = (46*96) + 27;      
    

    
always @(posedge clock) begin
    //day is dark
    if(!alarm_unlocked) begin
        if(COUNT_Z == 1) begin
        //the zzzs
        if (
            //z_1
            ((pixel_index >= z_1_top) && (pixel_index <= z_1_top +  + 96 + 4) && (pixel_index % 96 >= z_1_top % 96) && (pixel_index % 96 <= ((z_1_top % 96) + 4))) || 
            ((pixel_index >= z_1_bottom) && (pixel_index <= z_1_bottom +  + 96 + 4) && (pixel_index % 96 >= z_1_bottom % 96) && (pixel_index % 96 <= ((z_1_bottom % 96) + 4))) || 
            ((pixel_index == (15*96 + 65))) || ((pixel_index == (16*96 + 64))) || ((pixel_index == (17*96 + 63))) ||
            //z_2
            ((pixel_index >= z_2_top) && (pixel_index <= z_2_top +  + 96 + 4) && (pixel_index % 96 >= z_2_top % 96) && (pixel_index % 96 <= ((z_2_top % 96) + 4))) || 
            ((pixel_index >= z_2_bottom) && (pixel_index <= z_2_bottom +  + 96 + 4) && (pixel_index % 96 >= z_2_bottom % 96) && (pixel_index % 96 <= ((z_2_bottom % 96) + 4))) || 
            ((pixel_index == (23*96 + 72))) || ((pixel_index == (24*96 + 71))) || ((pixel_index == (25*96 + 70))) ||
            
            //the moon
            ((pixel_index >= moon_vert) && (pixel_index <= moon_vert +  + 384 + 3) && (pixel_index % 96 >= moon_vert % 96) && (pixel_index % 96 <= ((moon_vert % 96) + 3))) ||
            ((pixel_index >= moon_horz) && (pixel_index <= moon_horz +  + 192 + 5) && (pixel_index % 96 >= moon_horz % 96) && (pixel_index % 96 <= ((moon_horz % 96) + 5))) ||
            
            //stars
            ((pixel_index == (14*96 + 12 + 9))) || ((pixel_index == (17*96 + 9 + 17))) || ((pixel_index == (14*96 + 12 + 4 + 20))) || ((pixel_index == (18*96 + 12 + 4 + 28))) ||
            ((pixel_index == (27*96 + 10 + 3))) || ((pixel_index == (25*96 + 10 + 13))) || ((pixel_index == (23*96 + 10 +28))) || ((pixel_index == (27*96 + 10 + 34)))
        )
        begin 
            oled_data <= white_colour;        
        
        //window scenery colour
        end else if (
            ((pixel_index >= square_1) && (pixel_index <= square_1 + 672 + 17) && (pixel_index % 96 >= square_1 % 96) && (pixel_index % 96 <= ((square_1 % 96) + 17))) || 
            ((pixel_index >= square_2) && (pixel_index <= square_2 + 672 + 17) && (pixel_index % 96 >= square_2 % 96) && (pixel_index % 96 <= ((square_2 % 96) + 17))) ||
            ((pixel_index >= square_3) && (pixel_index <= square_3 + 672 + 17) && (pixel_index % 96 >= square_3 % 96) && (pixel_index % 96 <= ((square_3 % 96) + 17))) ||
            ((pixel_index >= square_4) && (pixel_index <= square_4 + 672 + 17) && (pixel_index % 96 >= square_4 % 96) && (pixel_index % 96 <= ((square_4 % 96) + 17)))
        )
        begin 
            oled_data <= black_colour;
        //hair colour
        end else if (
            ((pixel_index >= hair_1_up) && (pixel_index <= hair_1_up + 1056 + 2) && (pixel_index % 96 >= hair_1_up % 96) && (pixel_index % 96 <= ((hair_1_up % 96) + 2))) || 
            ((pixel_index >= hair_2_up) && (pixel_index <= hair_2_up + 864 + 1) && (pixel_index % 96 >= hair_2_up % 96) && (pixel_index % 96 <= ((hair_2_up % 96) + 1))) ||
            //eyes
            ((pixel_index >= eyes_up) && (pixel_index <= eyes_up + 192 + 1) && (pixel_index % 96 >= eyes_up % 96) && (pixel_index % 96 <= ((eyes_up % 96) + 1)))
        )
        begin
            oled_data <= black_colour;        
        //head colour
        end else if (
            ((pixel_index >= head_vert_up) && (pixel_index <= head_vert_up + 1056 + 9) && (pixel_index % 96 >= head_vert_up % 96) && (pixel_index % 96 <= ((head_vert_up % 96) + 9))) || 
            ((pixel_index >= head_horz_up) && (pixel_index <= head_horz_up + 864 + 11) && (pixel_index % 96 >= head_horz_up % 96) && (pixel_index % 96 <= ((head_horz_up % 96) + 11)))
        )
        begin 
            oled_data <= beige_colour;
        //bedsheet colour
        end else if (
        ((pixel_index >= bedsheet) && (pixel_index <= bedsheet + 288 + 40) && (pixel_index % 96 >= bedsheet % 96) && (pixel_index % 96 <= ((bedsheet % 96) + 39))) ||
        ((pixel_index >= body) && (pixel_index <= body + 864 + 27) && (pixel_index % 96 >= body % 96) && (pixel_index % 96 <= ((body % 96) + 27)))
        )
        begin
            oled_data <= purple_colour;
        //window border and floor and bedframe
        end else if ( 
        ((pixel_index >= window_border) && (pixel_index <= window_border + 1920 + 40) && (pixel_index % 96 >= window_border % 96) && (pixel_index % 96 <= ((window_border % 96) + 40))) ||
         ((pixel_index >= floor) && (pixel_index <= 6145)) ||
         //bed frame
         ((pixel_index >= bed_leg_1) && (pixel_index <= bed_leg_1 + 480 + 3) && (pixel_index % 96 >= bed_leg_1 % 96) && (pixel_index % 96 <= ((bed_leg_1 % 96) + 3))) ||
         ((pixel_index >= bed_leg_2) && (pixel_index <= bed_leg_2 + 480 + 3) && (pixel_index % 96 >= bed_leg_2 % 96) && (pixel_index % 96 <= ((bed_leg_2 % 96) + 3))) ||
         ((pixel_index >= bed_body) && (pixel_index <= bed_body + 288 + 43) && (pixel_index % 96 >= bed_body % 96) && (pixel_index % 96 <= ((bed_body % 96) + 43))) ||
         ((pixel_index >= bed_frame) && (pixel_index <= bed_frame + 576 + 3) && (pixel_index % 96 >= bed_frame % 96) && (pixel_index % 96 <= ((bed_frame % 96) + 3)))           
        ) 
        begin
            oled_data <= brown_colour;
        end else begin
            oled_data <= bluewall_colour;
        end
    end else begin
            if (        
        //the moon
        ((pixel_index >= moon_vert) && (pixel_index <= moon_vert +  + 384 + 3) && (pixel_index % 96 >= moon_vert % 96) && (pixel_index % 96 <= ((moon_vert % 96) + 3))) ||
        ((pixel_index >= moon_horz) && (pixel_index <= moon_horz +  + 192 + 5) && (pixel_index % 96 >= moon_horz % 96) && (pixel_index % 96 <= ((moon_horz % 96) + 5))) ||
        
        //stars
        ((pixel_index == (14*96 + 12 + 9))) || ((pixel_index == (17*96 + 9 + 17))) || ((pixel_index == (14*96 + 12 + 4 + 20))) || ((pixel_index == (18*96 + 12 + 4 + 28))) ||
        ((pixel_index == (27*96 + 10 + 3))) || ((pixel_index == (25*96 + 10 + 13))) || ((pixel_index == (23*96 + 10 +28))) || ((pixel_index == (27*96 + 10 + 34)))
    )
    begin 
        oled_data <= white_colour;        
    
    //window scenery colour
    end else if (
        ((pixel_index >= square_1) && (pixel_index <= square_1 + 672 + 17) && (pixel_index % 96 >= square_1 % 96) && (pixel_index % 96 <= ((square_1 % 96) + 17))) || 
        ((pixel_index >= square_2) && (pixel_index <= square_2 + 672 + 17) && (pixel_index % 96 >= square_2 % 96) && (pixel_index % 96 <= ((square_2 % 96) + 17))) ||
        ((pixel_index >= square_3) && (pixel_index <= square_3 + 672 + 17) && (pixel_index % 96 >= square_3 % 96) && (pixel_index % 96 <= ((square_3 % 96) + 17))) ||
        ((pixel_index >= square_4) && (pixel_index <= square_4 + 672 + 17) && (pixel_index % 96 >= square_4 % 96) && (pixel_index % 96 <= ((square_4 % 96) + 17)))
    )
    begin 
        oled_data <= black_colour;
        //hair colour
        end else if (
            ((pixel_index >= hair_1) && (pixel_index <= hair_1 + 1056 + 2) && (pixel_index % 96 >= hair_1 % 96) && (pixel_index % 96 <= ((hair_1 % 96) + 2))) || 
            ((pixel_index >= hair_2) && (pixel_index <= hair_2 + 864 + 1) && (pixel_index % 96 >= hair_2 % 96) && (pixel_index % 96 <= ((hair_2 % 96) + 1))) ||
            //eyes
            ((pixel_index >= eyes) && (pixel_index <= eyes + 192 + 1) && (pixel_index % 96 >= eyes % 96) && (pixel_index % 96 <= ((eyes % 96) + 1)))
        )
        begin
            oled_data <= black_colour;        
    //head colour
    end else if (
        ((pixel_index >= head_vert) && (pixel_index <= head_vert + 1056 + 9) && (pixel_index % 96 >= head_vert % 96) && (pixel_index % 96 <= ((head_vert % 96) + 9))) || 
        ((pixel_index >= head_horz) && (pixel_index <= head_horz + 864 + 11) && (pixel_index % 96 >= head_horz % 96) && (pixel_index % 96 <= ((head_horz % 96) + 11)))
    )
    begin 
        oled_data <= beige_colour;
    //bedsheet colour
    end else if (
    ((pixel_index >= bedsheet) && (pixel_index <= bedsheet + 288 + 40) && (pixel_index % 96 >= bedsheet % 96) && (pixel_index % 96 <= ((bedsheet % 96) + 39))) ||
    ((pixel_index >= body) && (pixel_index <= body + 864 + 27) && (pixel_index % 96 >= body % 96) && (pixel_index % 96 <= ((body % 96) + 27)))
    )
    begin
        oled_data <= purple_colour;
    //window border and floor and bedframe
    end else if ( 
    ((pixel_index >= window_border) && (pixel_index <= window_border + 1920 + 40) && (pixel_index % 96 >= window_border % 96) && (pixel_index % 96 <= ((window_border % 96) + 40))) ||
     ((pixel_index >= floor) && (pixel_index <= 6145)) ||
     //bed frame
     ((pixel_index >= bed_leg_1) && (pixel_index <= bed_leg_1 + 480 + 3) && (pixel_index % 96 >= bed_leg_1 % 96) && (pixel_index % 96 <= ((bed_leg_1 % 96) + 3))) ||
     ((pixel_index >= bed_leg_2) && (pixel_index <= bed_leg_2 + 480 + 3) && (pixel_index % 96 >= bed_leg_2 % 96) && (pixel_index % 96 <= ((bed_leg_2 % 96) + 3))) ||
     ((pixel_index >= bed_body) && (pixel_index <= bed_body + 288 + 43) && (pixel_index % 96 >= bed_body % 96) && (pixel_index % 96 <= ((bed_body % 96) + 43))) ||
     ((pixel_index >= bed_frame) && (pixel_index <= bed_frame + 576 + 3) && (pixel_index % 96 >= bed_frame % 96) && (pixel_index % 96 <= ((bed_frame % 96) + 3)))           
    ) 
    begin
        oled_data <= brown_colour;
    end else begin
        oled_data <= bluewall_colour;
    end
    end
    
    //MORNING
    end else begin
        if(COUNT_Z == 1) begin
    //the zzzs
    if (
        //z_1
        ((pixel_index >= z_1_top) && (pixel_index <= z_1_top +  + 96 + 4) && (pixel_index % 96 >= z_1_top % 96) && (pixel_index % 96 <= ((z_1_top % 96) + 4))) || 
        ((pixel_index >= z_1_bottom) && (pixel_index <= z_1_bottom +  + 96 + 4) && (pixel_index % 96 >= z_1_bottom % 96) && (pixel_index % 96 <= ((z_1_bottom % 96) + 4))) || 
        ((pixel_index == (15*96 + 65))) || ((pixel_index == (16*96 + 64))) || ((pixel_index == (17*96 + 63))) ||
        //z_2
        ((pixel_index >= z_2_top) && (pixel_index <= z_2_top +  + 96 + 4) && (pixel_index % 96 >= z_2_top % 96) && (pixel_index % 96 <= ((z_2_top % 96) + 4))) || 
        ((pixel_index >= z_2_bottom) && (pixel_index <= z_2_bottom +  + 96 + 4) && (pixel_index % 96 >= z_2_bottom % 96) && (pixel_index % 96 <= ((z_2_bottom % 96) + 4))) || 
        ((pixel_index == (23*96 + 72))) || ((pixel_index == (24*96 + 71))) || ((pixel_index == (25*96 + 70))) 
        
        ) begin
            oled_data <= white_colour;    
        end else if (      
        
        //the moon
        ((pixel_index >= moon_vert) && (pixel_index <= moon_vert +  + 384 + 3) && (pixel_index % 96 >= moon_vert % 96) && (pixel_index % 96 <= ((moon_vert % 96) + 3))) ||
        ((pixel_index >= moon_horz) && (pixel_index <= moon_horz +  + 192 + 5) && (pixel_index % 96 >= moon_horz % 96) && (pixel_index % 96 <= ((moon_horz % 96) + 5)))
        
    )
    begin 
        oled_data <= yellow_colour;        
    
    //window scenery colour
    end else if (
        ((pixel_index >= square_1) && (pixel_index <= square_1 + 672 + 17) && (pixel_index % 96 >= square_1 % 96) && (pixel_index % 96 <= ((square_1 % 96) + 17))) || 
        ((pixel_index >= square_2) && (pixel_index <= square_2 + 672 + 17) && (pixel_index % 96 >= square_2 % 96) && (pixel_index % 96 <= ((square_2 % 96) + 17))) ||
        ((pixel_index >= square_3) && (pixel_index <= square_3 + 672 + 17) && (pixel_index % 96 >= square_3 % 96) && (pixel_index % 96 <= ((square_3 % 96) + 17))) ||
        ((pixel_index >= square_4) && (pixel_index <= square_4 + 672 + 17) && (pixel_index % 96 >= square_4 % 96) && (pixel_index % 96 <= ((square_4 % 96) + 17)))
    )
    begin 
        oled_data <= turquoise_colour;
    //hair colour
    end else if (
        ((pixel_index >= hair_1) && (pixel_index <= hair_1 + 1056 + 2) && (pixel_index % 96 >= hair_1 % 96) && (pixel_index % 96 <= ((hair_1 % 96) + 2))) || 
        ((pixel_index >= hair_2) && (pixel_index <= hair_2 + 864 + 1) && (pixel_index % 96 >= hair_2 % 96) && (pixel_index % 96 <= ((hair_2 % 96) + 1))) ||
        //eyes
        ((pixel_index >= eyes) && (pixel_index <= eyes + 192 + 1) && (pixel_index % 96 >= eyes % 96) && (pixel_index % 96 <= ((eyes % 96) + 1)))
    )
    begin
        oled_data <= black_colour;        
    //head colour
    end else if (
        ((pixel_index >= head_vert) && (pixel_index <= head_vert + 1056 + 9) && (pixel_index % 96 >= head_vert % 96) && (pixel_index % 96 <= ((head_vert % 96) + 9))) || 
        ((pixel_index >= head_horz) && (pixel_index <= head_horz + 864 + 11) && (pixel_index % 96 >= head_horz % 96) && (pixel_index % 96 <= ((head_horz % 96) + 11)))
    )
    begin 
        oled_data <= beige_colour;
    //bedsheet colour
    end else if (
    ((pixel_index >= bedsheet) && (pixel_index <= bedsheet + 288 + 40) && (pixel_index % 96 >= bedsheet % 96) && (pixel_index % 96 <= ((bedsheet % 96) + 39))) ||
    ((pixel_index >= body) && (pixel_index <= body + 864 + 27) && (pixel_index % 96 >= body % 96) && (pixel_index % 96 <= ((body % 96) + 27)))
    )
    begin
        oled_data <= purple_colour;
    //window border and floor and bedframe
    end else if ( 
    ((pixel_index >= window_border) && (pixel_index <= window_border + 1920 + 40) && (pixel_index % 96 >= window_border % 96) && (pixel_index % 96 <= ((window_border % 96) + 40))) ||
     ((pixel_index >= floor) && (pixel_index <= 6145)) ||
     //bed frame
     ((pixel_index >= bed_leg_1) && (pixel_index <= bed_leg_1 + 480 + 3) && (pixel_index % 96 >= bed_leg_1 % 96) && (pixel_index % 96 <= ((bed_leg_1 % 96) + 3))) ||
     ((pixel_index >= bed_leg_2) && (pixel_index <= bed_leg_2 + 480 + 3) && (pixel_index % 96 >= bed_leg_2 % 96) && (pixel_index % 96 <= ((bed_leg_2 % 96) + 3))) ||
     ((pixel_index >= bed_body) && (pixel_index <= bed_body + 288 + 43) && (pixel_index % 96 >= bed_body % 96) && (pixel_index % 96 <= ((bed_body % 96) + 43))) ||
     ((pixel_index >= bed_frame) && (pixel_index <= bed_frame + 576 + 3) && (pixel_index % 96 >= bed_frame % 96) && (pixel_index % 96 <= ((bed_frame % 96) + 3)))           
    ) 
    begin
        oled_data <= brown_colour;
    end else begin
        oled_data <= lightbluewall_colour;
    end
    
    //no zzs
end else begin
        if (        
    //the moon
    ((pixel_index >= moon_vert) && (pixel_index <= moon_vert +  + 384 + 3) && (pixel_index % 96 >= moon_vert % 96) && (pixel_index % 96 <= ((moon_vert % 96) + 3))) ||
    ((pixel_index >= moon_horz) && (pixel_index <= moon_horz +  + 192 + 5) && (pixel_index % 96 >= moon_horz % 96) && (pixel_index % 96 <= ((moon_horz % 96) + 5))) 
)
begin 
    oled_data <= yellow_colour;        

//window scenery colour
end else if (
    ((pixel_index >= square_1) && (pixel_index <= square_1 + 672 + 17) && (pixel_index % 96 >= square_1 % 96) && (pixel_index % 96 <= ((square_1 % 96) + 17))) || 
    ((pixel_index >= square_2) && (pixel_index <= square_2 + 672 + 17) && (pixel_index % 96 >= square_2 % 96) && (pixel_index % 96 <= ((square_2 % 96) + 17))) ||
    ((pixel_index >= square_3) && (pixel_index <= square_3 + 672 + 17) && (pixel_index % 96 >= square_3 % 96) && (pixel_index % 96 <= ((square_3 % 96) + 17))) ||
    ((pixel_index >= square_4) && (pixel_index <= square_4 + 672 + 17) && (pixel_index % 96 >= square_4 % 96) && (pixel_index % 96 <= ((square_4 % 96) + 17)))
)
begin 
    oled_data <= turquoise_colour;
    //hair colour
    end else if (
        ((pixel_index >= hair_1_up) && (pixel_index <= hair_1_up + 1056 + 2) && (pixel_index % 96 >= hair_1_up % 96) && (pixel_index % 96 <= ((hair_1_up % 96) + 2))) || 
        ((pixel_index >= hair_2_up) && (pixel_index <= hair_2_up + 864 + 1) && (pixel_index % 96 >= hair_2_up % 96) && (pixel_index % 96 <= ((hair_2_up % 96) + 1))) ||
        //eyes
        ((pixel_index >= eyes_up) && (pixel_index <= eyes_up + 192 + 1) && (pixel_index % 96 >= eyes_up % 96) && (pixel_index % 96 <= ((eyes_up % 96) + 1)))
    )
    begin
        oled_data <= black_colour;        
    //head colour
    end else if (
        ((pixel_index >= head_vert_up) && (pixel_index <= head_vert_up + 1056 + 9) && (pixel_index % 96 >= head_vert_up % 96) && (pixel_index % 96 <= ((head_vert_up % 96) + 9))) || 
        ((pixel_index >= head_horz_up) && (pixel_index <= head_horz_up + 864 + 11) && (pixel_index % 96 >= head_horz_up % 96) && (pixel_index % 96 <= ((head_horz_up % 96) + 11)))
    )
    begin 
        oled_data <= beige_colour;
//bedsheet colour
end else if (
((pixel_index >= bedsheet) && (pixel_index <= bedsheet + 288 + 40) && (pixel_index % 96 >= bedsheet % 96) && (pixel_index % 96 <= ((bedsheet % 96) + 39))) ||
((pixel_index >= body) && (pixel_index <= body + 864 + 27) && (pixel_index % 96 >= body % 96) && (pixel_index % 96 <= ((body % 96) + 27)))
)
begin
    oled_data <= purple_colour;
//window border and floor and bedframe
end else if ( 
((pixel_index >= window_border) && (pixel_index <= window_border + 1920 + 40) && (pixel_index % 96 >= window_border % 96) && (pixel_index % 96 <= ((window_border % 96) + 40))) ||
 ((pixel_index >= floor) && (pixel_index <= 6145)) ||
 //bed frame
 ((pixel_index >= bed_leg_1) && (pixel_index <= bed_leg_1 + 480 + 3) && (pixel_index % 96 >= bed_leg_1 % 96) && (pixel_index % 96 <= ((bed_leg_1 % 96) + 3))) ||
 ((pixel_index >= bed_leg_2) && (pixel_index <= bed_leg_2 + 480 + 3) && (pixel_index % 96 >= bed_leg_2 % 96) && (pixel_index % 96 <= ((bed_leg_2 % 96) + 3))) ||
 ((pixel_index >= bed_body) && (pixel_index <= bed_body + 288 + 43) && (pixel_index % 96 >= bed_body % 96) && (pixel_index % 96 <= ((bed_body % 96) + 43))) ||
 ((pixel_index >= bed_frame) && (pixel_index <= bed_frame + 576 + 3) && (pixel_index % 96 >= bed_frame % 96) && (pixel_index % 96 <= ((bed_frame % 96) + 3)))           
) 
begin
    oled_data <= brown_colour;
end else begin
    oled_data <= lightbluewall_colour;
end
end
end

//logic for spider
   if(left) begin
     spider_button <= 1;
     spider_timer <= 0;
end
  
  if(!alarm_unlocked) begin
 if (spider_timer <= 300_000_000) begin
     spider_timer <= spider_timer + 1;
     spider_button <= 0;
 end else begin
     if(spider_button == 0) 
        if(
         ((pixel_index >= spider_web) && (pixel_index < spider_web + (33*96) + 1) && (pixel_index % 96 >= spider_web % 96) && (pixel_index % 96 < ((spider_web % 96) + 1))) ||
         //eyes
         ((pixel_index >= spider_eye_1) && (pixel_index < spider_eye_1 + (1*96) + 2) && (pixel_index % 96 >= spider_eye_1 % 96) && (pixel_index % 96 < ((spider_eye_1 % 96) + 2))) ||
         ((pixel_index >= spider_eye_2) && (pixel_index < spider_eye_2 + (1*96) + 2) && (pixel_index % 96 >= spider_eye_2 % 96) && (pixel_index % 96 < ((spider_eye_2 % 96) + 2)))            
         ) 
         begin
             oled_data <= white_colour;
    //the spider body
             end else if(
             ((pixel_index >= spider_body) && (pixel_index < spider_body + (18*96) + 18) && (pixel_index % 96 >= spider_body % 96) && (pixel_index % 96 < ((spider_body % 96) + 18))) ||
             ((pixel_index >= spider_leg1) && (pixel_index < spider_leg1 + (1*96) + 5) && (pixel_index % 96 >= spider_leg1 % 96) && (pixel_index % 96 < ((spider_leg1 % 96) + 5))) ||
             ((pixel_index >= spider_legsmall_1) && (pixel_index < spider_legsmall_1 + (1*96) + 2) && (pixel_index % 96 >= spider_legsmall_1 % 96) && (pixel_index % 96 < ((spider_legsmall_1 % 96) + 2))) ||    
             ((pixel_index >= spider_leg2) && (pixel_index < spider_leg2 + (1*96) + 5) && (pixel_index % 96 >= spider_leg2 % 96) && (pixel_index % 96 < ((spider_leg2 % 96) + 5))) ||
             ((pixel_index >= spider_legsmall_2) && (pixel_index < spider_legsmall_2 + (1*96) + 2) && (pixel_index % 96 >= spider_legsmall_2 % 96) && (pixel_index % 96 < ((spider_legsmall_2 % 96) + 2))) ||     
             ((pixel_index >= spider_leg3) && (pixel_index < spider_leg3 + (1*96) + 5) && (pixel_index % 96 >= spider_leg3 % 96) && (pixel_index % 96 < ((spider_leg3 % 96) + 5))) ||
             ((pixel_index >= spider_legsmall_3) && (pixel_index < spider_legsmall_3 + (1*96) + 2) && (pixel_index % 96 >= spider_legsmall_3 % 96) && (pixel_index % 96 < ((spider_legsmall_3 % 96) + 2))) ||   
             ((pixel_index >= spider_leg4) && (pixel_index < spider_leg4 + (1*96) + 5) && (pixel_index % 96 >= spider_leg4 % 96) && (pixel_index % 96 < ((spider_leg4 % 96) + 5))) ||
             ((pixel_index >= spider_legsmall_4) && (pixel_index < spider_legsmall_4 + (1*96) + 2) && (pixel_index % 96 >= spider_legsmall_4 % 96) && (pixel_index % 96 < ((spider_legsmall_4 % 96) + 2)))  ||          
             ((pixel_index >= spider_leg5) && (pixel_index < spider_leg5 + (1*96) + 5) && (pixel_index % 96 >= spider_leg5 % 96) && (pixel_index % 96 < ((spider_leg5 % 96) + 5))) ||
             ((pixel_index >= spider_legsmall_5) && (pixel_index < spider_legsmall_5 + (1*96) + 2) && (pixel_index % 96 >= spider_legsmall_5 % 96) && (pixel_index % 96 < ((spider_legsmall_5 % 96) + 2)))  ||
             
             ((pixel_index >= spider_leg6) && (pixel_index < spider_leg6 + (1*96) + 5) && (pixel_index % 96 >= spider_leg6 % 96) && (pixel_index % 96 < ((spider_leg6 % 96) + 5))) ||
             ((pixel_index >= spider_legsmall_6) && (pixel_index < spider_legsmall_6 + (1*96) + 2) && (pixel_index % 96 >= spider_legsmall_6 % 96) && (pixel_index % 96 < ((spider_legsmall_6 % 96) + 2)))  ||
             
             ((pixel_index >= spider_leg7) && (pixel_index < spider_leg7 + (1*96) + 5) && (pixel_index % 96 >= spider_leg7 % 96) && (pixel_index % 96 < ((spider_leg7 % 96) + 5))) ||
             ((pixel_index >= spider_legsmall_7) && (pixel_index < spider_legsmall_7 + (1*96) + 2) && (pixel_index % 96 >= spider_legsmall_7 % 96) && (pixel_index % 96 < ((spider_legsmall_7 % 96) + 2)))  ||
           
             ((pixel_index >= spider_leg8) && (pixel_index < spider_leg8 + (1*96) + 5) && (pixel_index % 96 >= spider_leg8 % 96) && (pixel_index % 96 < ((spider_leg8 % 96) + 5))) ||
             ((pixel_index >= spider_legsmall_8) && (pixel_index < spider_legsmall_8 + (1*96) + 2) && (pixel_index % 96 >= spider_legsmall_8 % 96) && (pixel_index % 96 < ((spider_legsmall_8 % 96) + 2)))                  
             )
             begin
                 oled_data <= black_colour;  
             end
        
 end
 end
       
 end  
   

    // new_clock clk6p25m (6250000, clock, clk);
     // MouseCtl (.clk(clock), .rst(rst), .xpos(xpos), .ypos(ypos), .zpos(zpos),    .left(left), .middle(middle), .right(right), .new_event(new_event), 
              // .value(value), .setx(setx), .sety(sety), .setmax_x(setmax_x), .setmax_y(setmax_y),  .ps2_clk(PS2Clk), .ps2_data(PS2Data) );
endmodule
