`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2023 17:13:27
// Design Name: 
// Module Name: design_source_1
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
// 2nd Rightmost: 2
// 3rd Rightmost: 3

module one_bit_full_adder(
    input A, B, CIN,
    output S, COUT
    );

    assign S = A ^ B ^ CIN;
    assign COUT = A & B | CIN & (A ^ B);
endmodule

module two_bit_full_adder(
    input [1:0] A,
    input [1:0] B,
    input C0,
    output [1:0] S,
    output C2
    );

    wire C1;
    one_bit_full_adder fa0 (A[0], B[0], C0, S[0], C1);
    one_bit_full_adder fa1 (A[1], B[1], C1, S[1], C2);

endmodule

module four_bit_ripple_adder(
    input [3:0] A,
    input [3:0] B,
    input CIN,
    output [3:0] S,
    output COUT
    );
    wire [4:0] C;

    one_bit_full_adder fa0 (A[0], B[0], CIN, S[0], C[1]);
    one_bit_full_adder fa1 (A[1], B[1], C[1], S[1], C[2]);
    one_bit_full_adder fa2 (A[2], B[2], C[2], S[2], C[3]);
    one_bit_full_adder fa3 (A[3], B[3], C[3], S[3], COUT);

endmodule

// Subtask C: 2: DR Multiplied by 8 when BtnD is held
// No arithmetic operators (*) are allowed
// Just shift it left 3 times
// module six_bit_multiplier_8 (
    // input [5:0] DR,
    // output [5:0] AR
    // );
    // // assign AR = {DR[2:0], 3'b000}
    // assign AR[2:0] = 0;
    // assign AR[5:3] = DR[2:0];

// endmodule

// Subtask A: 3: 4 bit MSB & 2 bit LSB, 6 bit I/O
// module six_bit_full_adder(
    // input [5:0] A,
    // input [5:0] B,
    // output [5:0] S
    // );

    // wire carry;
    // wire discard;
    // two_bit_full_adder fa0 (A[1:0], B[1:0], 0, S[1:0], carry);
    // four_bit_ripple_adder fa1 (A[5:2], B[5:2], carry, S[5:2], discard);
    // // Will overflow, carry discarded

// endmodule

module main (
    input [5:0] A,
    input [5:0] B,
    input pb,
    output [5:0] S,
    output [5:0] T,
    output [6:0] seg,
    output [3:0] an
    );

    // Subtask 0: Initialisation
    // 2: anode 0,1,2 n with an elevated head (a,e,c)
    assign an = 4'b1000;
    assign seg = 7'b1101010;

    // Subtask B: 2: LED 10 to 15 turn on from BTN Down
    assign T[5:0] = pb ? 6'b111111 : 6'b000000;

    // Subtask D: A - sw[7:0], B - sw[15:8], S - led[5:0]
    wire [5:0]DR;
    wire [5:0]AR;
    wire carry;
    wire discard;
    two_bit_full_adder fa0 (A[1:0], B[1:0], 0, DR[1:0], carry);
    four_bit_ripple_adder fa1 (A[5:2], B[5:2], carry, DR[5:2], discard);
    assign AR[2:0] = 0;
    assign AR[5:3] = DR[2:0];

    assign S[5:0] = pb ? AR[5:0] : DR[5:0];

endmodule
