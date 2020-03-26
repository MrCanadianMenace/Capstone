#include <iostream>
#include <stdio.h>
#include <cstring>

#include "fixed_point.h"

Fixed_Complex::Fixed_Complex() {
	
	Fixed_Complex(-1, -1);
}

Fixed_Complex::Fixed_Complex(double real, double imag) {
	
    this->real = fixpoint_37{real};
    this->imag = fixpoint_37{imag};
}

long long int Fixed_Complex::real_input() {
    
    return to_rep(real);
}

long long int Fixed_Complex::imag_input() {
    
    return to_rep(imag);
}

void fixed_to_hex(char (&hex_string)[11], long long int fixed_int) {

	int string_start = 0;
	char padding = '0';
	if (fixed_int < 0) {
		padding = 'F';
		string_start = 1;
		hex_string[0] = '1';
	}
	
	char fixed_hex_string[11] = {0};
	sprintf(fixed_hex_string, "%X", fixed_int);
	int hex_len = strlen(fixed_hex_string);

	//std::cout << std::endl << "Hex String: " << fixed_hex_string << std::endl
	//		<< "First Char of Imaginary Hex: " << fixed_hex_string[0] << std::endl
	//		<< "Imaginary Hex String Length: " << strlen(fixed_hex_string) << std::endl;

	int padding_offset = 10-hex_len;
	for (int i = string_start; i < 10; i++) {
		if (10 - i > hex_len)
			hex_string[i] = padding;
		else {
			hex_string[i] = fixed_hex_string[i-padding_offset];
			//std::cout << "HEX: " << fixed_hex_string[i-padding_offset] << " ";
		}

		//std::cout << "i=" << i<< " ImagHEX: " << hex_string << std::endl;
	}
}
