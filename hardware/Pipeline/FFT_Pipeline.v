
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module FFT_Pipeline(

	//////////// CLOCK //////////
	input 		          		CLOCK_50,
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,

	//////////// LED //////////
	output		     [8:0]		LEDG,
	output		    [17:0]		LEDR,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		    [17:0]		SW,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	//output		     [6:0]		HEX1,
	//output		     [6:0]		HEX2,
	//output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,
	output		     [6:0]		HEX6,
	output		     [6:0]		HEX7,

	//////////// LCD //////////
	output		          		LCD_BLON,
	inout 		     [7:0]		LCD_DATA,
	output		          		LCD_EN,
	output		          		LCD_ON,
	output		          		LCD_RS,
	output		          		LCD_RW,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [31:0]		DRAM_DQ,
	output		     [3:0]		DRAM_DQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_WE_N,

	//////////// SRAM //////////
	output		    [19:0]		SRAM_ADDR,
	output		          		SRAM_CE_N,
	inout 		    [15:0]		SRAM_DQ,
	output		          		SRAM_LB_N,
	output		          		SRAM_OE_N,
	output		          		SRAM_UB_N,
	output		          		SRAM_WE_N,

	//////////// Flash //////////
	output		    [22:0]		FL_ADDR,
	output		          		FL_CE_N,
	inout 		     [7:0]		FL_DQ,
	output		          		FL_OE_N,
	output		          		FL_RST_N,
	input 		          		FL_RY,
	output		          		FL_WE_N,
	output		          		FL_WP_N
);

//=======================================================
//  Parameter declarations
//=======================================================
parameter WORD_SIZE = 74;
parameter MEM_SIZE = 4;

parameter HALF_SIZE = WORD_SIZE / 2;
parameter ADDR_SIZE = $clog2(MEM_SIZE);
parameter TWID_ADDR_SIZE = $clog2(127);

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire CLK = CLOCK_50;
wire STEP = ~KEY[2];
wire MEM_CLK = ~CLK; //~STEP;
wire RST = ~KEY[3];
wire MEMSW = SW[0];
wire PIPESW = SW[1];

wire [WORD_SIZE-1:0] w_readdata_A, w_readdata_B, w_readdata_twiddle;
wire [WORD_SIZE-1:0] w_writedata_A, w_writedata_B;
wire [WORD_SIZE-1:0] w_piperead_A, w_piperead_B;

wire [TWID_ADDR_SIZE-1:0] w_readaddr_twiddle;
wire [ADDR_SIZE-1:0] w_readaddr_A, w_readaddr_B;
wire [ADDR_SIZE-1:0] w_writeaddr_A, w_writeaddr_B;
wire [ADDR_SIZE-1:0] w_pipeaddr_A, w_pipeaddr_B;
wire [3:0] w_driver_state;
wire w_read_en, w_write_en;

//=======================================================
//  Structural coding
//=======================================================

/** Debug LEDs **/
assign LEDG[6] = RST;
assign LEDG[4] = CLK;

assign LEDR[0] = MEMSW;
assign LEDR[1] = PIPESW;


    fft_pipe 
	#(.WORD_SIZE(WORD_SIZE),
      .ADDR_SIZE(ADDR_SIZE))
    pipeline
    (
        .i_CLK(CLK),
        .i_rddata_A(w_readdata_A),
        .i_rddata_B(w_readdata_B),
        .i_rddata_twiddle(w_readdata_twiddle),
        .i_rdaddr_A(w_readaddr_A),
        .i_rdaddr_B(w_readaddr_B),

        .o_wrdata_A(w_writedata_A),
        .o_wrdata_B(w_writedata_B),
        .o_wraddr_A(w_writeaddr_A),
        .o_wraddr_B(w_writeaddr_B)
    );

    RAM2B 
    #(.WORD_SIZE(WORD_SIZE),
      .MEM_SIZE(MEM_SIZE),
      .ADDR_SIZE(ADDR_SIZE))
    RAM(
        .i_CLK(MEM_CLK),
        .i_RST(RST),
        .i_write_en_A(w_write_en),
        .i_write_en_B(w_write_en),
        .i_read_en_A(w_read_en),
        .i_read_en_B(w_read_en),
        .i_write_addr_A(w_writeaddr_A),
        .i_write_addr_B(w_writeaddr_B),
        .i_read_addr_A(w_readaddr_A),
        .i_read_addr_B(w_readaddr_B),
        .i_write_data_A(w_writedata_A),
        .i_write_data_B(w_writedata_B),

        .o_read_data_A(w_readdata_A),
        .o_read_data_B(w_readdata_B)
    );
    
    Twiddle_ROM 
    #( .WORD_SIZE(74),
       .MEM_SIZE(127) )
    ROM (
        .i_read_en(1'b1),
        .i_read_addr(w_readaddr_twiddle),

        .o_read_data(w_readdata_twiddle)
    );

    read_driver 
    #(.ADDR_SIZE(ADDR_SIZE),
      .MAX_STATE(2))
    DRIVER(
        .i_CLK(CLK), 
        .i_RST(RST),

        .o_rden(w_read_en),
        .o_wren(w_write_en),
        .o_rdaddr_A(w_readaddr_A),
        .o_rdaddr_B(w_readaddr_B),
        .o_rdaddr_tw(w_readaddr_twiddle)
    );

    /*
    ReadDebugger DEBUGGER(
        .i_memval(MEMSW),
        .i_pipeval(PIPESW),
        .i_rdaddr_A(w_readaddr_A),
        .i_rdaddr_B(w_readaddr_B),
        .i_rddata_A(w_readdata_A),
        .i_rddata_B(w_readdata_B),
        .i_pipedata_A(w_piperead_A),
        .i_pipedata_B(w_piperead_B),
        .i_STATE(w_driver_state),

        .o_HEX7(HEX7),
        .o_HEX6(HEX6),
        .o_HEX5(HEX5),
        .o_HEX4(HEX4),
        .o_HEX0(HEX0)
    );
    */

endmodule