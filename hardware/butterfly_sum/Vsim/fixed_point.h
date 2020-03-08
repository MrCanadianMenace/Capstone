#pragma once
#include <cnl/fixed_point.h>

// Create a fixed point type which has 20 integer bits and 12 fractional bits
typedef cnl::fixed_point<cnl::int32, -12> fixpoint_32;
// Create a fixed point type which has 10 integer bits and 6 fractional bits
typedef cnl::fixed_point<cnl::int16, -6> fixpoint_16;
// Create a fixed point type which has 5 integer bits and 3 fractional bits
typedef cnl::fixed_point<cnl::int8, -3> fixpoint_8;

// Short conversion functions to switch primitive integer types back to fixed point
fixpoint_8 int_to_fixed8(signed char);
fixpoint_16 int_to_fixed16(short signed int);
fixpoint_32 int_to_fixed32(long signed int);
