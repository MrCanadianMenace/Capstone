module complex_mult(cpx_A, cpx_B, cpx_C);
    // Port Declarations
    input wire [31:0] cpx_A, cpx_B;
    output wire [31:0] cpx_C;
    
    // Useful Parameters
    parameter WORD_MID = 16;
    parameter WORD_SZ = 32; 

    // Internal wires for aiding in complex math
    wire [WORD_MID-1:0] cpx_A_real = cpx_A[WORD_SZ-1:WORD_MID];
    wire [WORD_MID-1:0] cpx_B_real = cpx_B[WORD_SZ-1:WORD_MID];
    wire [WORD_MID-1:0] cpx_A_imag = cpx_A[WORD_MID-1:0];
    wire [WORD_MID-1:0] cpx_B_imag = cpx_B[WORD_MID-1:0];

    // Intermediate Products 
    wire [WORD_MID-1:0] prod_A_B, prod_Ai_Bi, prod_A_Bi, prod_Ai_B;
    sign_mult MULT0 (cpx_A_real, cpx_B_real, prod_A_B);
    sign_mult MULT1 (cpx_A_imag, cpx_B_imag, prod_Ai_Bi);
    sign_mult MULT2 (cpx_A_real, cpx_B_imag, prod_A_Bi);
    sign_mult MULT3 (cpx_A_imag, cpx_B_real, prod_Ai_B);

    // Final Products after recombining real and imaginary parts
    wire [WORD_MID-1:0] final_prod_real = prod_A_B - prod_Ai_Bi;
    wire [WORD_MID-1:0] final_prod_imag = prod_A_Bi + prod_Ai_B;

    assign cpx_C = {final_prod_real, final_prod_imag};

endmodule
