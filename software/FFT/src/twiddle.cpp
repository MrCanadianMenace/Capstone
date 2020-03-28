#include "twiddle.h"


dcomp twiddle(double power, double base) {

	return exp(-2.0 * j * M_PI * power / base);
}
