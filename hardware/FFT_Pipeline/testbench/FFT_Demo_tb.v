module FFT_Demo_tb;

// Test parameters
parameter TEST_WORD_SIZE = 74;
parameter TEST_HALF_WORD = TEST_WORD_SIZE / 2;
parameter TEST_FFT_SIZE  = 8;
parameter TEST_NUM_LAYERS = $clog2(TEST_FFT_SIZE) + 1; // One scramble layer, three FFT layers
parameter TEST_MEM_SIZE  = TEST_FFT_SIZE * 2;
parameter TEST_ADDR_SIZE = $clog2(TEST_MEM_SIZE);
parameter TEST_TWID_ADDR_SIZE = $clog2(127);

// Iterators in for loops
integer i;
integer memory_dump;

// Driving test signals
reg test_CLK = 0, test_RST = 0;

/** Bus Wires **/
wire w_bus_readen, w_bus_writeen;
wire [TEST_ADDR_SIZE-1:0] w_bus_readaddr_A, w_bus_readaddr_B;
wire [TEST_TWID_ADDR_SIZE-1:0] w_bus_twiddle_addr;
wire [TEST_ADDR_SIZE-1:0] w_bus_writeaddr_A, w_bus_writeaddr_B;
wire [TEST_WORD_SIZE-1:0] w_bus_writedata_A, w_bus_writedata_B;
wire w_chipselect [TEST_NUM_LAYERS-1:0];


/** Array of Output Drivers **/
// Read/Write Enable Drivers
wire w_readen [TEST_NUM_LAYERS-1:0], w_writeen [TEST_NUM_LAYERS-1:0];
// Done Signal Drivers
wire w_done [TEST_NUM_LAYERS-1:0];
// Read Address Drivers
wire [TEST_ADDR_SIZE-1:0]       w_readaddr_A    [TEST_NUM_LAYERS-1:0];
wire [TEST_ADDR_SIZE-1:0]       w_readaddr_B    [TEST_NUM_LAYERS-1:0];
wire [TEST_TWID_ADDR_SIZE-1:0]  w_readaddr_tw   [TEST_NUM_LAYERS-1:0];
// Write Address Drivers
wire [TEST_ADDR_SIZE-1:0] w_writeaddr_A [1:0];
wire [TEST_ADDR_SIZE-1:0] w_writeaddr_B [1:0];
// Write Data Drivers
wire [TEST_WORD_SIZE-1:0] w_writedata_A [1:0];
wire [TEST_WORD_SIZE-1:0] w_writedata_B [1:0];

/** Scramble Layer Wires **/
wire [TEST_WORD_SIZE-1:0] w_readdata_A, w_readdata_B;

scramble
#( .WORD_SIZE(TEST_WORD_SIZE),
   .ADDR_SIZE(TEST_ADDR_SIZE),
   .FFT_SIZE(TEST_FFT_SIZE) )
SHUFFLE
(
    .i_CLK(test_CLK),
    .i_RST(test_RST),
    .i_rddata_A(w_readdata_A),
    .i_rddata_B(w_readdata_B),

    .o_rden(w_readen[0]),
    .o_wren(w_writeen[0]),
    .o_done(w_done[0]),
    .o_rdaddr_A(w_readaddr_A[0]),
    .o_rdaddr_B(w_readaddr_B[0]),
    .o_wraddr_A(w_writeaddr_A[0]),
    .o_wraddr_B(w_writeaddr_B[0]),
    .o_wrdata_A(w_writedata_A[0]),
    .o_wrdata_B(w_writedata_B[0])
);

// 0: Scramble layer, 1: 2pt layer, 2: 4pt layer, 3: 8pt layer
parameter LAYER_SELECT_SIZE = $clog2(TEST_NUM_LAYERS);
reg [LAYER_SELECT_SIZE-1:0] r_layer_sel;

// Generate 3 Layers of FFT Control Signals
genvar layer;
generate
    for (layer=1; layer<TEST_NUM_LAYERS; layer = layer + 1) begin: FFT_LAYERS

        fft_layer
        #(  .FFT_SIZE(TEST_FFT_SIZE),
	        .MEM_OFFSET(TEST_FFT_SIZE),
            .LAYER_NUM(layer-1),
            .ADDR_SIZE(TEST_ADDR_SIZE) )
        LAYER (
            .i_CLK(test_CLK), 
            .i_RST(test_RST),
            .i_CS(w_chipselect[layer]),

            .o_done(w_done[layer]),
            .o_rden(w_readen[layer]),
            .o_wren(w_writeen[layer]),
            .o_rdaddr_A(w_readaddr_A[layer]),
            .o_rdaddr_B(w_readaddr_B[layer]),
            .o_rdaddr_tw(w_readaddr_tw[layer])
        );

        // Enable chipselect based on the layer select register
        assign w_chipselect[layer] = (r_layer_sel==layer) ? 1'b1 : 1'b0;

    end
endgenerate

/** Test RAM Wires **/
wire MEM_CLK = ~test_CLK;

RAM2B
#( .WORD_SIZE(TEST_WORD_SIZE),
   .MEM_SIZE(TEST_MEM_SIZE) )
TEST_RAM
(
    .i_CLK(MEM_CLK),
    .i_RST(test_RST),
    .i_write_en_A(w_bus_writeen),
    .i_write_en_B(w_bus_writeen),
    .i_read_en_A(w_bus_readen),
    .i_read_en_B(w_bus_readen),
    .i_write_addr_A(w_bus_writeaddr_A),
    .i_write_addr_B(w_bus_writeaddr_B),
    .i_read_addr_A(w_bus_readaddr_A),
    .i_read_addr_B(w_bus_readaddr_B),
    .i_write_data_A(w_bus_writedata_A),
    .i_write_data_B(w_bus_writedata_B),

    .o_read_data_A(w_readdata_A),
    .o_read_data_B(w_readdata_B)
);

/** Test Twiddle ROM Wires **/
wire [TEST_WORD_SIZE-1:0] w_twid_data;
Twiddle_ROM 
#(	.WORD_SIZE(TEST_WORD_SIZE),
    .MEM_SIZE(127),
    .ADDR_SIZE(TEST_TWID_ADDR_SIZE) )
TWID_ROM (
	.i_read_en(1'b1),
    .i_read_addr(w_bus_twiddle_addr),

    .o_read_data(w_twid_data)
);

fft_pipe
#(  .WORD_SIZE(TEST_WORD_SIZE),
    .ADDR_SIZE(TEST_ADDR_SIZE) )
PIPE_PROCESSOR (
    .i_CLK(test_CLK),
    .i_rddata_A(w_readdata_A),
    .i_rddata_B(w_readdata_B),
    .i_rddata_twiddle(w_twid_data),
    .i_rdaddr_A(w_bus_readaddr_A),
    .i_rdaddr_B(w_bus_readaddr_B),

    .o_wrdata_A(w_writedata_A[1]),
    .o_wrdata_B(w_writedata_B[1]),
    .o_wraddr_A(w_writeaddr_A[1]),
    .o_wraddr_B(w_writeaddr_B[1])
);

/** Switching Logic for switching between layer 
* 	access to bus
**/
// Read/Write Enables
assign w_bus_writeen        = w_writeen[r_layer_sel];
assign w_bus_readen         = w_readen[r_layer_sel];
// RAM read address
assign w_bus_readaddr_A     = w_readaddr_A[r_layer_sel]; 
assign w_bus_readaddr_B     = w_readaddr_B[r_layer_sel]; 
// ROM twiddle address
assign w_bus_twiddle_addr   = (r_layer_sel == 0) ? 'h0 : w_readaddr_tw[r_layer_sel];
// RAM write address
assign w_bus_writeaddr_A    = (r_layer_sel == 0) ? w_writeaddr_A[0] : w_writeaddr_A[1];
assign w_bus_writeaddr_B    = (r_layer_sel == 0) ? w_writeaddr_B[0] : w_writeaddr_B[1];
// RAM write data
assign w_bus_writedata_A    = (r_layer_sel == 0) ? w_writedata_A[0] : w_writedata_A[1];
assign w_bus_writedata_B    = (r_layer_sel == 0) ? w_writedata_B[0] : w_writedata_B[1];

// Write Debug Wires
wire [TEST_HALF_WORD-1 : 0] w_writedata_real_A = w_bus_writedata_A[TEST_WORD_SIZE-1:TEST_HALF_WORD];
wire [TEST_HALF_WORD-1 : 0] w_writedata_imag_A = w_bus_writedata_A[TEST_HALF_WORD-1:0];

wire [TEST_HALF_WORD-1 : 0] w_writedata_real_B = w_bus_writedata_B[TEST_WORD_SIZE-1:TEST_HALF_WORD];
wire [TEST_HALF_WORD-1 : 0] w_writedata_imag_B = w_bus_writedata_B[TEST_HALF_WORD-1:0];

/** Timing Register **/
reg [10:0] timer;

// Update layer select when the current layer is done
// Also update timer for measuring execution time
always @ (posedge test_CLK) begin
    if (w_done[r_layer_sel])
        r_layer_sel <= r_layer_sel + 1;

    if (!w_done[TEST_NUM_LAYERS-1])
        timer <= timer + 1;
end


// Clock pulse generation
always #2 test_CLK <= ~test_CLK;

initial begin
    $dumpfile("FFT_Demo_tb.vcd");
    $dumpvars(0, FFT_Demo_tb);

    #1
    test_RST    <= 1'b1;
    r_layer_sel <= 'h0;
    timer       <= 'h0;

    #1
    test_RST <= 1'b0;


    #10000 
    // Write out memory contents to file
    memory_dump = $fopen ("memory_dump.hex","w");
    for (i=0; i < TEST_FFT_SIZE*2; i = i + 1) begin
        $fwrite (memory_dump, "%x\n", TEST_RAM.RAM[i]);
    end
    $fclose(memory_dump);

    #1 $finish;
end

endmodule
