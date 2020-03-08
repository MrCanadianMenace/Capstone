.SILENT:
build:
	$(MAKE) -C obj_dir -f Vbutterfly_sum.mk
	g++ -Iobj_dir \
		-I/usr/share/verilator/include \
		/usr/share/verilator/include/verilated.cpp \
		/usr/share/verilator/include/verilated_vcd_c.cpp \
		testbench.hpp \
		fixed_point.cpp \
		obj_dir/*.h \
		obj_dir/*.o \
		VTest.cpp \
		-o ../Vbutterfly_sim

.PHONY: clean
clean:
	rm -rf obj_dir
