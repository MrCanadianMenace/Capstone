module read_driver(
    input wire i_CLK, 
    input wire i_RST,
    output reg [4:0] o_rdaddr_A,
    output reg [4:0] o_rdaddr_B,
    //TODO: Debug signals
    output wire [3:0] o_state_HEX0
);

	/** Internal Signals **/
	reg [3:0] STATE = 4'b0000;

    assign o_state_HEX0 = STATE;

	always @ (posedge i_CLK, posedge i_RST) begin

		if (i_RST == 1'b1) begin
			STATE		<= 4'b0000;
			o_rdaddr_A 	<= 5'b00000;
			o_rdaddr_B 	<= 5'b00000;
		end

		else begin
            // Walk through several memory addresses to read from
			case (STATE)
				4'h0: begin
					o_rdaddr_A  <= 5'b00000;
					o_rdaddr_B  <= 5'b00001;

					STATE <= STATE + 1;
				end

				4'h1: begin
					o_rdaddr_A  <= 5'h2;
					o_rdaddr_B  <= 5'h3;

					STATE		<= STATE + 1;
				end

				4'h2: begin
					o_rdaddr_A  <= 5'h4;
					o_rdaddr_B  <= 5'h5;

					STATE		<= STATE + 1;
				end

				default: STATE	<= 5'b00000;
			endcase
		end // end if
	end // end always
endmodule
