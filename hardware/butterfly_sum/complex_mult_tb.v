module complex_mult_tb;

// Useful Parameters
parameter WORD_MID = 16;
parameter WORD_SZ = 32; 

// Define modifiable real and imaginary components for input ports
reg [WORD_MID-1:0] test_A_real, test_A_imag, test_B_real, test_B_imag;
wire [WORD_SZ-1:0] test_C;

// Wires to manage complex values
wire [WORD_SZ-1:0] test_A = {test_A_real, test_A_imag};
wire [WORD_SZ-1:0] test_B = {test_B_real, test_B_imag};

complex_mult TEST_UNIT (
    .cpx_A(test_A),
    .cpx_B(test_B),
    .cpx_C(test_C)
);

wire [WORD_MID-1:0] test_C_real = test_C[WORD_SZ-1:WORD_MID]; 
wire [WORD_MID-1:0] test_C_imag = test_C[WORD_MID-1:0];

    initial begin
        $dumpfile("complex_mult_tb.vcd");
        $dumpvars(0, complex_mult_tb);

        #1
        test_A_real = (16'd1 << 6);
        test_A_imag = (16'd2 << 6);
        test_B_real = (16'd3 << 6);
        test_B_imag = (16'd4 << 6);

        #1  // Increment CLK by 1
        test_A_real = 16'h0050;
        test_A_imag = 16'h00A0;
        test_B_real = 16'h00E0;
        test_B_imag = 16'h0110;

        #1  // Increment CLK by 1
        test_A_real = 16'hFE70;
        test_A_imag = 16'h00A0;
        test_B_real = 16'h0110;
        test_B_imag = 16'hFF60;

        
        #1  // Increment CLK by 1
        test_A_real = 16'hFFB0;
        test_A_imag = 16'h00A0;
        test_B_real = 16'h00DF;
        test_B_imag = 16'hFEF0;

        #1 $finish;
    end
endmodule
