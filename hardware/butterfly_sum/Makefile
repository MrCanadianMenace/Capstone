.SILENT:

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
			-cc butterfly_sum.v
	$(MAKE) -C Vsim

icarus:
	iverilog -o butterfly.out double_sign_mult.v complex_mult.v butterfly_sum.v butterfly_sum_tb.v
	vvp butterfly.out
	gtkwave butterfly_sum_tb.vcd

double_wave:
	iverilog -o double_sign_mult.out double_sign_mult.v double_sign_mult_tb.v
	vvp double_sign_mult.out
	gtkwave double_sign_mult_tb.vcd

complex_multiply_wave:
	iverilog -o complex_mult.out double_sign_mult.v complex_mult.v complex_mult_tb.v
	vvp complex_mult.out
	gtkwave complex_mult_tb.vcd
