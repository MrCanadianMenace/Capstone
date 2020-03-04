#pragma once

#include <iostream>
#include <string>
#include <stdlib.h>

#include <boost/program_options.hpp>

namespace po = boost::program_options;

void scan_commands(int argc, char** argv, int &fft_size, std::string &input_file, std::string &output_file); 
