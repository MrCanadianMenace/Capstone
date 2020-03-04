#include <fstream>
#include <string>
#include <chrono>

#include "twiddle.h"

typedef std::chrono::duration<double, std::milli> duration_us;

void read_signal_file(std::string file_name, const int fft_size, dcomp *input_signal); 

void write_fft_out_file(std::string file_name, const int fft_size, dcomp *input_signal, duration_us calc_time);
