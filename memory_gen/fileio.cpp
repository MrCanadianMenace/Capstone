#include "fileio.h"

void write_file(std::string file_name, Fixed_Complex *twiddle_list, const int fft_size, bool dryrun) {

    std::ofstream output_file;
    // Open file to write to
    if (!dryrun) {
        output_file.open(file_name, std::ios::out | std::ios::binary);
    }
    
    // Write the FFT complex output line by line
    for (int i = 0; i < fft_size; i++) {

        if (dryrun) 
            std::cout << twiddle_list[i].real_hex << "/" << twiddle_list[i].imag_hex << std::endl;
        else
            output_file << twiddle_list[i].real_hex << twiddle_list[i].imag_hex << std::endl;
    }

    if (!dryrun)
        output_file.close();

}
