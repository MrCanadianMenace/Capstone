.PHONY: default
default:
	@echo "Enter one of the following commands:"
	@echo "clean"
	@echo "sim"

.PHONY: clean
clean:
	rm *.{vcd,out}
	rm -rf obj_dir

sim:
	verilator -Wall -cc butterfly_sum.v 
	#g++ -I./obj_dir -I/usr/share/verilator/include VTest.cpp /usr/share/verilator/include/verilated.cpp *.h *.o -o Vcomplex_ad    d_sim
