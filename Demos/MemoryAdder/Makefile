icarus:
	iverilog -o adder.out mem.v adder.v adder_tb.v
	vvp adder.out
	gtkwave adder_tb.vcd

mem_wave:
	iverilog -o mem.out mem.v mem_tb.v
	vvp mem.out
	gtkwave mem_tb.vcd

clean:
	rm -f *.{out,vcd}
