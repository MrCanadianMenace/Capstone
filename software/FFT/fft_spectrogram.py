import pyaudio
import struct
import numpy as np
import matplotlib.pyplot as plt
import time
from scipy.fftpack import fft

CHUNK = 1024 * 2                #audio samples per frame
FORMAT = pyaudio.paInt16        #16 bit integer, bytes per sample
CHANNELS = 1                    #audio channels, mono sound
RATE = 44100                    #samples per second 44.1 KHz

# PyAudio class instance
p = pyaudio.PyAudio()

# define audio stream parameters
audio_input = p.open(
    format = FORMAT,
    channels = CHANNELS,
    rate=RATE,
    input=True,
    output=True,
    frames_per_buffer=CHUNK
)

# multiple figure setup
fig, (fig1, fig2) = plt.subplots(2)
# create array of values that go from 0 to twice the chunk size; start,stop,step
x = np.arange(0, 2*CHUNK, 2)
# create array of fft values that go from 0 to RATE; start,stop,divide
fft_val = np.linspace(0, RATE, CHUNK)

# create line for mic values that is x long
line, = fig1.plot(x)
# create line for fft values that is fft_val long and holds random y values that are chunk in length
fft_line, = fig2.semilogx(fft_val, np.random.rand(CHUNK))

# set fig1 x and y limits
fig1.set_xlim(0, CHUNK)
# y limits of 2^16/2
fig1.set_ylim(-32768, 32768)
# set fig2 x limits
fig2.set_xlim(20, RATE / 2)

fig.show()

while True:
    # read microphone values in binary
    amplitude = audio_input.read(CHUNK)
    # covert amplitude values to integers, 2 bytes signed integer is coded with 'h' value
    amp_int = np.frombuffer(amplitude, dtype = 'h')
    # send amplitude values to fft function
    fft_data = fft(amp_int)

    # FFT READ AND WRITE CODES WILL GO HERE

    # restructure audio inputs for better viewing
    #data_array = np.array(data_int,dtype= 'h')
    #data_int = struct.unpack(str(CHUNK) + 'h', data)
    #data_np = np.array(data_int, dtype='b')[::2] + 128

    # set y values
    line.set_ydata(amp_int)
    fft_line.set_ydata(np.abs(fft_data[0:CHUNK]) * 2 / (256 * CHUNK))

    # draw
    fig.canvas.draw()
    fig.canvas.flush_events()


