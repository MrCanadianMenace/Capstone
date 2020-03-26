#pragma once

#include <iostream>
#include <string>
#include <stdlib.h>

#include <boost/program_options.hpp>

namespace po = boost::program_options;

void scan_commands(int argc, char** argv, int &twiddle_size, std::string &output_file, bool &dryrun); 
