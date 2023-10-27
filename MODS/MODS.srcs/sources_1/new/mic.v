`include "constants.vh"

//      Main mic module. 
//      Connect the PMOD MIC3 to the JC top pins
module mic (
    input clock,

    output JC_MIC3_Pin1,
    input JC_MIC3_Pin3,
    output JC_MIC3_Pin4,

    // output wire [11:0] mic
    input [12:0] pixel_index,
    output reg [15:0] oled_data
    );

    wire cs;
    new_clock (20000, clock, cs);
    wire [11:0] mic;
    Audio_Capture(.CLK(clock), .cs(cs), .MISO(JC_MIC3_Pin3), .clk_samp(JC_MIC3_Pin1), .sclk(JC_MIC3_Pin4), .sample(mic));
    wire [11:0] peak_vol;
    peak_intensity(.clock(clock), .mic_in(mic), .peak_vol(peak_vol));

    wire [6:0] x, y;
    xy(pixel_index, x, y);

    always @ (posedge clock) begin
        oled_data <= y < peak_vol[10:5] ? `GREEN : `RED;
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
        count <= count == 13'd3999 ? 0 : count + 1;
        //only accept values between 2048 and 4095
        value <= (mic_in >= 2048) ? mic_in : 0;
        peak_vol <= (count == 0) ? value : ((value > peak_vol) ? value : peak_vol);
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