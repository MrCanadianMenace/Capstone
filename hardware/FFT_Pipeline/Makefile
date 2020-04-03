BUTTERFLY_SUM_MOD_DIR := butterfly_sum
TESTBENCH_DIR := $(PWD)/testbench

MOD_LIB := $(wildcard $(BUTTERFLY_SUM_MOD_DIR)/*.v)
LAYERS := $(wildcard SignalScramble/*.v)
SRC := $(wildcard *.v)
MEMORY := $(wildcard Memory/*.v)
MEM := $(wildcard Memory/*.mem)
DEBUGGER := $(wildcard HexDebugger/*.v)

.SILENT:
icarus:
	iverilog -g2001 -o Pipe.out \
			$(TESTBENCH_DIR)/FFT_Pipeline_tb.v \
			$(MOD_LIB) \
			$(MEMORY) \
			$(SRC) 
	cp -f $(MEM) ./
	vvp Pipe.out 
	gtkwave FFT_Pipeline_tb.vcd & 

demo:
	iverilog -g2001 -o FFT_Demo.out \
			$(TESTBENCH_DIR)/FFT_Demo_tb.v \
			$(MOD_LIB) \
			$(LAYERS) \
			$(MEMORY) \
			$(SRC) 
	cp -f $(MEM) ./
	vvp FFT_Demo.out 
	gtkwave FFT_Demo_tb.vcd & 
	
fft_wave:
	iverilog -g2001 -o FFT_test.out \
			$(TESTBENCH_DIR)/fft_layer_tb.v \
			$(MOD_LIB) \
			$(MEMORY) \
			$(SRC) 
	cp -f $(MEM) ./
	vvp FFT_test.out 
	gtkwave FFT_test_tb.vcd & 

# Currently Doesn't Work
scramble_wave:
	$(MAKE) -C SignalScramble

.PHONY: clean
clean:
	rm -f *.{vcd,out,mem,hex}
