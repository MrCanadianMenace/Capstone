module butterfly_sum 
    (
        i_A,
        i_B,
        i_twiddleA,
        i_twiddleB,
        o_C
    );

    // Port declarations
    input wire  [31:0] i_A, i_B, i_twiddleA, i_twiddleB;
    output wire [31:0] o_C;

    // Useful Parameters
    parameter WORD_MIDPOINT = 16;

    // Internal wires for aiding in complex math
    wire [WORD_MIDPOINT-1:0] in_real1 = in1[WORD_MIDPOINT-1:midpoint];
    wire [WORD_MIDPOINT-1:0] in_real2 = in2[WORD_MIDPOINT-1:midpoint];
    wire [WORD_MIDPOINT-1:0] in_imag1 = in1[WORD_MIDPOINT-1:0];
    wire [WORD_MIDPOINT-1:0] in_imag2 = in2[WORD_MIDPOINT-1:0];
    wire [WORD_MIDPOINT-1:0] twiddleA_imag = in1[WORD_MIDPOINT-1:0];
    wire [WORD_MIDPOINT-1:0] twiddleA_real = in2[WORD_MIDPOINT-1:0];

    wire [WORD_MIDPOINT-1:0] out_real, out_imag;

    always @ (posedge i_CLK) begin
        out1[WORD_SZ-1:midpoint] <= in_real1 + in_real2;    // Real part of output
        out1[midpoint-1:0] <= in_imag1 + in_imag2;          // Imaginary part of first output

        out2[WORD_SZ-1:midpoint] <= in_real1 - in_real2;    // Real part of output
        out2[midpoint-1:0] <= in_imag1 - in_imag2;          // Imaginary part of first output
    end
