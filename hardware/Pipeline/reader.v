module reader 
    #( parameter WORD_SIZE = 16,
       parameter ADDR_SIZE = 5 )
(
    input wire i_CLK,
    input wire i_RST,
    input wire [WORD_SIZE-1:0] i_rddata_A,
    input wire [WORD_SIZE-1:0] i_rddata_B,
    input wire [ADDR_SIZE-1:0] i_rdaddr_A,
    input wire [ADDR_SIZE-1:0] i_rdaddr_B,

    output reg [WORD_SIZE-1:0] o_pipedata_A,
    output reg [WORD_SIZE-1:0] o_pipedata_B,
    output reg [ADDR_SIZE-1:0] o_pipeaddr_A,
    output reg [ADDR_SIZE-1:0] o_pipeaddr_B
);

always @ (posedge i_CLK) begin

    /** Pipe data and address to next block **/
    o_pipedata_A <= i_rddata_A; 
    o_pipedata_B <= i_rddata_B;

    o_pipeaddr_A <= i_rdaddr_A;
    o_pipeaddr_B <= i_rdaddr_B;
end

endmodule
