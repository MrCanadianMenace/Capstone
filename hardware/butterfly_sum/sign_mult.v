/* verilator lint_off UNUSED */
module sign_mult(A, B, C);
    // Port Declarations
    input wire [15:0] A, B;
    output wire [15:0] C;

    // Useful Parameters
    parameter WORD_MID = 16;
    parameter WORD_SZ = 32; 

    wire A_sign = A[WORD_MID-1];
    wire B_sign = B[WORD_MID-1];
    wire C_sign = A_sign ^ B_sign;

    wire [WORD_MID-2:0] operand_A = (A_sign==1'b0) ? A[WORD_MID-2:0] : ~A[WORD_MID-2:0] + 1;
    wire [WORD_MID-2:0] operand_B = (B_sign==1'b0) ? B[WORD_MID-2:0] : ~B[WORD_MID-2:0] + 1;

    wire [WORD_SZ-2:0] unsigned_mult = operand_A * operand_B;
    assign C[WORD_MID-1] = C_sign;
    assign C[WORD_MID-2:0] = (C_sign==1'b0) ? unsigned_mult[20:6] : ~unsigned_mult[20:6] + 1;

endmodule

