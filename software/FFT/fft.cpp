#include <iostream>
#include <fstream>
#include <math.h>
#include <complex>
#include <chrono>
#include <string>

#include "twiddle.h"

void radix2_shuffle(dcomp** input_vector, const int sig_length, const int num_steps);
void fft(dcomp** input_vector, const int sig_length, const int num_steps);
void write_output(dcomp* fft_output, const int sig_length, std::ofstream &outputFile);
void print_vector(dcomp* test_list, int length);

int main(int argc, char** argv) {

    if (argc != 2) {
        std::cout << "Error: Invalid command line arguments" << std::endl
                  << "Usage: fft [size]" << std::endl;
        return 1;
    }

	// The length of a signal determines how many 'steps' are
	// necessary in the FFT implementation
	const int sig_length = atoi(argv[1]);
	const int num_steps = log2(sig_length);

	dcomp* test_list = new dcomp[sig_length]; 
    std::ofstream outputFile, inputFile;
    std::string fileName;

    for (int i = 0; i < sig_length; i++) {
			test_list[i] = sin(i);
    }

    // Open file to write FFT input to
    fileName = "FFT_input";
    inputFile.open(fileName, std::ios::out | std::ios::binary);
    write_output(test_list, sig_length, inputFile);
    outputFile.close();

    // Open file to write FFT output to
    fileName = "FFT_output";
    outputFile.open(fileName, std::ios::out | std::ios::binary);

    // Start Timer
    auto fft_start = std::chrono::high_resolution_clock::now();

    // Shuffle the input vector to prepare for FFT execution
    radix2_shuffle(&test_list, sig_length, num_steps);
    // Execute the Fast Fourier Transform Algorithm to calculate the frequency spectrum of the input vector
    fft(&test_list, sig_length, num_steps);

    // Finish Timer
    auto fft_stop = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(fft_stop - fft_start);
        
    // Write the calculated FFT output to a file
    write_output(test_list, sig_length, outputFile);
    outputFile.close();
	
    std::cout << "Signal Length: " << sig_length << "  Execution Time: " << duration.count() << " microseconds" << std::endl;

	delete [] test_list;

	return 0;
}

dcomp twiddle(double power, double base) {

	return exp(-2.0 * j * M_PI * power / base);
}

void radix2_shuffle(dcomp** input_vector, const int sig_length, const int num_steps) {

	dcomp* current_layer = *input_vector;
	dcomp* next_layer = new dcomp[sig_length];

	// Loop through each divide and conquer step of the FFT algorithm
	for (int layer = 0; layer < num_steps - 1; layer++) {
		
		// These three parameters will help determine how to loop through the current layer
		int num_partitions = pow(2.0, double(layer));
		int partition_length = sig_length / num_partitions;
		int shuffle_midpoint = partition_length / 2;

		// Each step in the layer involves dividing all currently existing partitions in half.
		// We then treat each partition as an individual array to split it into two new arrays
		// and shift all values corresponding to the FFT symmetry
		for (int partition = 0; partition < num_partitions; partition++) {

			// Each partition is the same in length so looping through each one will be 
			// the same.  To adjust for differences in position use the partition number
			// and partition length to calculate the displaced i
			for (int i = 0; i < shuffle_midpoint; i++) {

				int displaced_i = i + partition * partition_length;

				next_layer[displaced_i] = current_layer[2*i + partition * partition_length];
				next_layer[displaced_i + shuffle_midpoint] = current_layer[2*i + 1 + partition * partition_length];
			}
		}

		// Assign the current iteration of the shuffle to the input
		dcomp* tmp_ptr = current_layer;
		current_layer = next_layer;
		next_layer = tmp_ptr;
	}

	*input_vector = current_layer; 

	delete [] next_layer;
}


void fft(dcomp** input_vector, const int sig_length, const int num_steps) {

	dcomp* current_layer = *input_vector;
	dcomp* sum_vector = new dcomp[sig_length];
    int twiddle_table_offset = 0;

	// Loop through each divide and conquer step of the FFT algorithm
	for (int layer = 0; layer < num_steps; layer++) {
		
		// These four parameters will help determine how to loop through the current layer
		int layer_order = num_steps - 1 - layer;
		int num_partitions = pow(2.0, double(layer_order));     // Determine how many (layer+1)-sized DFTs are in the current layer
		int partition_length = sig_length / num_partitions;     // Determine how many inputs will be going into each partition
		int partition_midpoint = partition_length / 2;          // The midpoint axis which the butterfly sums are being performed over


		for (int partition = 0; partition < num_partitions; partition++) {

			// Each partition is the same in length so looping through each one will be 
			// the same.  To adjust for differences in position use the partition number
			// and partition length to calculate the displaced i
			for (int i = 0; i < partition_midpoint; i++) {

				int displaced_i = i + partition * partition_length; // Used to locate the exact position in the partition for i to read/write from the correct location

				sum_vector[displaced_i] = current_layer[displaced_i] + current_layer[displaced_i + partition_midpoint] * twiddle_table[i + twiddle_table_offset];
				sum_vector[displaced_i + partition_midpoint] = current_layer[displaced_i] + current_layer[displaced_i + partition_midpoint] * -1.0 * twiddle_table[i + twiddle_table_offset];
			}
		}

        // Increase to the next twiddle table location for the next layer
        twiddle_table_offset += pow(2.0, layer);

		// Assign the sum from the current iteration to the current layer
		dcomp* tmp_ptr = current_layer;
		current_layer = sum_vector;
		sum_vector = tmp_ptr;
	}
	
	*input_vector = current_layer;

	delete [] sum_vector;
}

void write_output(dcomp* fft_output, const int sig_length, std::ofstream &outputFile) {

    for (int i = 0; i < sig_length; i++)
        outputFile << fft_output[i] << std::endl;
}

void print_vector(dcomp* test_list, int length) {

	for (int i = 0; i < length; i++) {
		dcomp unrounded_complex = test_list[i];
		printf("|\t(%.3f, %.3f)\t|\n", std::real(unrounded_complex), std::imag(unrounded_complex));
	}
	std::cout << std::endl;
}
