#include <stdlib.h>                                                                                                           
#include "Vbutterfly_sum.h"
#include "verilated.h"
 
int main(int argc, char **argv) {
 
    // Initialize Verliators variables
    Verilated::commandArgs(argc, argv);
    // Create an instance of our module under test
    Vbutterfly_sum *test_unit = new Vbutterfly_sum;

    // Create initial values to pass through the "mock FFT"
    
    // Begin test inputs
    //test_unit->i_A = 
}
