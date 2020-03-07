default:
	@echo "Enter one of the following commands:"
	@echo "	clean verilator"

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
			-cc butterfly_sum.v 
	$(MAKE) -C Vsim
