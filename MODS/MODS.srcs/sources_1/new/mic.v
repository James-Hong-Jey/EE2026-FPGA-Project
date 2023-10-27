`include "constants.vh"

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

    wire [6:0] x, y;
    xy(pixel_index, x, y);

    always @ (posedge clock) begin
        oled_data <= y < mic[10:5] ? `GREEN : `RED;
    end

endmodule