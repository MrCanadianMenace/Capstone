module complex_mult_tb;

// Useful Parameters
parameter HALF_SIZE = 37;
parameter CPX_SIZE = 74; 
parameter FRACT_PT = 18;

// Define modifiable real and imaginary components for input ports
reg [HALF_SIZE-1:0] test_A_real, test_A_imag, test_B_real, test_B_imag;
wire [CPX_SIZE-1:0] test_C;

// Wires to manage complex values
wire [CPX_SIZE-1:0] test_A = {test_A_real, test_A_imag};
wire [CPX_SIZE-1:0] test_B = {test_B_real, test_B_imag};

complex_mult TEST_UNIT (
    .cpx_A(test_A),
    .cpx_B(test_B),
    .cpx_C(test_C)
);

wire [HALF_SIZE-1:0] test_C_real = test_C[CPX_SIZE-1:HALF_SIZE]; 
wire [HALF_SIZE-1:0] test_C_imag = test_C[HALF_SIZE-1:0];

    initial begin
        $dumpfile("complex_mult_tb.vcd");
        $dumpvars(0, complex_mult_tb);

        #1
        test_A_real = (16'd1 << FRACT_PT);
        test_A_imag = (16'd2 << FRACT_PT);
        test_B_real = (16'd3 << FRACT_PT);
        test_B_imag = (16'd4 << FRACT_PT);

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
