#pragma once
#include <cnl/fixed_point.h>

// Create a fixed point type which has 18 integer bits and 18 fractional bits
typedef cnl::fixed_point<cnl::int64, -18> fixpoint_37;

// Create a fixed point type which has 9 integer bits and 6 fractional bits
typedef cnl::fixed_point<cnl::int16, -6> fixpoint_16;
// Create a fixed point type which has 4 integer bits and 3 fractional bits
typedef cnl::fixed_point<cnl::int8, -3> fixpoint_8;


// Short conversion functions to switch primitive integer types back to fixed point
fixpoint_8 int_to_fixed8(signed char);
fixpoint_16 int_to_fixed16(short signed int);
fixpoint_37 int_to_fixed37(long long int);

class Complex {
    public:
        // Members
        fixpoint_37 real;
        fixpoint_37 imag;

        // Methods
        Complex(fixpoint_37, fixpoint_37);

        long long int real_input();
        long long int imag_input();
        void from_output(long long int real_int, long long int imag_int);
};
