module double_sign_mult_tb;

// Useful Parameters
parameter WORD_SIZE = 37; 
parameter HALF_SIZE = 18;

// Test input signals
reg [WORD_SIZE-1:0] test_A, test_B = 37'd0;
wire [WORD_SIZE-1:0] test_C;

double_sign_mult TEST_UNIT (
    .A(test_A),
    .B(test_B),
    .C(test_C)
);

    initial begin
        $dumpfile("double_sign_mult_tb.vcd");
        $dumpvars(0, double_sign_mult_tb);

        #1
        test_A[WORD_SIZE-1:HALF_SIZE] = 19'd4;
        test_A[HALF_SIZE-1:0] = 18'h1 << 17;

        test_B[WORD_SIZE-1:HALF_SIZE] = 19'd2;
        test_B[HALF_SIZE-1:0] = 18'h1 << 17;

        #1
        test_B[WORD_SIZE-1:HALF_SIZE] = ((~19'd3) + 1) << 1;
        
        #1
        test_B[WORD_SIZE-1:0] = 0;

        #1 $finish;
    end
endmodule
