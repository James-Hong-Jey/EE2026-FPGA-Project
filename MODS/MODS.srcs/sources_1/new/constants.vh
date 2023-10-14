/**
  *   Usage:
  *   `include "constants.vh"
  *   assign led[15] = `BLACK;
 */ 

// LCD Display Dimensions
`define WIDTH 96
`define HEIGHT 64

// Colours 
`define BLACK 16'b0
`define WHITE ~`BLACK
`define MAGENTA 16'b11111_000000_11111
`define CYAN 16'b00000_111111_11111
`define YELLOW 16'b11111_111111_00000
`define GREEN 16'b00000_111111_00000
`define RED 16'b11111_000000_00000
`define BLUE 16'b00000_000000_11111
`define ORANGE 16'b11111_100110_00000
`define GREY 16'b01100_011000_01100

// 7 Segment Display Digits
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

// 7 Segment Display Characters
`define V   7'b1000001
`define A   7'b0001000
`define L   7'b1000111