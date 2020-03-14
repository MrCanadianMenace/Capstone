module adder(
    input wire i_CLK, 
    input wire i_RST,
    output wire [3:0] mem_addr_HEX0,
    output wire [3:0] mem_addr_HEX1,
    output wire [3:0] mem_val_HEX0,
    output wire [3:0] mem_val_HEX1,
    output wire [3:0] state_HEX0
);

	/** Internal Signals **/
	reg [2:0] STATE = 4'b0000;
	reg read_en, write_en = 0;
	reg [4:0] read_addr, write_addr;
	reg [15:0] write_data;
	wire [15:0] read_data;

	reg [15:0] op_A, op_B;
    wire[15:0] sum;
    //reg read_delay = 1'b0;

	/** Memory Module **/
	RAM1 mem(
        .address(read_addr),
		.clock(i_CLK), 
		.data(write_data),
        .rden(read_en),
		.wren(write_en),
		.q(read_data)
	); 

    /** Asynchronous Combinational Adder **/
    assign sum = op_A + op_B;
    assign mem_addr_HEX0 = read_addr[3:0];
    assign mem_addr_HEX1 = {{3{1'b0}}, read_addr[4]};
    assign mem_val_HEX0 = read_data[3:0];
    assign mem_val_HEX1 = read_data[7:4];
    assign state_HEX0 = {{1'b0}, STATE};

	always @ (posedge i_CLK) begin
		if (i_RST == 1'b1) begin
			STATE		<= 4'b0000;
			read_en 	<= 1'b0;
			write_en 	<= 1'b0;
			read_addr 	<= 5'b00000;
			//write_addr 	<= 5'b00000;
			write_data 	<= 16'h0000;
		end

		else begin
            // Each comment describes what will happen on the following rising
            // edge
			case (STATE)
                //  Write 0x3 to Memory Address 0x1
				4'h0: begin
					write_en <= 1'b1;
					//write_addr = 5'b00001;
					read_addr <= 5'b00001;
					write_data <= 16'h0003;
					STATE <= STATE + 1;
				end

                // Write 0x4 to Memory Address 0x2
				4'h1: begin
					//write_addr	<= 5'b00010;
					read_addr	<= 5'b00010;
					write_data	<= 16'h0004;
					STATE		<= STATE + 1;
				end

                // Read value from Memory Address 0x1
				4'h2: begin
					write_en	<= 1'b0;
					read_en		<= 1'b1;
					read_addr	<= 5'b00001;
					STATE		<= STATE + 1;
				end

                // Read value from Memory Address 0x2
				4'h3: begin
					op_A		<= read_data;
					read_addr	<= 5'b00010;
					STATE		<= STATE + 1;
				end

                // Disable reading
				4'h4: begin
					read_en		<= 1'b0;
					op_B		<= read_data;
					STATE		<= STATE + 1;
				end

                // Write the sum of A and B to Address 0x2
				4'h5: begin
					write_en	<= 1'b1;
					write_data	<= sum;
					STATE		<= STATE + 1;
				end

                // Disable memory writing and loop back to state 2
				4'h6: begin
					write_en	<= 1'b0;
					STATE		<= 4'h2;
				end
				default: STATE	<= 3'b000;
			endcase
		end // end if
	end // end always
endmodule
