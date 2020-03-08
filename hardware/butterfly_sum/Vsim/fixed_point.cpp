#include "fixed_point.h"

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
