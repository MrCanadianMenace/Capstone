/**
* Double Fixed-Precision Signed Multiplier
*   Due to the cyclone IV specifications featuring
*   a series of 18x18 bit multipliers this module
*   was designed to 37x37 signed multiplication by
*   breaking the multiplication into a series of 
*   18-bit multiplications
*/

/* verilator lint_off UNUSED */
module double_sign_mult
    #(parameter WORD_SIZE = 37,
      parameter HALF_SIZE = 18)
    (
        input wire [WORD_SIZE-1:0] A, 
        input wire [WORD_SIZE-1:0] B, 
        output wire [WORD_SIZE-1:0] C
    );

    // Calculate sign bit of product as XOR of inputs' sign bits
    wire A_sign = A[WORD_SIZE-1];
    wire B_sign = B[WORD_SIZE-1];
    wire C_sign = A_sign ^ B_sign;

    // Read in operands from ports as unsigned, we can add the sign bit back later
    wire [WORD_SIZE-2:0] operand_A = (A_sign==1'b0) ? A[WORD_SIZE-2:0] : ~A[WORD_SIZE-2:0] + 1;
    wire [WORD_SIZE-2:0] operand_B = (B_sign==1'b0) ? B[WORD_SIZE-2:0] : ~B[WORD_SIZE-2:0] + 1;

    // Break operands down into high and low parts representing the integer
    // and fractional bits
    wire [HALF_SIZE-1:0] op_A_hi = operand_A[WORD_SIZE-2:HALF_SIZE];
    wire [HALF_SIZE-1:0] op_A_lo = operand_A[HALF_SIZE-1:0];
    wire [HALF_SIZE-1:0] op_B_hi = operand_B[WORD_SIZE-2:HALF_SIZE];
    wire [HALF_SIZE-1:0] op_B_lo = operand_B[HALF_SIZE-1:0];

    // Calculate the four intermediate products
    // TODO: May need to replace this part with Altera Multiplier IP
    wire [WORD_SIZE-2:0] prod_A_hi_B_hi = op_A_hi * op_B_hi;
    wire [WORD_SIZE-2:0] prod_A_hi_B_lo = op_A_hi * op_B_lo;
    wire [WORD_SIZE-2:0] prod_A_lo_B_hi = op_A_lo * op_B_hi;
    wire [WORD_SIZE-2:0] prod_A_lo_B_lo = op_A_lo * op_B_lo;

    // Recombine the four sums to get the final unsigned sum
    wire [WORD_SIZE-2:0] unsigned_prod;
    assign unsigned_prod[WORD_SIZE-2:HALF_SIZE] = prod_A_hi_B_hi[HALF_SIZE-1:0] 
                                                    + prod_A_hi_B_lo[WORD_SIZE-2:HALF_SIZE]
                                                    + prod_A_lo_B_hi[WORD_SIZE-2:HALF_SIZE];
    assign unsigned_prod[HALF_SIZE-1:0] = prod_A_lo_B_lo[WORD_SIZE-2:HALF_SIZE] 
                                            + prod_A_hi_B_lo[HALF_SIZE-1:0]
                                            + prod_A_lo_B_hi[HALF_SIZE-1:0];

    // Assign the product back to the output port with its associated sign
    assign C[WORD_SIZE-1] = (unsigned_prod==0) ? 1'b0 : C_sign;
    assign C[WORD_SIZE-2:0] = (C_sign==1'b0) ? unsigned_prod : ~unsigned_prod + 1;

endmodule
