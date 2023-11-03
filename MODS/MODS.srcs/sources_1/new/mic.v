`include "constants.vh"

//      Main mic module. 
//      Connect the PMOD MIC3 to the JC top pins
module mic (
    input clock,

    output JC_MIC3_Pin1,
    input JC_MIC3_Pin3,
    output JC_MIC3_Pin4,

    input [12:0] pixel_index,
    output reg [15:0] oled_data,
    output reg [6:0] seg,
    output reg [3:0] an
    );

    wire cs;
    new_clock (20000, clock, cs);
    wire [11:0] mic;
    Audio_Capture(.CLK(clock), .cs(cs), .MISO(JC_MIC3_Pin3), .clk_samp(JC_MIC3_Pin1), .sclk(JC_MIC3_Pin4), .sample(mic));
    wire [11:0] peak_vol;
    peak_intensity(.clock(clock), .mic_in(mic), .peak_vol(peak_vol));

    wire [6:0] x, y;
    xy(pixel_index, x, y);

    reg [11:0] volume_level, man_lift;

    // Draw everything
    wire [15:0] background, floor, sun, window, window_frame, note_yellow, note_red, note_blue, note_cyan, note_magenta, 
    pillow, bed, bed_headboard, bed_base, body, head, angry_head, hair, zed1, zed2, zed3;

    // Draw man
    draw_box(.main_col(`BEIGE), .bg_col(`BLACK), .lefttopx(`WIDTH - 12), .lefttopy(33 - man_lift), .rightbotx(`WIDTH - 4), .rightboty(`HEIGHT - 18 - man_lift), .x(x), .y(y), .oled_data(head));
    draw_box(.main_col(`RED), .bg_col(`BLACK), .lefttopx(`WIDTH - 12), .lefttopy(33 - man_lift), .rightbotx(`WIDTH - 4), .rightboty(`HEIGHT - 18 - man_lift), .x(x), .y(y), .oled_data(angry_head));
    draw_box(.main_col(`BLACK), .bg_col(`BEIGE), .lefttopx(`WIDTH - 6), .lefttopy(33 - man_lift), .rightbotx(`WIDTH - 4), .rightboty(`HEIGHT - 18 - man_lift), .x(x), .y(y), .oled_data(hair));
    draw_box(.main_col(`DARKBLUE), .bg_col(`BLACK), .lefttopx(46), .lefttopy(33 - man_lift), .rightbotx(`WIDTH - 12), .rightboty(`HEIGHT - 18 - man_lift), .x(x), .y(y), .oled_data(body));

    // Draw window, floor, etc
    draw_box(.main_col(`WHITE), .bg_col(`BLACK), .lefttopx(`WIDTH - 12), .lefttopy(36), .rightbotx(`WIDTH - 4), .rightboty(`HEIGHT - 14), .x(x), .y(y), .oled_data(pillow));
    draw_box(.main_col(`CYAN), .bg_col(`BLACK), .lefttopx(44), .lefttopy(38), .rightbotx(`WIDTH - 12), .rightboty(`HEIGHT - 14), .x(x), .y(y), .oled_data(bed));
    draw_box(.main_col(`BROWN), .bg_col(`BLACK), .lefttopx(`WIDTH - 4), .lefttopy(`HEIGHT - 24), .rightbotx(`WIDTH), .rightboty(`HEIGHT - 10), .x(x), .y(y), .oled_data(bed_headboard));
    draw_box(.main_col(`BROWN), .bg_col(`BLACK), .lefttopx(44), .lefttopy(`HEIGHT - 14), .rightbotx(`WIDTH), .rightboty(`HEIGHT - 10), .x(x), .y(y), .oled_data(bed_base));
    draw_box(.main_col(`YELLOW), .bg_col(`BLACK), .lefttopx(15), .lefttopy(15), .rightbotx(20), .rightboty(20), .x(x), .y(y), .oled_data(sun));
    draw_box(.main_col(`LIGHTBLUE), .bg_col(`BLACK), .lefttopx(15), .lefttopy(15), .rightbotx(45), .rightboty(30), .x(x), .y(y), .oled_data(window));
    draw_box(.main_col(`BROWN), .bg_col(`BLACK), .lefttopx(11), .lefttopy(11), .rightbotx(49), .rightboty(34), .x(x), .y(y), .oled_data(window_frame));
    draw_box(.main_col(`ORANGE), .bg_col(`BLACK), .lefttopx(0), .lefttopy(`HEIGHT - 20), .rightbotx(`WIDTH), .rightboty(`HEIGHT), .x(x), .y(y), .oled_data(floor));
    draw_box(.main_col(`GREY), .bg_col(`BLACK), .lefttopx(0), .lefttopy(0), .rightbotx(`WIDTH), .rightboty(`HEIGHT - 20), .x(x), .y(y), .oled_data(background));

    // Draw note
    reg [6:0] centre_x, centre_y;
    // draw_note(.main_col(`RED), .bg_col(`BLACK), .centre_x(centre_x), .centre_y(20), .x(x), .y(y), .oled_data(note_red));
    // draw_note(.main_col(`YELLOW), .bg_col(`BLACK), .centre_x(centre_x + 5), .centre_y(40), .x(x), .y(y), .oled_data(note_yellow));
    // draw_note(.main_col(`MAGENTA), .bg_col(`BLACK), .centre_x(centre_x + 10), .centre_y(50), .x(x), .y(y), .oled_data(note_magenta));
    // draw_note(.main_col(`CYAN), .bg_col(`BLACK), .centre_x(centre_x + 15), .centre_y(30), .x(x), .y(y), .oled_data(note_cyan));
    // draw_note(.main_col(`BLUE), .bg_col(`BLACK), .centre_x(centre_x + 20), .centre_y(10), .x(x), .y(y), .oled_data(note_blue));
    draw_note(.main_col(`RED), .bg_col(`BLACK), .centre_x(80), .centre_y(`HEIGHT -centre_y - 7), .x(x), .y(y), .oled_data(note_red));
    draw_note(.main_col(`YELLOW), .bg_col(`BLACK), .centre_x(60), .centre_y(`HEIGHT -centre_y - 12), .x(x), .y(y), .oled_data(note_yellow));
    draw_note(.main_col(`MAGENTA), .bg_col(`BLACK), .centre_x(50), .centre_y(`HEIGHT -centre_y - 15), .x(x), .y(y), .oled_data(note_magenta));
    draw_note(.main_col(`CYAN), .bg_col(`BLACK), .centre_x(70), .centre_y(`HEIGHT -centre_y - 10), .x(x), .y(y), .oled_data(note_cyan));
    draw_note(.main_col(`BLUE), .bg_col(`BLACK), .centre_x(65), .centre_y(`HEIGHT -centre_y - 5), .x(x), .y(y), .oled_data(note_blue));
    wire moving_note;
    new_clock (50, clock, moving_note);
    always @ (posedge moving_note) begin
        centre_x <= (centre_x >= `WIDTH) ? 0 : centre_x + 1;
        centre_y <= (centre_y >= `HEIGHT) ? 0 : centre_y + 1;
    end

    // Draw Zs
    draw_z(.main_col(`WHITE), .bg_col(`BLACK), .centre_x(80), .centre_y(20), .x(x), .y(y), .oled_data(zed1));
    draw_z(.main_col(`WHITE), .bg_col(`BLACK), .centre_x(70), .centre_y(15), .x(x), .y(y), .oled_data(zed2));
    draw_z(.main_col(`WHITE), .bg_col(`BLACK), .centre_x(60), .centre_y(10), .x(x), .y(y), .oled_data(zed3));
    reg [4:0] sequence = 0;
    wire zzz;
    new_clock (1, clock, zzz);
    always @ (posedge zzz) begin
        sequence <= sequence == 2 ? 0 : sequence + 1;
    end

    // Testing purposes - display volume on 7 seg
    wire fivehertz;
    new_clock (4, clock, fivehertz);
    always @ (posedge fivehertz) begin
        an <= 4'b1110;
        case(volume_level)
        0: seg <= `DIG0;
        1: seg <= `DIG1;
        2: seg <= `DIG2;
        3: seg <= `DIG3;
        4: seg <= `DIG4;
        5: seg <= `DIG5;
        6: seg <= `DIG6;
        7: seg <= `DIG7;
        8: seg <= `DIG8;
        9: seg <= `DIG9;
        default: seg <= `DIGINV;
        endcase
    end

    always @ (posedge clock) begin
        // Need to constantly adjust this 
        volume_level <= peak_vol > 2030 ? (peak_vol - 2030) / 10 : 0;
        man_lift <= volume_level > 5 ? volume_level < 30 ? volume_level : 30 : 0;

        // Layers of objects
        if(note_red && volume_level > 20) begin
            oled_data <= note_red;
        end else if (note_yellow && volume_level > 15) begin
            oled_data <= note_yellow;
        end else if (note_magenta && volume_level > 11) begin
            oled_data <= note_magenta;
        end else if (note_cyan && volume_level > 5) begin
            oled_data <= note_cyan;
        end else if (note_blue && volume_level > 8) begin
            oled_data <= note_blue;
        end else if (zed1 && volume_level <= 5 && sequence == 0) begin
            oled_data <= zed1;
        end else if (zed2 && volume_level <= 5 && sequence == 1) begin
            oled_data <= zed2;
        end else if (zed3 && volume_level <= 5 && sequence == 2) begin
            oled_data <= zed3;
        end else if (hair == `BLACK) begin
            oled_data <= hair;
        end else if (head && volume_level <= 5) begin
            oled_data <= head;
        end else if (angry_head && volume_level > 5) begin
            oled_data <= angry_head;
        end else if (body) begin
            oled_data <= body;
        end else if (pillow) begin
            oled_data <= pillow;
        end else if (bed) begin
            oled_data <= bed;
        end else if (bed_headboard) begin
            oled_data <= bed_headboard;
        end else if (bed_base) begin
            oled_data <= bed_base;
        end else if (sun) begin
            oled_data <= sun;
        end else if (window) begin
            oled_data <= window;
        end else if (window_frame) begin
            oled_data <= window_frame;
        end else if (floor) begin
            oled_data <= floor;
        end else if (background) begin
            oled_data <= background;
        end
    end
endmodule

//      This module takes the raw mic input and then
//      analyses the peak volume over a certain number of samples
module peak_intensity(
    input clock, 
    input [11:0] mic_in,
    output reg [11:0] peak_vol
    );
    reg [31:0] count = 0;
    reg [11:0] value = 0;
 
    // Regular time interval of 0.2 second == 4_000 samples
    always @(posedge clock) begin
        count <= count == 100000000 / 2 / 2 - 1 ? 0 : count + 1;
        //only accept values between 2048 and 4095
        value <= (mic_in >= 2048) ? mic_in : 0;
        peak_vol <= (count == 0) ? value : (value > peak_vol) ? value : peak_vol;
    end
endmodule

//      This module converts serial MIC input into a 12-bit parallel register [11:0]sample.    
//
//      The audio input is sampled by PmodMIC3, the sampling rate of which is assigned to Pin 1 ChipSelect (cs).
//      The Analog-to-Digital Concertor (ADC) on PmodMIC3 converts the audio analog signal into a 16-bit digital form
//      (4-bit leading zeros + 12-bit voice data). The 16 bits are output at PmodMIC3 Pin 3 (MISO) in serial (bit-by-bit)
//      according to a serial clock (sclk) that is assigned to PmodMIC3 Pin 4.
//
//      This module first generates sclk which is to be fed into PmodMIC3 Pin 4. Meanwhile it reads the 16 bits individually
//      while they are available and joins them into a 16-bit register temp. [11:0] sample is the final output represents the
//      12-bit MIC input sample.
module Audio_Capture(
    input CLK,                  // 100MHz clock
    input cs,                   // sampling clock, 20kHz
    input MISO,                 // J_MIC3_Pin3, serial mic input
    output clk_samp,            // J_MIC3_Pin1
    output reg sclk,            // J_MIC3_Pin4, MIC3 serial clock
    output reg [11:0]sample     // 12-bit audio sample data
    );
    
    reg [11:0]count2 = 0;
    reg [11:0]temp = 0;
    
    initial begin
        sclk = 0;
    end
    
    assign clk_samp = cs;
    
    //Creating SPI clock signals
    always @ (posedge CLK) begin
        count2 <= (cs == 0) ? count2 + 1 : 0;
        sclk <= (count2 == 50 || count2 == 100 || count2 == 150 || count2 == 200 || count2 == 250 || count2 == 300 || count2 == 350 || count2 == 400 || count2 == 450 || count2 == 500 || count2 == 550 || count2 == 600 || count2 == 650 || count2 == 700 || count2 == 750 || count2 == 800 || count2 == 850 || count2 == 900 || count2 == 950 || count2 == 1000 ||count2 == 1050 || count2 == 1100 || count2 == 1150 || count2 == 1200 || count2 == 1250 || count2 == 1300 || count2 == 1350 || count2 == 1400 || count2 == 1450 || count2 == 1500 || count2 == 1550 || count2 == 1600) ?  ~sclk  : sclk ;
    end
    
    always @ (negedge sclk) begin
        temp <= temp<<1 | MISO;
    end

    always @ (posedge cs) begin
        sample <= temp[11:0];
    end
endmodule

// Draw a box based on the top left and bottom right coordinates
module draw_box(
    input [15:0] main_col, bg_col,
    input [6:0] lefttopx, lefttopy, rightbotx, rightboty,
    input [6:0] x, y,
    output reg [15:0] oled_data
    );

    always @ (*) begin
        if(
            lefttopx <= x && x <= rightbotx &&
            lefttopy <= y && y <= rightboty
        ) begin
            oled_data <= main_col;
        end else oled_data <= bg_col;
    end
endmodule

module draw_note(
    input [15:0] main_col, bg_col,
    input [6:0] centre_x, centre_y,
    input [6:0] x, y,
    output reg [15:0] oled_data
    );

    always @ (*) begin
        if(
            // Main column of musical note - just a rectangle
            (centre_x - 1 <= x && x <= centre_x + 1 &&
            centre_y - 8 <= y && y <= centre_y + 8 ) ||
            // Top part of the note - another offset rectangle
            (centre_x + 2 <= x && x <= centre_x + 6 &&
            centre_y - 8 <= y && y <= centre_y - 4 ) ||
            // Bottom part - another rectangle
            (centre_x - 8 <= x && x <= centre_x - 2 &&
            centre_y <= y && y <= centre_y + 8 )
        ) begin
            oled_data <= main_col;
        end else oled_data <= bg_col;
    end
endmodule

module draw_z(
    input [15:0] main_col, bg_col,
    input [6:0] centre_x, centre_y,
    input [6:0] x, y,
    output reg [15:0] oled_data
    );

    always @ (*) begin
        if(
            // Top row
            (centre_x - 5 <= x && x <= centre_x + 5 &&
            centre_y - 5 <= y && y <= centre_y - 4 ) ||
            // Middle slash
            (centre_x + 2 <= x && x <= centre_x + 3 &&
            centre_y - 3 <= y && y <= centre_y - 2 ) ||
            (centre_x - 1 <= x && x <= centre_x + 1 &&
            centre_y - 1 <= y && y <= centre_y + 1 ) ||
            (centre_x - 3 <= x && x <= centre_x - 2 &&
            centre_y + 2 <= y && y <= centre_y + 3 ) ||
            // Bottom Row
            (centre_x - 5 <= x && x <= centre_x + 5 &&
            centre_y + 4 <= y && y <= centre_y + 5 )
        ) begin
            oled_data <= main_col;
        end else oled_data <= bg_col;
    end
endmodule