#include "twiddle.h"


Fixed_Complex twiddle(double power, double base) {
    
    dcomp cpx_twiddle = exp(-2.0 * j * M_PI * power / base);

	return Fixed_Complex(fixpoint_37{cpx_twiddle.real()}, fixpoint_37{cpx_twiddle.imag()}); 
}
