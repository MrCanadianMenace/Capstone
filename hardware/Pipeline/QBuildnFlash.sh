#!/usr/bin/sh

# Move into directory with Quartus files
pushd QuartusProject

# Quartus compilation steps broken into individual commands
quartus_map --read_settings_files=on --write_settings_files=off FFT_Pipeline -c FFT_Pipeline && \
quartus_fit --read_settings_files=off --write_settings_files=off FFT_Pipeline -c FFT_Pipeline && \
quartus_asm --read_settings_files=off --write_settings_files=off FFT_Pipeline -c FFT_Pipeline && \
quartus_sta FFT_Pipeline -c FFT_Pipeline && \

# Program connected DE2-115 board with the compilation output
quartus_pgm -c "USB-Blaster [1-4]" -m jtag -o 'P;FFT_Pipeline.sof'

# Return to script directory
popd
