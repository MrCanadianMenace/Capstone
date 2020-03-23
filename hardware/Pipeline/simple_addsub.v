module simple_addsub
	#( parameter WORD_SIZE = 16 )
(
	input i_CLK,
	input [WORD_SIZE-1:0] i_A,
	input [WORD_SIZE-1:0] i_B,

	output reg [WORD_SIZE-1:0] o_sum,
	output reg [WORD_SIZE-1:0] o_diff
);

always @ (posedge i_CLK) begin

	o_sum  <= i_A + i_B;
	o_diff <= i_B - i_A;
end

endmodule
