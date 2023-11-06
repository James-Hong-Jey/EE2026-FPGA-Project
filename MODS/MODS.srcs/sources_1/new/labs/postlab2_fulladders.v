`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2023 09:32:54
// Design Name: 
// Module Name: one_bit_full_adder
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

// A0255326E
// 2nd Rightmost - 2
// 3rd Rightmost - 3

module main (
    input [15:0] sw,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp
    )
    // Initialisation
    // 2nd Rightmost - 2
    // Anode 1,2,3 (not 0)
    // Segments 0, 2, 4
    assign an[3:1] = 0;
    assign seg[0] = 0;
    assign seg[2] = 0;
    assign seg[4] = 0;

    // Subtask A
    // 3rd Rightmost - 3
    // 4 bit parallel adder MSB, 2 bit parallel adder LSB
    // 6 bit inputs & output

endmodule

module six_bit_full_adder(
    input A, B,
    output S
    );


endmodule

module one_bit_full_adder(
    input A, B, CIN,
    output S, COUT
    );

    assign S = A ^ B ^ CIN;
    assign COUT = A & B | CIN & (A ^ B);

endmodule

module four_bit_ripple_adder(
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    input CIN,
    output COUT
    );
    wire [4:0] C;

    one_bit_full_adder fa0 (A[0], B[0], CIN, S[0], C[1]);
    one_bit_full_adder fa1 (A[1], B[1], C[1], S[1], C[2]);
    one_bit_full_adder fa2 (A[2], B[2], C[2], S[2], C[3]);
    one_bit_full_adder fa3 (A[3], B[3], C[3], S[3], COUT);

endmodule

module multiplexer(
    input A, B, S,
    output Z
)


endmodule