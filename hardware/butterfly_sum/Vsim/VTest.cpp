#include <stdlib.h>
#include <iostream>

#include "Vbutterfly_sum.h"
#include "verilated.h"

#include "testbench.hpp"
#include "fixed_point.h"
 
int main(int argc, char **argv) {
 
    // Initialize Verliators variables
    Verilated::commandArgs(argc, argv);
    // Create an instance of our module under test
    TESTBENCH<Vbutterfly_sum> *tb = new TESTBENCH<Vbutterfly_sum>();
    // Open trace file for waveform viewing
    tb->opentrace("trace.vcd");

    /* First Test Case */
    Complex inputA = Complex(fixpoint_16{1}, fixpoint_16{2});
    Complex inputB = Complex(fixpoint_16{3}, fixpoint_16{4});
    Complex inTwiddle = Complex(fixpoint_16{1}, fixpoint_16{0});

    Complex outA = Complex(fixpoint_16{0}, fixpoint_16{0});
    Complex outB = Complex(fixpoint_16{0}, fixpoint_16{0});

    // Begin test inputs
    tb->m_core->i_A = inputA.to_input();
    tb->m_core->i_B = inputB.to_input();
    tb->m_core->i_twiddle = inTwiddle.to_input();
    tb->tick();

    outA.from_output(tb->m_core->o_A);
    outB.from_output(tb->m_core->o_B);

    std::cout << "Output: A=" << outA.real << "+(" << outA.imag << "i) B=" 
            << outB.real << "+(" << outB.imag << "i)" << std::endl;

    
    /* Second Test Case */
    inputA = Complex(fixpoint_16{1.25}, fixpoint_16{2.5});
    inputB = Complex(fixpoint_16{3.5}, fixpoint_16{4.25});
    inTwiddle = Complex(fixpoint_16{1}, fixpoint_16{0});

    // Begin test inputs
    tb->m_core->i_A = inputA.to_input();
    tb->m_core->i_B = inputB.to_input();
    tb->m_core->i_twiddle = inTwiddle.to_input();
    tb->tick();

    outA.from_output(tb->m_core->o_A);
    outB.from_output(tb->m_core->o_B);

    std::cout << "Output: A=" << outA.real << "+(" << outA.imag << "i) B=" 
            << outB.real << "+(" << outB.imag << "i)" << std::endl;

    /* Second Test Case */
    inputA = Complex(fixpoint_16{-1.25}, fixpoint_16{2.5});
    inputB = Complex(fixpoint_16{3.5}, fixpoint_16{-4.25});
    inTwiddle = Complex(fixpoint_16{1}, fixpoint_16{0});

    // Begin test inputs
    tb->m_core->i_A = inputA.to_input();
    tb->m_core->i_B = inputB.to_input();
    tb->m_core->i_twiddle = inTwiddle.to_input();
    tb->tick();

    outA.from_output(tb->m_core->o_A);
    outB.from_output(tb->m_core->o_B);

    std::cout << "Output: A=" << outA.real << "+(" << outA.imag << "i) B=" 
            << outB.real << "+(" << outB.imag << "i)" << std::endl;

    // Cleanup before exiting
    tb->closetrace();
    delete tb;
    exit(EXIT_SUCCESS);
}
