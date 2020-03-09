/* verilator lint_off UNUSED */
module butterfly_sum 
    (
        i_CLK,
        i_RST,
        i_A,
        i_B,
        i_twiddle,
        o_A,
        o_B
    );

    // Port declarations
    input wire i_CLK, i_RST;
    input wire  [31:0] i_A, i_B, i_twiddle;
    output wire [31:0] o_A, o_B;

    // Useful Parameters
    parameter WORD_MID = 16;
    parameter WORD_SZ = 32; 

    // Wires for simplifying splitting complex values into real and imaginary parts
    wire [WORD_MID-1:0] in_twiddle_real = i_twiddle[WORD_SZ-1:WORD_MID];
    wire [WORD_MID-1:0] in_twiddle_imag = i_twiddle[WORD_MID-1:0];


    /** Twiddle Factor Complex Multiplication **/ 
    // Negative symmetry to reduce number of twiddle factors
    wire [WORD_MID-1:0] n_twiddle_real = (~in_twiddle_real) + 1;
    wire [WORD_MID-1:0] n_twiddle_imag = (~in_twiddle_imag) + 1;
    wire [WORD_SZ-1:0] n_twiddle = {n_twiddle_real, n_twiddle_imag};
    // For rising butterfly sum (B * W2_0)
    wire [WORD_SZ-1:0] twiddle_rise_prod;
    // For falling butterfly sum (B * W2_1)
    wire [WORD_SZ-1:0] twiddle_fall_prod;

    complex_mult CPX_MULT0(i_B, i_twiddle, twiddle_rise_prod);
    complex_mult CPX_MULT1(i_B, n_twiddle, twiddle_fall_prod);

    /** Complex Addition for final step **/
    assign o_A = i_A + twiddle_rise_prod;
    assign o_B = i_A + twiddle_fall_prod;

endmodule
