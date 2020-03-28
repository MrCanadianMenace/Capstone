ROOT_DIR := $(PWD)/..
BUTTERFLY_SUM_MOD_DIR := $(ROOT_DIR)/butterfly_sum
TESTBENCH_DIR := $(PWD)/testbench

MOD_LIB := $(wildcard $(BUTTERFLY_SUM_MOD_DIR)/*.v)
SRC := $(wildcard $(PWD)/*.v)

.SILENT:
icarus:
	iverilog -g2001 -o Pipe.out \
			$(TESTBENCH_DIR)/FFT_Pipeline_tb.v \
			$(MOD_LIB) \
			$(SRC) \
	&& vvp Pipe.out \
	&& gtkwave FFT_Pipeline_tb.vcd &

.PHONY: clean
clean:
	rm -f *.{vcd,out}
	#rm -rf obj_dir
