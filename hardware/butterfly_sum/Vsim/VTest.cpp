#include <stdlib.h>                                                                                                           
#include "Vbutterfly_sum.h"
#include "verilated.h"

#include "testbench.hpp"
#include "fixed_point.h"
 
int main(int argc, char **argv) {
 
    // Initialize Verliators variables
    Verilated::commandArgs(argc, argv);
    // Create an instance of our module under test
    TESTBENCH<Vbutterfly_sum> *tb = new TESTBENCH<Vbutterfly_sum>();

    fixpoint_16 input_A_real = fixpoint_16 {1};
    fixpoint_16 input_A_imag = fixpoint_16 {2};
    long int input_A_cpx = (to_rep(input_A_real) << 16) + input_A_imag; 
    // Begin test inputs
    tb->m_core->i_A = input_A_cpx;

    // Cleanup before exiting
    delete tb;
    exit(EXIT_SUCCESS);
}
