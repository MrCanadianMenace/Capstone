/* verilator lint_off UNUSED */
module butterfly_sum 
    (
        i_CLK,
        i_RST,
        i_A,
        i_B,
        i_twiddleA,
        o_A,
        o_B
    );

    // Port declarations
    input wire i_CLK, i_RST;
    input wire  [31:0] i_A, i_B, i_twiddleA;
    output wire [31:0] o_A, o_B;

    // Useful Parameters
    parameter WORD_MID = 16;
    parameter WORD_SZ = 32; 

    // Internal wires for aiding in complex math
    wire [WORD_MID-1:0] in_A_real = i_A[WORD_SZ-1:WORD_MID];
    wire [WORD_MID-1:0] in_B_real = i_B[WORD_SZ-1:WORD_MID];
    wire [WORD_MID-1:0] in_A_imag = i_A[WORD_MID-1:0];
    wire [WORD_MID-1:0] in_B_imag = i_B[WORD_MID-1:0];

    wire [WORD_MID-1:0] twiddleA_real = i_twiddleA[WORD_SZ-1:WORD_MID];
    wire [WORD_MID-1:0] twiddleB_real = (~i_twiddleA[WORD_SZ-1:WORD_MID]) + 1;
    wire [WORD_MID-1:0] twiddleA_imag = i_twiddleA[WORD_MID-1:0];
    wire [WORD_MID-1:0] twiddleB_imag = (~i_twiddleA[WORD_MID-1:0]) + 1;

    wire [WORD_MID-1:0] out_A_real, out_A_imag, out_B_real, out_B_imag;


    /** Twiddle Factor Complex Multiplication **/ 
    // For rising butterfly sum (B * W2_0)
    wire [WORD_SZ-1:0] prod_B_real_rise = (in_B_real * twiddleA_real) - (in_B_imag * twiddleA_imag);
    wire [WORD_SZ-1:0] prod_B_imag_rise = (in_B_real * twiddleA_imag) + (in_B_imag * twiddleA_real);

    // For falling butterfly sum (B * W2_1)
    wire [WORD_SZ-1:0] prod_B_real_fall = (in_B_real * twiddleB_real) - (in_B_imag * twiddleB_imag);
    wire [WORD_SZ-1:0] prod_B_imag_fall = (in_B_real * twiddleB_imag) + (in_B_imag * twiddleB_real);


    /** Complex Addition for final step **/
    assign out_A_real = in_A_real + prod_B_real_rise[21:6];
    assign out_A_imag = in_A_imag + prod_B_imag_rise[21:6];

    assign out_B_real = in_A_real + prod_B_real_fall[21:6];
    assign out_B_imag = in_A_imag + prod_B_imag_fall[21:6];


    /** Finally Direct Back to the Output Ports **/
    assign o_A = {out_A_real, out_A_imag};
    assign o_B = {out_B_real, out_B_imag};

endmodule
