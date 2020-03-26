module read_driver_tb;

reg test_CLK = 1'b0, test_RST = 1'b0;

/** Test Module **/
read_driver TEST_MOD 
(
	.i_CLK(test_CLK),
	.i_RST(test_RST)
);

/** Clock Driver **/
always #1 test_CLK <= ~test_CLK; 

/** Driving Logic **/
initial begin
	$dumpfile("read_driver_tb.vcd");
	$dumpvars(0, read_driver_tb);
	
	// Start with reset
	#1 test_RST <= 1'b1;
	#1 test_RST <= 1'b0;

	// Complete after 5 more clock cycles
	#200 $finish;
end

endmodule
