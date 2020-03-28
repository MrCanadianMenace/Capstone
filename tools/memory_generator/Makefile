HEADERS := include
TESTBENCH_DIR := rtl/testbench
BIN := bin

SRC := $(wildcard src/*.cpp)
RTL := $(wildcard rtl/*.v) 

.SILENT:

$(BIN):
	mkdir -p $(BIN)
	g++ -L/usr/lib64 \
		-lboost_program_options \
		-I$(HEADERS) \
		$(SRC) \
		-o $(BIN)/mem_gen

icarus: $(BIN) 
	./$(BIN)/mem_gen -n 127 -o $(PWD)/twid.mem \
	&& iverilog -g2001 -o read_driver.out \
		$(TESTBENCH_DIR)/read_driver_tb.v \
		$(RTL) \
	&& vvp read_driver.out \
	&& gtkwave read_driver_tb.vcd

.PHONY: clean
clean:
	rm -f {*.out,*.vcd,*.mem}
	rm -f FFT*
	rm -rf bin
