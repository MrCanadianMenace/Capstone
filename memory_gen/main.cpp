#include <string>

#include "command_opts.h"
#include "fileio.h"
#include "fixed_point.h"
#include "twiddle.h"

int main(int argc, char** argv) {

    int twiddle_size;
    std::string out_file_name;
    bool dryrun;
    Fixed_Complex *twiddle_list();

    scan_commands(argc, argv, twiddle_size, out_file_name, dryrun);
    twiddle_list = new Fixed_Complex[twiddle_size];

    for (int i = 0; i < twiddle_size; i++)
        twiddle_list[i] = Fixed_Complex(fixpoint_37{i}, fixpoint_37{i});

    write_file(out_file_name, twiddle_list, twiddle_size, dryrun);
}
