icarus:
	iverilog -o Pipe.out FFT_Pipeline_tb.v \
			FFT_Pipeline.v \
			read_driver.v \
			reader.v \
			RAM2B.v \
			hex_driver.v \
			ReadDebugger.v
	vvp Pipe.out
	gtkwave FFT_Pipeline_tb.vcd &
