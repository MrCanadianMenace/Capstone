module fft_layer_tb;

// Test parameters
parameter TEST_WORD_SIZE = 74;
parameter TEST_FFT_SIZE  = 8;
parameter TEST_LAYER_NUM = 2;
parameter TEST_MEM_SIZE  = TEST_FFT_SIZE * 2;
parameter TEST_ADDR_SIZE = $clog2(TEST_MEM_SIZE);
parameter TEST_TWID_ADDR_SIZE = $clog2(127);

// Driving test signals
reg test_CLK = 0, test_RST = 0;

/** FFT Layer Wires **/
wire [TEST_ADDR_SIZE-1:0] w_2rdaddr_A, w_2rdaddr_B;
wire [TEST_TWID_ADDR_SIZE-1:0] w_twaddr;
wire w_tst_readen, w_tst_writeen, w_tst_done;

fft_layer
#(  .FFT_SIZE(TEST_FFT_SIZE),
	.MEM_OFFSET(TEST_FFT_SIZE),
    .LAYER_NUM(TEST_LAYER_NUM),
    .ADDR_SIZE(TEST_ADDR_SIZE) )
TEST_FFT_LAYER
(
    .i_CLK(test_CLK), 
    .i_RST(test_RST),
    .i_CS(1'b1),

    .o_done(w_tst_done),
    .o_rden(w_tst_readen),
    .o_wren(w_tst_writeen),
    .o_rdaddr_A(w_2rdaddr_A),
    .o_rdaddr_B(w_2rdaddr_B),
    .o_rdaddr_tw(w_twaddr)
);

// Clock pulse generation
always #2 test_CLK <= ~test_CLK;

initial begin
    $dumpfile("FFT_test_tb.vcd");
    $dumpvars(0, fft_layer_tb);

    #1 test_RST <= 1'b1;

    #1 test_RST <= 1'b0;

    #50 $finish;
end

endmodule
