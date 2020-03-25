module butterfly_sum_tb;

// Useful Parameters
parameter HALF_SIZE = 37;
parameter WORD_SIZE = 74; 
parameter FRACT_PT = 18;

// Define modifiable real and imaginary components for input ports
reg [HALF_SIZE-1:0] in_A_real;
reg [HALF_SIZE-1:0] in_A_imag;

reg [HALF_SIZE-1:0] in_B_real;
reg [HALF_SIZE-1:0] in_B_imag;

reg [HALF_SIZE-1:0] twiddle_real;
reg [HALF_SIZE-1:0] twiddle_imag;


// Port signals
wire [WORD_SIZE-1:0] in_A = {in_A_real, in_A_imag}; 
wire [WORD_SIZE-1:0] in_B = {in_B_real, in_B_imag}; 
wire [WORD_SIZE-1:0] twiddle = {twiddle_real, twiddle_imag};
wire [WORD_SIZE-1:0] out_A, out_B;

// Output real/imaginary complex split
wire [HALF_SIZE-1:0] out_A_real = out_A[WORD_SIZE-1:HALF_SIZE];
wire [HALF_SIZE-1:0] out_A_imag = out_A[HALF_SIZE-1:0];

wire [HALF_SIZE-1:0] out_B_real = out_B[WORD_SIZE-1:HALF_SIZE];
wire [HALF_SIZE-1:0] out_B_imag = out_B[HALF_SIZE-1:0];

butterfly_sum TEST_UNIT (
    .i_A(in_A),
    .i_B(in_B),
    .i_twiddle(twiddle),
    .o_A(out_A),
    .o_B(out_B)
);

    initial begin
        $dumpfile("butterfly_sum_tb.vcd");
        $dumpvars(0, butterfly_sum_tb);

        #1  // Increment CLK by 1
        in_A_real = (37'd1 << FRACT_PT);
        in_A_imag = (37'd2 << FRACT_PT);
        in_B_real = (37'd3 << FRACT_PT);
        in_B_imag = (37'd4 << FRACT_PT);

        twiddle_real = (37'd1 << FRACT_PT);
        twiddle_imag = (37'd0 << FRACT_PT);

        // TODO: Convert desired values to binary form
        #1  // Increment CLK by 1
        in_A_real = 37'h0050;
        in_A_imag = 37'h00A0;
        in_B_real = 37'h00E0;
        in_B_imag = 37'h0110;

        // TODO: Convert desired values to binary form
        #1  // Increment CLK by 1
        in_A_real = 37'hFFB0;
        in_A_imag = 37'h00A0;
        in_B_real = 37'h00DF;
        in_B_imag = 37'hFEF0;

        
        #1  // Increment CLK by 1
        in_A_real = 37'hFFB0;
        in_A_imag = 37'h00A0;
        in_B_real = 37'h00DF;
        in_B_imag = 37'hFEF0;

        #1 $finish;
    end
endmodule
