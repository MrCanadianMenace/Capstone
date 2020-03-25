/* verilator lint_off UNUSED */
module butterfly_sum 
	#(parameter WORD_SIZE = 74,
	  parameter HALF_SIZE = 37)
    (
        input i_CLK,
        input i_RST,
        input [WORD_SIZE-1:0] i_A,
        input [WORD_SIZE-1:0] i_B,
        input [WORD_SIZE-1:0] i_twiddle,

        output reg  [WORD_SIZE-1:0] o_A,
        output reg  [WORD_SIZE-1:0] o_B
    );

    // Wires for simplifying splitting complex values into real and imaginary parts
    wire [HALF_SIZE-1:0] in_twiddle_real = i_twiddle[WORD_SIZE-1:HALF_SIZE];
    wire [HALF_SIZE-1:0] in_twiddle_imag = i_twiddle[HALF_SIZE-1:0];

    /** Twiddle Factor Complex Multiplication **/ 
    // Negative symmetry to reduce number of twiddle factors
    wire [HALF_SIZE-1:0] n_twiddle_real = (~in_twiddle_real) + 1;
    wire [HALF_SIZE-1:0] n_twiddle_imag = (~in_twiddle_imag) + 1;
    wire [WORD_SIZE-1:0] n_twiddle = {n_twiddle_real, n_twiddle_imag};
    // For rising butterfly sum (B * W2_0)
    wire [WORD_SIZE-1:0] twiddle_rise_prod;
    // For falling butterfly sum (B * W2_1)
    wire [WORD_SIZE-1:0] twiddle_fall_prod;

    complex_mult CPX_MULT0(i_B, i_twiddle, twiddle_rise_prod);
    complex_mult CPX_MULT1(i_B, n_twiddle, twiddle_fall_prod);

    /** TODO: DEBUGGING SIGNALS **/
    wire [HALF_SIZE-1:0] twiddle_rise_prod_real = twiddle_rise_prod[WORD_SIZE-1:HALF_SIZE];
    wire [HALF_SIZE-1:0] twiddle_rise_prod_imag = twiddle_rise_prod[HALF_SIZE-1:0];
    wire [HALF_SIZE-1:0] twiddle_fall_prod_real = twiddle_fall_prod[WORD_SIZE-1:HALF_SIZE];
    wire [HALF_SIZE-1:0] twiddle_fall_prod_imag = twiddle_rise_prod[HALF_SIZE-1:0];

    always @ (posedge i_CLK) begin
        /** Complex Addition for final step **/
        o_A <= i_A + twiddle_rise_prod;
        o_B <= i_A + twiddle_fall_prod;
    end

endmodule
