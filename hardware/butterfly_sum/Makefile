.SILENT:

TESTBENCH_DIR := $(PWD)/testbench
SRC := $(wildcard $(PWD)/*.v)

default:
	@echo "Enter one of the following commands:"
	@echo "	clean verilator icarus double_wave complex_multiply_wave"

.PHONY: clean
clean:
	rm -f *.{vcd,out}
	rm -rf obj_dir
	rm -f Vbutterfly_sim
	$(MAKE) -C Vsim clean

.PHONY: verilator
verilator:
	verilator -Wall \
			--Mdir Vsim/obj_dir \
			--trace \
			-cc butterfly_sum_helper.v
	$(MAKE) -C Vsim

icarus:
	iverilog -o butterfly.out \
			$(TESTBENCH_DIR)/butterfly_sum_tb.v \
			$(SRC) \
	&& vvp butterfly.out \
	&& gtkwave butterfly_sum_tb.vcd &

double_wave:
	iverilog -o double_sign_mult.out \
			$(TESTBENCH_DIR)/double_sign_mult_tb.v \
			$(SRC) \
	&& vvp double_sign_mult.out \
	&& gtkwave double_sign_mult_tb.vcd &

complex_multiply_wave:
	iverilog -o complex_mult.out \
			$(TESTBENCH_DIR)/complex_mult_tb.v \
			$(SRC) \
	&& vvp complex_mult.out \
	&& gtkwave complex_mult_tb.vcd
