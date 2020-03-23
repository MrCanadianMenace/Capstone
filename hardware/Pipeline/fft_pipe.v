module fft_pipe
    #( parameter WORD_SIZE = 16,
       parameter ADDR_SIZE = 5 )
(
    input i_CLK,
    input [WORD_SIZE-1:0] i_rddata_A,
    input [WORD_SIZE-1:0] i_rddata_B,
    input [ADDR_SIZE-1:0] i_rdaddr_A,
    input [ADDR_SIZE-1:0] i_rdaddr_B,

    output wire [WORD_SIZE-1:0] o_wrdata_A,
    output wire [WORD_SIZE-1:0] o_wrdata_B,
    output wire [ADDR_SIZE-1:0] o_wraddr_A,
    output wire [ADDR_SIZE-1:0] o_wraddr_B
);

/** Important inter-connecting wires **/
// Calculation pipe process
wire [WORD_SIZE-1:0] w_pipedata_in_A, w_pipedata_in_B;
reg  [WORD_SIZE-1:0] r_pipedata_out_A, r_pipedata_out_B;
wire [ADDR_SIZE-1:0] w_pipeaddr_in_A, w_pipeaddr_in_B;
reg  [ADDR_SIZE-1:0] r_pipeaddr_out_A, r_pipeaddr_out_B;

/** Inner-pipe process module instantiation **/
reader  
    #( .WORD_SIZE(WORD_SIZE),
       .ADDR_SIZE(ADDR_SIZE))
mem_read (
    .i_CLK(i_CLK),
    .i_RST(i_RST),
    .i_rddata_A(i_rddata_A),
    .i_rddata_B(i_rddata_B),
    .i_rdaddr_A(i_rdaddr_A),
    .i_rdaddr_B(i_rdaddr_B),

    .o_pipedata_A(w_pipedata_in_A),
    .o_pipedata_B(w_pipedata_in_B),
    .o_pipeaddr_A(w_pipeaddr_in_A),
    .o_pipeaddr_B(w_pipeaddr_in_B)
);

simple_addsub
    #( .WORD_SIZE(WORD_SIZE) )
addersubtractor (
    .i_CLK(i_CLK),
    .i_A(w_pipedata_in_A),
    .i_B(w_pipedata_in_B),

    .o_sum(o_wrdata_A),
    .o_diff(o_wrdata_B)
);

/** Address Register Piping Final Phase **/ 
always @ (posedge i_CLK) begin
    r_pipeaddr_out_A <= w_pipeaddr_in_A;
    r_pipeaddr_out_B <= w_pipeaddr_in_B;
end

/** Memory Write Logic **/
assign o_wraddr_A = r_pipeaddr_out_A;
assign o_wraddr_B = r_pipeaddr_out_B;

endmodule
