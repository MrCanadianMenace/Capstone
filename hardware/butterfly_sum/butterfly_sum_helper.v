/* verilator lint_off UNUSED */
module butterfly_sum_helper
    #(parameter WORD_SIZE = 74,
      parameter HALF_SIZE = 37,
      parameter APPARENT_SIZE = 64)
    (
        input wire i_CLK,
        input wire i_RST,
        input wire [APPARENT_SIZE-1:0] i_A_real,
        input wire [APPARENT_SIZE-1:0] i_A_imag,
        input wire [APPARENT_SIZE-1:0] i_B_real,
        input wire [APPARENT_SIZE-1:0] i_B_imag,
        input wire [APPARENT_SIZE-1:0] i_twiddle_real,
        input wire [APPARENT_SIZE-1:0] i_twiddle_imag,
        output wire [APPARENT_SIZE-1:0] o_A_real,
        output wire [APPARENT_SIZE-1:0] o_A_imag,
        output wire [APPARENT_SIZE-1:0] o_B_real,
        output wire [APPARENT_SIZE-1:0] o_B_imag
    );

    // Wires to direct bits to the actual butterfly_sum
    wire [WORD_SIZE-1:0] w_i_A = {i_A_real[HALF_SIZE-1:0], i_A_imag[HALF_SIZE-1:0]};
    wire [WORD_SIZE-1:0] w_i_B = {i_B_real[HALF_SIZE-1:0], i_B_imag[HALF_SIZE-1:0]};
    wire [WORD_SIZE-1:0] w_i_twiddle = {i_twiddle_real[HALF_SIZE-1:0], i_twiddle_imag[HALF_SIZE-1:0]};
    wire [WORD_SIZE-1:0] w_o_A; 
    wire [WORD_SIZE-1:0] w_o_B;

    wire o_A_real_sign, o_A_imag_sign, o_B_real_sign, o_B_imag_sign;

    butterfly_sum TEST_MOD (
        .i_CLK(i_CLK),
        .i_RST(i_RST),
        .i_A(w_i_A),
        .i_B(w_i_B),
        .i_twiddle(w_i_twiddle),
        .o_A(w_o_A),
        .o_B(w_o_B)
    );

    // Recombine outputs
    assign {o_A_real[HALF_SIZE-1:0], o_A_imag[HALF_SIZE-1:0]} = w_o_A;
    assign {o_B_real[HALF_SIZE-1:0], o_B_imag[HALF_SIZE-1:0]} = w_o_B;
    assign {o_A_real_sign, o_A_imag_sign} = {w_o_A[WORD_SIZE-1], w_o_A[HALF_SIZE-1]}; 
    assign {o_B_real_sign, o_B_imag_sign} = {w_o_B[WORD_SIZE-1], w_o_B[HALF_SIZE-1]}; 

    // Fill in unused output bits with 0's or 1's based on sign
    assign o_A_real[APPARENT_SIZE-1:HALF_SIZE] = {APPARENT_SIZE-HALF_SIZE{o_A_real_sign}};
    assign o_A_imag[APPARENT_SIZE-1:HALF_SIZE] = {APPARENT_SIZE-HALF_SIZE{o_A_imag_sign}}; 
    assign o_B_real[APPARENT_SIZE-1:HALF_SIZE] = {APPARENT_SIZE-HALF_SIZE{o_B_real_sign}}; 
    assign o_B_imag[APPARENT_SIZE-1:HALF_SIZE] = {APPARENT_SIZE-HALF_SIZE{o_B_imag_sign}}; 
endmodule
