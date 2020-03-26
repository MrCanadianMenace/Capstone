#pragma once

#include <iostream>
#include <math.h>
#include <complex>

#include "fixed_point.h"

typedef std::complex<double> dcomp;
typedef std::complex<int> int_comp;
const dcomp j(0.0, 1.0);

Fixed_Complex twiddle(double power, double base); 

