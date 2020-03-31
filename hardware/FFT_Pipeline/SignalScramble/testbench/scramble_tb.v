module scramble_tb;

// Test parameters
parameter TEST_WORD_SIZE = 8;
parameter TEST_FFT_SIZE = 8;
parameter TEST_MEM_SIZE = TEST_FFT_SIZE * 2;
parameter TEST_ADDR_SIZE = $clog2(TEST_MEM_SIZE);
// Iterator in for loop
integer i;
integer memory_dump;

// Driving test signals
reg test_CLK = 0, test_RST = 0;
wire [TEST_ADDR_SIZE-1:0] test_in_pipeaddr_A, test_in_pipeaddr_B;
wire [TEST_WORD_SIZE-1:0] test_in_pipedata_A, test_in_pipedata_B;

wire [TEST_ADDR_SIZE-1:0] test_out_pipeaddr_A, test_out_pipeaddr_B;
wire [TEST_WORD_SIZE-1:0] test_out_pipedata_A, test_out_pipedata_B;

wire tst_readen, tst_writeen, tst_done;
wire MEM_CLK = ~test_CLK;

scramble
#( .WORD_SIZE(TEST_WORD_SIZE),
   .ADDR_SIZE(TEST_ADDR_SIZE),
   .FFT_SIZE(TEST_FFT_SIZE) )
TEST_MOD
(
    .i_CLK(test_CLK),
    .i_RST(test_RST),
    .i_rddata_A(test_in_pipedata_A),
    .i_rddata_B(test_in_pipedata_B),

    .o_rden(tst_readen),
    .o_wren(tst_writeen),
    .o_done(tst_done),
    .o_rdaddr_A(test_in_pipeaddr_A),
    .o_rdaddr_B(test_in_pipeaddr_B),
    .o_wraddr_A(test_out_pipeaddr_A),
    .o_wraddr_B(test_out_pipeaddr_B),
    .o_wrdata_A(test_out_pipedata_A),
    .o_wrdata_B(test_out_pipedata_B)
);

RAM2B
#( .WORD_SIZE(TEST_WORD_SIZE),
   .MEM_SIZE(TEST_MEM_SIZE) )
TEST_RAM
(
    .i_CLK(MEM_CLK),
    .i_RST(test_RST),
    .i_write_en_A(tst_writeen),
    .i_write_en_B(tst_writeen),
    .i_read_en_A(tst_readen),
    .i_read_en_B(tst_readen),
    .i_write_addr_A(test_out_pipeaddr_A),
    .i_write_addr_B(test_out_pipeaddr_B),
    .i_read_addr_A(test_in_pipeaddr_A),
    .i_read_addr_B(test_in_pipeaddr_B),
    .i_write_data_A(test_out_pipedata_A),
    .i_write_data_B(test_out_pipedata_B),

    .o_read_data_A(test_in_pipedata_A),
    .o_read_data_B(test_in_pipedata_B)
);

always #2 test_CLK <= ~test_CLK;

initial begin
    $dumpfile("scramble.vcd");
    $dumpvars(0, scramble_tb);

    #1
    test_RST <= 1'b1;

    #1
    test_RST <= 1'b0;


    #30 
    // Write out memory contents to file
    memory_dump = $fopen ("memory_dump.hex","w");
    for (i=0; i < TEST_FFT_SIZE*2; i = i + 1) begin
        $fwrite (memory_dump, "%x\n", TEST_RAM.RAM[i]);
    end
    $fclose(memory_dump);

    #1 $finish;
end

endmodule
