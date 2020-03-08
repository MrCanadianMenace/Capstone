#include "fixed_point.h"
#include <iostream>

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

fixpoint_32 int_to_fixed32(long signed int int_num) {

    fixpoint_32 converted_integer = fixpoint_32{int_num >> 12};
    fixpoint_32 converted_fraction = (fixpoint_32{int_num & 0xFFF}) >> 12;
    return converted_integer + converted_fraction;
}

Complex::Complex(fixpoint_16 real, fixpoint_16 imag) {

    this->real = real;
    this->imag = imag;
}

long signed int Complex::to_input() {
    
    return (to_rep(real) << 16) + to_rep(imag);
}

void Complex::from_output(long signed int out) {

    // Reassemble Real part
    real = out >> 16; 
    fixpoint_16 real_int = fixpoint_16{real >> 6};
    fixpoint_16 real_frac = (fixpoint_16{real & 0x3F}) >> 6;    
    real = real_int + real_frac;

    imag = out & 0xFFFF; 
    fixpoint_16 imag_int = fixpoint_16{imag >> 6};
    fixpoint_16 imag_frac = (fixpoint_16{imag & 0x3F}) >> 6;    
    imag = imag_int + imag_frac;
}

