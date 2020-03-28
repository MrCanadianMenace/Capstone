module read_driver
#(parameter ADDR_SIZE = 5,
  parameter TWID_ADDR_SIZE = $clog2(127),
  parameter MAX_STATE = 3 )
(
    input wire i_CLK, 
    input wire i_RST,

    output reg o_rden,
    output reg o_wren,
    output reg [ADDR_SIZE-1:0] o_rdaddr_A,
    output reg [ADDR_SIZE-1:0] o_rdaddr_B,
    output reg [TWID_ADDR_SIZE-1:0] o_rdaddr_tw,
    //TODO: Debug signals
    output wire [3:0] o_state_HEX0
);
    // Useful Parameter
    parameter STATE_SIZE = $clog2(MAX_STATE+3);

	/** Internal Signals **/
	reg [STATE_SIZE-1:0] STATE = 'h0;

    assign o_state_HEX0 = STATE;

	always @ (posedge i_CLK, posedge i_RST) begin

		if (i_RST == 1'b1) begin
			STATE		<= 4'b0000;
			o_rdaddr_A 	<= 'h0;
			o_rdaddr_B 	<= 5'b00000;
            o_rdaddr_tw <= 'd0;
            o_rden      <= 1'b0;
            o_wren      <= 1'b0;
		end

		else begin
            o_rdaddr_tw <= 'd0;

            // Walk through several memory addresses to read from
			case (STATE)
				'h0: begin
                    o_rden      <= 'b1;
					o_rdaddr_A  <= 5'b00000;
					o_rdaddr_B  <= 5'b00001;

					STATE       <= STATE + 1;
				end

                /*
                'h2: begin
                    o_wren      <= 'h1;

                    o_rdaddr_A  <= o_rdaddr_A + 2;
                    o_rdaddr_B  <= o_rdaddr_B + 2;
                    STATE	    <= STATE + 1;
                end
                */
                
                MAX_STATE: begin
                    o_rden  <= 'b0;
                    o_wren  <= 'h1;
                    STATE   <= STATE + 1; 
                end

                MAX_STATE + 2: begin
                    o_wren  <= 'b0;
                    STATE   <= 'h0;
                end
                    
                default: begin 
                    o_rdaddr_A  <= o_rdaddr_A + 2;
                    o_rdaddr_B  <= o_rdaddr_B + 2;
                    STATE       <= STATE + 1;
                end

			endcase
		end // end if
	end // end always

endmodule
