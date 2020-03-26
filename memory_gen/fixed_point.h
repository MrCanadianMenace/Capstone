#pragma once
#include <cnl/fixed_point.h>

// Create a fixed point type which has 18 integer bits and 18 fractional bits
typedef cnl::fixed_point<cnl::int64, -18> fixpoint_37;

class Fixed_Complex {
    public:
        // Members
        fixpoint_37 real;
        fixpoint_37 imag;

        char real_hex[10];
        char imag_hex[9];

        // Methods
        Fixed_Complex();
        Fixed_Complex(fixpoint_37, fixpoint_37);

        long long int real_input();
        long long int imag_input();

    private:
        void fixed_real_to_hex();
        void fixed_imag_to_hex();
};
