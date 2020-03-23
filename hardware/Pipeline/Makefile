ROOT_DIR := $(PWD)/..
BUTTERFLY_SUM_MOD_DIR := $(ROOT_DIR)/butterfly_sum
MOD_LIB := $(wildcard $(BUTTERFLY_SUM_MOD_DIR)/*.v)

default:
	echo $(BUTTERFLY_SUM_MOD_DIR)
	echo $(MOD_LIB)

icarus:
	iverilog -g2001 -o Pipe.out FFT_Pipeline_tb.v \
			$(MOD_LIB) \
			FFT_Pipeline.v \
			read_driver.v \
			fft_pipe.v \
			reader.v \
			RAM2B.v \
			hex_driver.v \
			simple_addsub.v \
			ReadDebugger.v \
	&& vvp Pipe.out \
	&& gtkwave FFT_Pipeline_tb.vcd &

.PHONY: clean
clean:
	rm -f *.{vcd,out}
	#rm -rf obj_dir
