module butterfly_sum_tb;

// Useful Parameters
parameter WORD_MID = 16;
parameter WORD_SZ = 32; 

// Define modifiable real and imaginary components for input ports
reg [WORD_MID-1:0] in_A_real;
reg [WORD_MID-1:0] in_A_imag;

reg [WORD_MID-1:0] in_B_real;
reg [WORD_MID-1:0] in_B_imag;

reg [WORD_MID-1:0] twiddleA_real;
reg [WORD_MID-1:0] twiddleA_imag;


// Port signals
wire [WORD_SZ-1:0] in_A = {in_A_real, in_A_imag}; 
wire [WORD_SZ-1:0] in_B = {in_B_real, in_B_imag}; 
wire [WORD_SZ-1:0] twiddleA = {twiddleA_real, twiddleA_imag};
wire [WORD_SZ-1:0] out_A, out_B;

// Output real/imaginary complex split
wire [WORD_MID-1:0] out_A_real = out_A[WORD_SZ-1:WORD_MID];
wire [WORD_MID-1:0] out_A_imag = out_A[WORD_MID-1:0];

wire [WORD_MID-1:0] out_B_real = out_B[WORD_SZ-1:WORD_MID];
wire [WORD_MID-1:0] out_B_imag = out_B[WORD_MID-1:0];

butterfly_sum TEST_UNIT (
    .i_A(in_A),
    .i_B(in_B),
    .i_twiddleA(twiddleA),
    .o_A(out_A),
    .o_B(out_B)
);

    initial begin
        $dumpfile("butterfly_sum_tb.vcd");
        $dumpvars(0, butterfly_sum_tb);

        #1  // Increment CLK by 1
        in_A_real = (16'd1 << 6);
        in_A_imag = (16'd2 << 6);
        in_B_real = (16'd3 << 6);
        in_B_imag = (16'd4 << 6);

        twiddleA_real = (16'd1 << 6);
        twiddleA_imag = (16'd0 << 6);

        #1 $finish;
    end
endmodule
