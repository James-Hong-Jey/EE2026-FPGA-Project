`timescale 1ns / 1ps

`define DIG0    7'b1000000
`define DIG1    7'b1111001
`define DIG2    7'b0100100
`define DIG3    7'b0110000
`define DIG4    7'b0011001
`define DIG5    7'b0010010
`define DIG6    7'b0000010
`define DIG7    7'b1111000
`define DIG8    7'b0
`define DIG9    7'b0010000  

`define ALPHAE    7'b0000110

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


module verilog_eval(
    input clock,
    input btnC,
    input [15:0] sw,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp
    );

    // Initialisation
    reg [9:0] led_start = 10'b0001101100;
    assign led[10:0] = led_start | sw[10:0];
    reg[15:11] led_blink = 5'b00000;
    //assign led[15:11] = sw[15:11] & two_hertz;
    assign led[15:11] = led_blink;
    reg [3:0] an_reg = 4'b1111;
    reg [6:0] seg_reg = 7'b1111111;
    reg dp_reg = 1;
    assign an = an_reg;
    assign seg = seg_reg;
    assign dp = dp_reg;

    wire two_hertz;
    new_clock(2,clock,two_hertz);

    wire one_sec;
    new_clock (1,clock,one_sec);
    reg counter = 0;
    reg reverse = 0;
    reg active = 0;
    reg [2:0] sequence = 0;
    always @ (posedge one_sec) begin
        btnHold <= btnC ? btnHold + 1 : 0;
        reverse <= btnHold > 7 ? 1 : 0;
        counter <= (active == 0 || counter == 1) ? 0 : counter + 1;
        if(reverse == 0)begin
            if(counter == 0 || active == 0) begin
                sequence <= (active == 0 || sequence == 3) ? 0 : sequence + 1;
            end
        end else if (reverse == 1) begin
            if(counter == 0 || active == 0) begin
                sequence <= (active == 0 || sequence == 0) ? 3 : sequence - 1;
            end
        end
    end

    reg [32:0] btnHold = 0;
    reg [32:0] COUNT = 0;
    always @ (posedge clock) begin

        // COUNT <= (btnC && COUNT < 100000000 / 1 / 2 - 1) ? COUNT + 1 : 0;
        // btnHold <= (btnC && COUNT == 0) ? btnHold + 1 : 0;

//        if(btnHold > 8) reverse <= 1;

        if(btnC) begin
            led_blink <= two_hertz ? sw[15:11] : 5'b00000;
        end else begin
            led_blink <= sw[15:11];
        end

        if (led == 16'b1111111111111111 || sw == 16'b1111111111111111) begin
            active <= (active == 0) ? 1 : 0;
            case(sequence) 
                0: begin
                an_reg <= 4'b1110;
                seg_reg <= `ALPHAE;
                dp_reg <= 0;
                end
                1: begin
                an_reg <= 4'b1101;
                seg_reg <= `DIG6;
                dp_reg <= 1;
                end
                2: begin
                an_reg <= 4'b1011;
                seg_reg <= `DIG2;
                dp_reg <= 1;
                end
                3: begin
                an_reg <= 4'b0111;
                seg_reg <= `DIG3;
                dp_reg <= 1;
                end
            endcase
        end else begin
            an_reg <= 4'b1111;
            seg_reg <= 7'b1111111;
            dp_reg <= 1;
            active <= 0;
        end
    end

endmodule
