#include <fstream>
#include <string>

#include "twiddle.h"
#include "fixed_point.h"

void write_file(std::string file_name, Fixed_Complex *twiddle_list, const int fft_size, bool dryrun);

void twiddle_hex_string(char (&hex_string)[20], Fixed_Complex twiddle); 
