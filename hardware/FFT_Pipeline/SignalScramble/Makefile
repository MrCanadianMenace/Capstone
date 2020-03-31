TESTBENCH_DIR := $(PWD)/testbench
SRC := $(wildcard $(PWD)/*.v)
MEMORY := $(wildcard $(PWD)/Memory/*.v)

MEM_FILE := $(PWD)/Memory/test.mem

.SILENT:
flip_wave:
	iverilog -g2001 -o flip.out \
			$(TESTBENCH_DIR)/bit_flip_tb.v \
			$(PWD)/bit_flip.v
	vvp flip.out
	gtkwave bit_flip_test.vcd & 

scramble_wave:
	iverilog -g2001 -o scramble.out \
			$(TESTBENCH_DIR)/scramble_tb.v \
			$(MEMORY) \
			$(SRC)
	cp -f $(MEM_FILE) ./
	vvp scramble.out
	gtkwave scramble.vcd & 

clean:
	rm -f *.{out,vcd,mem,hex}
