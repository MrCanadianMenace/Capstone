module read_driver
#( parameter WORD_SIZE = 74,
   parameter ADDR_SIZE = $clog2(127),
   parameter MAX_STATE = 127 )
(
    input i_CLK, 
    input i_RST
);
    // Useful Parameter
    parameter STATE_SIZE = $clog2(MAX_STATE);
    parameter HALF_SIZE = WORD_SIZE / 2;

	/** Internal Signals **/
	reg  [STATE_SIZE-1:0] STATE = 'd0;
    reg  [ADDR_SIZE-1:0] r_rdaddr;
    wire [WORD_SIZE-1:0] w_rddata;
    wire [HALF_SIZE-1:0] w_rddata_real, w_rddata_imag;

    assign w_rddata_real = w_rddata[WORD_SIZE-1:HALF_SIZE];
    assign w_rddata_imag = w_rddata[HALF_SIZE-1:0];

    Twiddle_ROM 
    #( .WORD_SIZE(74),
       .MEM_SIZE(127) )
    ROM (
        .i_read_en(1'b1),
        .i_read_addr(r_rdaddr),

        .o_read_data(w_rddata)
    );

	always @ (posedge i_CLK, posedge i_RST) begin

		if (i_RST == 1'b1) begin
			STATE		<= 'd0;
			r_rdaddr 	<= 'h0;
		end

		else begin
            // Walk through several memory addresses to read from
			case (STATE)
				'h0: begin
					r_rdaddr    <= 'd0;
					STATE       <= STATE + 1;
				end

                MAX_STATE: begin
                    r_rdaddr    <= r_rdaddr + 1;
                    STATE       <= 'd0; 
                end

                default: begin 
                    r_rdaddr    <= r_rdaddr + 1;
                    STATE       <= STATE + 1;
                end

			endcase
		end // end if
	end // end always

endmodule
