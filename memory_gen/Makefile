default:
	g++ -L/usr/lib64 -lboost_program_options -o mem_gen.out main.cpp command_opts.cpp fileio.cpp fixed_point.cpp twiddle.cpp

.PHONY: clean
clean:
	rm -f *.out
	rm -f FFT*
	rm -rf build
