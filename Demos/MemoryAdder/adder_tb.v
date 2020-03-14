module adder_tb;

// Input signal parameters
reg test_CLK = 1'b0, test_RST = 1'b0;

/** Test Module Instantiation **/
adder TEST_UNIT (
	test_CLK,
	test_RST
);

	always
		#1 test_CLK = ~test_CLK;

	initial begin
        $dumpfile("adder_tb.vcd");
        $dumpvars(0, adder_tb);

		#1 test_RST <= 1'b1;

		#2 test_RST <= 1'b0;
	
		#27 $finish;
	end
endmodule
