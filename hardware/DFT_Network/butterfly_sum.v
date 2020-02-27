module butterfly_sum 
    (
        i_A,
        i_B,
        i_twiddleA,
        i_twiddleB,
        o_C,
        o_D
    );

    // Port declarations
    input wire  [31:0] i_A, i_B, i_twiddleA, i_twiddleB;
    output wire [31:0] o_C, o_D;

    // Useful Parameters
    parameter WORD_MID = 16;
    parameter WORD_SZ = 32; 

    // Internal wires for aiding in complex math
    wire [WORD_MID-1:0] in_A_real = i_A[WORD_SZ-1:WORD_MID];
    wire [WORD_MID-1:0] in_B_real = i_B[WORD_SZ-1:WORD_MID];
    wire [WORD_MID-1:0] in_A_imag = i_A[WORD_MID-1:0];
    wire [WORD_MID-1:0] in_B_imag = i_B[WORD_MID-1:0];
    wire [WORD_MID-1:0] twiddleA_real = i_twiddleA[WORD_SZ-1:WORD_MID];
    wire [WORD_MID-1:0] twiddleA_imag = i_twiddleA[WORD_MID-1:0];
    wire [WORD_MID-1:0] twiddleB_real = i_twiddleB[WORD_SZ-1:WORD_MID];
    wire [WORD_MID-1:0] twiddleB_imag = i_twiddleB[WORD_MID-1:0];

    wire [WORD_MID-1:0] out_C_real, out_C_imag, out_D_real, out_D_imag;

    /** Complex Multiplication **/ 
    // For rising butterfly sum (A + B * W1_0)
    wire twiddleA_real_complement = (~twiddleA_real) + 16'd1;
    wire [WORD_MID-1:0] complex_mult_A_real = twiddleA_real * (in_B_real + in_B_imag) + twiddleA_imag * (in_B_real - in_B_imag);
    wire [WORD_MID-1:0] complex_mult_A_imag = twiddleA_real_complement * (in_B_real - in_B_imag) + twiddleA_imag * (in_B_real + in_B_imag);

    // For falling butterfly sum (A + B * W1_1)
    wire twiddleB_real_complement = (~twiddleA_real) + 16'd1;
    wire [WORD_MID-1:0] complex_mult_B_real = twiddleB_real * (in_B_real - in_B_imag) + twiddleB_imag * (in_B_real + in_B_imag);
    wire [WORD_MID-1:0] complex_mult_B_imag = twiddleB_real_complement * (in_B_real - in_B_imag) + twiddleB_imag * (in_B_real + in_B_imag);

    /** Complex Addition for final step **/
    assign out_C_real = in_A_real + complex_mult_A_real;
    assign out_C_imag = in_A_imag + complex_mult_A_imag;

    assign out_D_real = in_A_real + complex_mult_B_real;
    assign out_D_imag = in_A_imag + complex_mult_B_imag;

    /** Finally Direct Back to the Output Ports **/
    assign out_C = {out_C_real, out_C_imag};
    assign out_D = {out_D_real, out_D_imag};

endmodule
