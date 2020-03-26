#include <iostream>
#include <stdio.h>
#include <cstring>

#include "fixed_point.h"


Fixed_Complex::Fixed_Complex(fixpoint_37 real, fixpoint_37 imag) {

    this->real = real;
    this->imag = imag;
	
	fixed_real_to_hex();
	fixed_imag_to_hex();
}

Fixed_Complex::Fixed_Complex() {
	
	Fixed_Complex(fixpoint_37{-1}, fixpoint_37{-1});
}

long long int Fixed_Complex::real_input() {
    
    return to_rep(real);
}

long long int Fixed_Complex::imag_input() {
    
    return to_rep(imag);
}

void Fixed_Complex::fixed_real_to_hex() {

	char padding = '0';
	if (this->real < 1)
		padding = 'F';
	
	char hex_string[10];
	sprintf(hex_string, "%X", to_rep(this->real));

	for (int i = 0; i < 10; i++) {
		if (hex_string[i] == '\0')
			real_hex[i] = padding;
		else
			real_hex[i] = hex_string[i];
	}
}

void Fixed_Complex::fixed_imag_to_hex() {


	char padding = '0';
	if (this->imag < 1)
		padding = 'F';
	
	char hex_string[10];
	sprintf(hex_string, "%X", to_rep(this->imag));
	int hex_len = strlen(hex_string);

	std::cout << std::endl << "Imaginary Placeholder: " << imag_hex << std::endl
			<< "First Char of Imaginary Hex: " << hex_string[0] << std::endl
			<< "Imaginary Hex String Length: " << strlen(hex_string) << std::endl;

	for (int i = 0; i < 9; i++) {
		if (9 - i > hex_len)
			imag_hex[i] = padding;
		else
			imag_hex[i] = hex_string[hex_len-i];
	}
}
