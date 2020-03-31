#include "fixed_point.h"
#include <iostream>
#include <stdio.h>

fixpoint_8 int_to_fixed8(signed char int_num) {

    fixpoint_8 converted_integer = fixpoint_8{int_num >> 3};
    fixpoint_8 converted_fraction = (fixpoint_8{int_num & 0x7}) >> 3;
    return converted_integer + converted_fraction;
}

fixpoint_16 int_to_fixed16(short signed int int_num) {

    fixpoint_16 converted_integer = fixpoint_16{int_num >> 6};
    fixpoint_16 converted_fraction = (fixpoint_16{int_num & 0x3F}) >> 6;
    return converted_integer + converted_fraction;
}

fixpoint_37 int_to_fixed37(long long int int_num) {

    fixpoint_37 converted_integer = fixpoint_37{int_num >> 18};
    fixpoint_37 converted_fraction = (fixpoint_37{int_num & 0x3FFFF}) >> 18;
    
    return converted_integer + converted_fraction;
}

Complex::Complex(fixpoint_37 real, fixpoint_37 imag) {

    this->real = real;
    this->imag = imag;
}

long long int Complex::real_input() {
    
    return to_rep(real);
}

long long int Complex::imag_input() {
    
    return to_rep(imag);
}

void Complex::from_output(long long int real_out, long long int imag_out) {

    // Reassemble Real part
    real = int_to_fixed37(real_out);
    imag = int_to_fixed37(imag_out); 
}

