#include <string>

#include "command_opts.h"
#include "fileio.h"
#include "fixed_point.h"
#include "twiddle.h"

int main(int argc, char** argv) {

    // Command line option variables
    int twiddle_table_depth;
    std::string out_file_name;
    bool dryrun;

    // Interpret command line options using boost library
    scan_commands(argc, argv, twiddle_table_depth, out_file_name, dryrun);
    
    // Create list to hold all twiddle factors
    Fixed_Complex *twiddle_list = new Fixed_Complex[twiddle_table_depth];

    // Fill the twiddle factor list using the double type constructor
    for (int i = 0; i < twiddle_table_depth; i++) {
        dcomp curr_twiddle = twiddle_table[i];
        twiddle_list[i] = Fixed_Complex(curr_twiddle.real(), curr_twiddle.imag());
    }

    // Send the filled twiddle list to be converted into a hex string then
    // written out into a text file
    write_file(out_file_name, twiddle_list, twiddle_table_depth, dryrun);
}
