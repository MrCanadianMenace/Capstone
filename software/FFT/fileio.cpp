#include "fileio.h"

void read_signal_file(std::string file_name, const int fft_size, dcomp *input_signal) {
    std::ifstream input_file;
    input_file.open(file_name, std::ios::in | std::ios::binary);

    std::string line;
    int i = 0;

    // Read real signal values line by line and store them as complex values into the signal array
    if (input_file.is_open())
        while (getline(input_file, line)) {
            double sig_point = std::stod(line);
            dcomp cpx_point(sig_point);
            input_signal[i] = cpx_point;

            if (i >= fft_size)
                break;
            i++;
        }

    input_file.close();
}


void write_fft_out_file(std::string file_name, const int fft_size, dcomp *input_signal, duration_us calc_time) {

    // Open file to write to
    std::ofstream output_file;
    output_file.open(file_name, std::ios::out | std::ios::binary);
    
    // Write the FFT complex output line by line
    for (int i = 0; i < fft_size; i++) {

       dcomp  cpx_signal = input_signal[i]; 
       double real_signal = cpx_signal.real();
       double imag_signal = cpx_signal.imag();
        
       output_file << real_signal << "," << imag_signal << std::endl;
    }

    // Print an empty line separator then the algorithm calculation time
    output_file << std::endl << calc_time.count() << std::endl;

    output_file.close();
}
