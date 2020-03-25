#include <stdlib.h>
#include <iostream>

#include "Vbutterfly_sum_helper.h"
#include "verilated.h"

#include "testbench.hpp"
#include "fixed_point.h"
 
int main(int argc, char **argv) {
 
    // Initialize Verliators variables
    Verilated::commandArgs(argc, argv);
    // Create an instance of our module under test
    TESTBENCH<Vbutterfly_sum_helper> *tb = new TESTBENCH<Vbutterfly_sum_helper>();
    // Open trace file for waveform viewing
    tb->opentrace("trace.vcd");

    /* First Test Case */
    Complex inputA = Complex(fixpoint_37{1}, fixpoint_37{2});
    Complex inputB = Complex(fixpoint_37{3}, fixpoint_37{4});
    Complex inTwiddle = Complex(fixpoint_37{1}, fixpoint_37{0});

    Complex outA = Complex(fixpoint_37{0}, fixpoint_37{0});
    Complex outB = Complex(fixpoint_37{0}, fixpoint_37{0});

    // Begin test inputs
    tb->m_core->i_A_real = inputA.real_input();
    tb->m_core->i_A_imag = inputA.imag_input();
    tb->m_core->i_B_real = inputB.real_input();
    tb->m_core->i_B_imag = inputB.imag_input();
    tb->m_core->i_twiddle_real = inTwiddle.real_input();
    tb->m_core->i_twiddle_imag = inTwiddle.imag_input();
    tb->tick();

    outA.from_output(tb->m_core->o_A_real, tb->m_core->o_A_imag);
    outB.from_output(tb->m_core->o_B_real, tb->m_core->o_B_imag);

    std::cout << "Input: A= " << inputA.real << " + (" << inputA.imag << "i)"  
                << ", B= " << inputB.real << " + (" << inputB.imag << "i)" << std::endl;
    std::cout << "Output: A=" << outA.real << " + (" << outA.imag << "i) B=" 
            << outB.real << " + (" << outB.imag << "i)" << std::endl << std::endl;

    
    /* Second Test Case */
    inputA = Complex(fixpoint_37{1.25}, fixpoint_37{2.5});
    inputB = Complex(fixpoint_37{3.5}, fixpoint_37{4.25});
    inTwiddle = Complex(fixpoint_37{1}, fixpoint_37{0});

    // Begin test inputs
    tb->m_core->i_A_real = inputA.real_input();
    tb->m_core->i_A_imag = inputA.imag_input();
    tb->m_core->i_B_real = inputB.real_input();
    tb->m_core->i_B_imag = inputB.imag_input();
    tb->m_core->i_twiddle_real = inTwiddle.real_input();
    tb->m_core->i_twiddle_imag = inTwiddle.imag_input();
    tb->tick();

    outA.from_output(tb->m_core->o_A_real, tb->m_core->o_A_imag);
    outB.from_output(tb->m_core->o_B_real, tb->m_core->o_B_imag);

    std::cout << "Input: A= " << inputA.real << "+ (" << inputA.imag << "i)"  
                << ", B= " << inputB.real << "+ (" << inputB.imag << "i)" << std::endl;
    std::cout << "Output: A=" << outA.real << "+(" << outA.imag << "i) B=" 
            << outB.real << "+(" << outB.imag << "i)" << std::endl << std::endl;

    /* Second Test Case */
    inputA = Complex(fixpoint_37{-1.25}, fixpoint_37{2.5});
    inputB = Complex(fixpoint_37{3.5}, fixpoint_37{-4.25});
    inTwiddle = Complex(fixpoint_37{1}, fixpoint_37{0});

    // Begin test inputs
    tb->m_core->i_A_real = inputA.real_input();
    tb->m_core->i_A_imag = inputA.imag_input();
    tb->m_core->i_B_real = inputB.real_input();
    tb->m_core->i_B_imag = inputB.imag_input();
    tb->m_core->i_twiddle_real = inTwiddle.real_input();
    tb->m_core->i_twiddle_imag = inTwiddle.imag_input();
    tb->tick();

    outA.from_output(tb->m_core->o_A_real, tb->m_core->o_A_imag);
    outB.from_output(tb->m_core->o_B_real, tb->m_core->o_B_imag);

    std::cout << "Input: A= " << inputA.real << " + (" << inputA.imag << "i)"  
                << ", B= " << inputB.real << " + (" << inputB.imag << "i)" << std::endl;
    std::cout << "Output: A=" << outA.real << " + (" << outA.imag << "i) B=" 
            << outB.real << " + (" << outB.imag << "i)" << std::endl << std::endl;

    // Cleanup before exiting
    tb->closetrace();
    delete tb;
    exit(EXIT_SUCCESS);
}
