#pragma once
#include <cnl/fixed_point.h>

// Create a fixed point type which has 18 integer bits and 18 fractional bits
typedef cnl::fixed_point<cnl::int64, -18> fixpoint_37;
        
void fixed_to_hex(char (&hex_string)[11], long long int fixed_int);

class Fixed_Complex {
    public:
        // Members
        fixpoint_37 real;
        fixpoint_37 imag;

        char real_hex[10];
        char imag_hex[10];

        // Methods
        Fixed_Complex();
        Fixed_Complex(double, double);

        long long int real_input();
        long long int imag_input();
};
