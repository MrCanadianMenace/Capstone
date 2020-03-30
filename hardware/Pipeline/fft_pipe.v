module fft_pipe
    #( parameter WORD_SIZE = 74,
       parameter ADDR_SIZE = 5 )
(
    input i_CLK,
    input [WORD_SIZE-1:0] i_rddata_A,
    input [WORD_SIZE-1:0] i_rddata_B,
    input [WORD_SIZE-1:0] i_rddata_twiddle,
    input [ADDR_SIZE-1:0] i_rdaddr_A,
    input [ADDR_SIZE-1:0] i_rdaddr_B,

    output wire [WORD_SIZE-1:0] o_wrdata_A,
    output wire [WORD_SIZE-1:0] o_wrdata_B,
    output reg  [ADDR_SIZE-1:0] o_wraddr_A,
    output reg  [ADDR_SIZE-1:0] o_wraddr_B
);

/** Important inter-connecting wires **/
// Calculation pipe process
reg [WORD_SIZE-1:0] r_pipedata_in_A, r_pipedata_in_B;
reg [WORD_SIZE-1:0] r_pipedata_out_A, r_pipedata_out_B;
reg [WORD_SIZE-1:0] r_pipe_in_twiddle;

reg [ADDR_SIZE-1:0] r_pipeaddr_in_A, r_pipeaddr_in_B;
reg [ADDR_SIZE-1:0] r_pipeaddr_out_A, r_pipeaddr_out_B;

/** First Pipe Phase - Reading **/
always @ (posedge i_CLK) begin
    r_pipeaddr_in_A <= i_rdaddr_A;
    r_pipeaddr_in_B <= i_rdaddr_B;

    r_pipedata_in_A     <= i_rddata_A;
    r_pipedata_in_B     <= i_rddata_B;
    r_pipe_in_twiddle   <= i_rddata_twiddle;
end

/** Second Pipe Phase - Calculation **/
butterfly_sum 
#( .WORD_SIZE(WORD_SIZE) )
arithmetic_unit (
    .i_CLK(i_CLK),
    .i_A(r_pipedata_in_A),
    .i_B(r_pipedata_in_B),
    .i_twiddle(r_pipe_in_twiddle),
    .o_A(o_wrdata_A),
	.o_B(o_wrdata_B)
);

/** Third Pipe Phase - Writing **/ 
always @ (posedge i_CLK) begin
    o_wraddr_A <= r_pipeaddr_in_A;
    o_wraddr_B <= r_pipeaddr_in_B;
end

endmodule
