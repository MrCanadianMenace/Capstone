HEADERS := include
BIN := bin

SRC := $(wildcard src/*.cpp)

.SILENT:
$(BIN):
	mkdir -p $(BIN)
	g++ -L/usr/lib64 \
		-lboost_program_options  \
		-I$(HEADERS) \
		$(SRC) \
		-o $(BIN)/capfft

.PHONY: clean
clean:
	rm -rf $(BIN)
