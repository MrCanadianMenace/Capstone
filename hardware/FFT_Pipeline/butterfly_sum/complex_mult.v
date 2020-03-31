module complex_mult
	#(parameter CPX_SIZE = 74,
	  parameter HALF_SIZE = 37)
	(
		input wire [CPX_SIZE-1:0] cpx_A, 
		input wire [CPX_SIZE-1:0] cpx_B, 
		output wire [CPX_SIZE-1:0] cpx_C
	);
    
    // Internal wires for aiding in complex math
    wire [HALF_SIZE-1:0] cpx_A_real = cpx_A[CPX_SIZE-1:HALF_SIZE];
    wire [HALF_SIZE-1:0] cpx_B_real = cpx_B[CPX_SIZE-1:HALF_SIZE];
    wire [HALF_SIZE-1:0] cpx_A_imag = cpx_A[HALF_SIZE-1:0];
    wire [HALF_SIZE-1:0] cpx_B_imag = cpx_B[HALF_SIZE-1:0];

    // Intermediate Products 
    wire [HALF_SIZE-1:0] prod_A_B, prod_Ai_Bi, prod_A_Bi, prod_Ai_B;
    double_sign_mult MULT0 (cpx_A_real, cpx_B_real, prod_A_B);
    double_sign_mult MULT1 (cpx_A_imag, cpx_B_imag, prod_Ai_Bi);
    double_sign_mult MULT2 (cpx_A_real, cpx_B_imag, prod_A_Bi);
    double_sign_mult MULT3 (cpx_A_imag, cpx_B_real, prod_Ai_B);

    // Final Products after recombining real and imaginary parts
    wire [HALF_SIZE-1:0] final_prod_real = prod_A_B - prod_Ai_Bi;
    wire [HALF_SIZE-1:0] final_prod_imag = prod_A_Bi + prod_Ai_B;

    assign cpx_C = {final_prod_real, final_prod_imag};

endmodule
