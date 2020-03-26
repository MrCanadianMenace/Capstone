#include <string>

#include "command_opts.h"
#include "fileio.h"
#include "fixed_point.h"
#include "twiddle.h"

int main(int argc, char** argv) {

    int twiddle_table_depth;
    std::string out_file_name;
    bool dryrun;
    Fixed_Complex *twiddle_list;

    scan_commands(argc, argv, twiddle_table_depth, out_file_name, dryrun);
    
    twiddle_list = new Fixed_Complex[twiddle_table_depth];

    for (int i = 0; i < twiddle_table_depth; i++) {
        dcomp curr_twiddle = twiddle_table[i];
        twiddle_list[i] = Fixed_Complex(curr_twiddle.real(), curr_twiddle.imag());
    }

    write_file(out_file_name, twiddle_list, twiddle_table_depth, dryrun);
}
