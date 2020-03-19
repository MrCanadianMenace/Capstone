module reader 
    #( parameter WORD_SIZE = 16 )
(
    input wire i_CLK,
    input wire i_RST,
    input wire [WORD_SIZE-1:0] i_rddata_A,
    input wire [WORD_SIZE-1:0] i_rddata_B,

    output reg [WORD_SIZE-1:0] o_pipedata_A,
    output reg [WORD_SIZE-1:0] o_pipedata_B
);

always @ (posedge i_CLK) begin

    o_pipedata_A <= i_rddata_A; 
    o_pipedata_B <= i_rddata_B;
end

endmodule
