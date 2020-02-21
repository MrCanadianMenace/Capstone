#!/usr/bin/python
import numpy as np
import sys, getopt
import cmath, math

def main(argv):
    try:
        opts, args = getopt.getopt(argv,"hn:o:",["number-twiddle-factors=","output-file="])
    except getopt.GetoptError:
        print("twiddle_hex_gen.py -n <number_of_twiddle_factors> -o <output_file>")
        sys.exit(2)

    # Handle no arguments
    if len(argv) != 4:
        print("Invalid Number of Arguments (%d)" % len(argv))
        print("twiddle_hex_gen.py -n <number_of_twiddle_factors> -o <output_file>")
        sys.exit(2)

    # Process command-line arguments
    for opt, arg in opts:
        if opt == '-h':
            print("twiddle_hex_gen -n <number_of_twiddle_factors> -o <output_file>")
            sys.exit()
        # Set FFT size
        elif opt in ("-n", "--fft-size"):
            fft_size = arg
        # Set output file to write hex encoded twiddle factors to
        elif opt in ("-o", "--output-file"):
            try:
                out_file = open(arg, "w+")
            except FileNotFoundError as err:
                print("Error opening %s: %s" % (arg, err.strerror))
                exit(1)

    num_layers = math.log2(int(fft_size))
    for layer in range(int(num_layers)):
        base = 2**(layer + 1)
        for i in range(base):
            twiddle_real, twiddle_imag = twiddle(base, i)

            # Convert each 16-bit floating point value to IEEE-754 encoded
            real_hex = hex(np.float16(twiddle_real).view('H'))[2:6].zfill(4)
            imag_hex = hex(np.float16(twiddle_imag).view('H'))[2:6].zfill(4)
            #print("W_%d_%d: %.4f / %.4f" % (base,i,twiddle_real,twiddle_imag))
            out_file.write(real_hex+"\n")
            out_file.write(imag_hex+"\n")

    out_file.close()


def twiddle(base, power):
    complex_twiddle = cmath.exp(-2.0j * cmath.pi * power / base)
    return complex_twiddle.real, complex_twiddle.imag


if __name__ == "__main__":
    main(sys.argv[1:])
