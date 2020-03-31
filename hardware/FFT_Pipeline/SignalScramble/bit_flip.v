module bit_flip 
#( parameter WORD_SIZE = 74,
   parameter ADDR_SIZE = 5 ) 
(
    input i_CLK,
    input [ADDR_SIZE-1:0] i_pipeaddr_A,
    input [ADDR_SIZE-1:0] i_pipeaddr_B,
    input [WORD_SIZE-1:0] i_pipedata_A,
    input [WORD_SIZE-1:0] i_pipedata_B,

    output reg [ADDR_SIZE-1:0] o_pipeaddr_A,
    output reg [ADDR_SIZE-1:0] o_pipeaddr_B,
    output reg [WORD_SIZE-1:0] o_pipedata_A,
    output reg [WORD_SIZE-1:0] o_pipedata_B
);

// For loop iterator
integer i;

always @ (posedge i_CLK) begin
    // Pipe data through without changing
    o_pipedata_A <= i_pipedata_A;
    o_pipedata_B <= i_pipedata_B;

    // Swap outer address bits
    o_pipeaddr_A[0]             <= i_pipeaddr_A[ADDR_SIZE-1];
    o_pipeaddr_A[ADDR_SIZE-1]   <= i_pipeaddr_A[0];

    o_pipeaddr_B[0]             <= i_pipeaddr_B[ADDR_SIZE-1];
    o_pipeaddr_B[ADDR_SIZE-1]   <= i_pipeaddr_B[0];

    // Swap all middle address bits
    for (i=1; i<=ADDR_SIZE/2; i=i+1) begin
        o_pipeaddr_A[i]             <= i_pipeaddr_A[ADDR_SIZE-1-i];
        o_pipeaddr_A[ADDR_SIZE-1-i] <= i_pipeaddr_A[i];

        o_pipeaddr_B[i]             <= i_pipeaddr_B[ADDR_SIZE-1-i];
        o_pipeaddr_B[ADDR_SIZE-1-i] <= i_pipeaddr_B[i];
    end
end

endmodule
