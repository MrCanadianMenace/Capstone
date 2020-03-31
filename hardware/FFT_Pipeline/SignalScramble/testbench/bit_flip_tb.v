module bit_flip_tb;

// Test parameters
parameter TEST_WORD_SIZE = 8;
parameter TEST_ADDR_SIZE = 3;
// Iterator in for loop
integer i;

// Driving test signals
reg test_CLK = 0;
reg [TEST_ADDR_SIZE-1:0] test_in_pipeaddr_A, test_in_pipeaddr_B;
reg [TEST_WORD_SIZE-1:0] test_in_pipedata_A, test_in_pipedata_B;

wire [TEST_ADDR_SIZE-1:0] test_out_pipeaddr_A, test_out_pipeaddr_B;
wire [TEST_WORD_SIZE-1:0] test_out_pipedata_A, test_out_pipedata_B;

bit_flip 
#( .WORD_SIZE(TEST_WORD_SIZE),
   .ADDR_SIZE(TEST_ADDR_SIZE) ) 
TEST_UNIT (
    .i_CLK(test_CLK),
    .i_pipeaddr_A(test_in_pipeaddr_A),
    .i_pipeaddr_B(test_in_pipeaddr_B),
    .i_pipedata_A(test_in_pipedata_A),
    .i_pipedata_B(test_in_pipedata_A),

    .o_pipeaddr_A(test_out_pipeaddr_A),
    .o_pipeaddr_B(test_out_pipeaddr_B),
    .o_pipedata_A(test_out_pipedata_A),
    .o_pipedata_B(test_out_pipedata_A)
);

always #1 test_CLK <= ~test_CLK;

initial begin
    $dumpfile("bit_flip_test.vcd");
    $dumpvars(0, bit_flip_tb);

    #1
    // Set memory addresses
    test_in_pipeaddr_A <= 0;
    test_in_pipeaddr_B <= 1;

    // Set fake read data
    test_in_pipedata_A <= 2;
    test_in_pipedata_B <= 5;

    for (i = 0; i < 3; i++) begin

        #2
        // Set memory addresses
        test_in_pipeaddr_A <= test_in_pipeaddr_A + 2;
        test_in_pipeaddr_B <= test_in_pipeaddr_B + 2;

        // Set fake read data
        test_in_pipedata_A <= test_in_pipedata_A + 2;
        test_in_pipedata_B <= test_in_pipedata_B + 3;
    end

    #1 $finish;
end
endmodule
