BUTTERFLY_SUM_MOD_DIR := butterfly_sum
TESTBENCH_DIR := $(PWD)/testbench

MOD_LIB := $(wildcard $(BUTTERFLY_SUM_MOD_DIR)/*.v)
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

.PHONY: clean
clean:
	rm -f *.{vcd,out,mem}
