#include <iostream>

#include "fileio.h"

void write_file(std::string file_name, Fixed_Complex *twiddle_list, const int twiddle_table_depth, bool dryrun) {

    std::ofstream output_file;
    // Open file to write to
    if (!dryrun) {
        output_file.open(file_name, std::ios::out | std::ios::binary);
    }
    
    // Write the FFT complex output line by line
    for (int i = 0; i < twiddle_table_depth; i++) {

        char print_string[20] = {0};
        twiddle_hex_string(print_string, twiddle_list[i]); 

        if (dryrun) 
            std::cout << print_string << std::endl;
        else
            output_file << print_string << std::endl;
    }

    if (!dryrun)
        output_file.close();

}

void twiddle_hex_string(char (&hex_string)[20], Fixed_Complex twiddle) {

    char imag_hex[11] = {0}, real_hex[11] = {0};
    fixed_to_hex(imag_hex, twiddle.imag_input());

    // Shift the real value over 1 bit to shift in imaginary Most Significant Bit
    long long int real_fixed_int = twiddle.real_input() << 1; 
    // Perform conversion from Ascii to int on Most Significant byte of imag_hex 
    // then logic OR it into real_fixed_int
    real_fixed_int |= (int) imag_hex[0] - 48;

    fixed_to_hex(real_hex, real_fixed_int);
    if (real_fixed_int < 0)
        real_hex[0] |= 3;

    // Fill in upper ten hex values with real hex values
    for (int i = 0; i < 10; i++)
        hex_string[i] = real_hex[i];

    // Fill in lower nine hex values with imaginary hex values
    for (int i = 1; i < 10; i++) 
        hex_string[i+9] = imag_hex[i];
}
