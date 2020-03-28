#pragma once

#include <complex>

typedef std::complex<double> dcomp;
const dcomp j(0.0, 1.0);

static const dcomp twiddle_table[] {
    // Base 2
    dcomp(1.0,0.0), 

    // Base 4
    dcomp(1.0,0.0), dcomp(0.0,-1.0), 

    // Base 8
    dcomp(1.000000,0.000000), dcomp(0.707107,-0.707107), dcomp(0.000000,-1.000000), dcomp(-0.707107,-0.707107), 

    // Base 16
    dcomp(1.000000,0.000000), dcomp(0.923880,-0.382683), dcomp(0.707107,-0.707107), dcomp(0.382683,-0.923880), 
        dcomp(0.000000,-1.000000), dcomp(-0.382683,-0.923880), dcomp(-0.707107,-0.707107), dcomp(-0.923880,-0.382683), 

    // Base 32
    dcomp(1.000000,0.000000), dcomp(0.980785,-0.195090), dcomp(0.923880,-0.382683), dcomp(0.831470,-0.555570), 
        dcomp(0.707107,-0.707107), dcomp(0.555570,-0.831470), dcomp(0.382683,-0.923880), dcomp(0.195090,-0.980785), 
        dcomp(0.000000,-1.000000), dcomp(-0.195090,-0.980785), dcomp(-0.382683,-0.923880), dcomp(-0.555570,-0.831470), 
        dcomp(-0.707107,-0.707107), dcomp(-0.831470,-0.555570), dcomp(-0.923880,-0.382683), dcomp(-0.980785,-0.195090), 

    // Base 64
    dcomp(1.000000,0.000000), dcomp(0.995185,-0.098017), dcomp(0.980785,-0.195090), dcomp(0.956940,-0.290285), 
        dcomp(0.923880,-0.382683), dcomp(0.881921,-0.471397), dcomp(0.831470,-0.555570), dcomp(0.773010,-0.634393), 
        dcomp(0.707107,-0.707107), dcomp(0.634393,-0.773010), dcomp(0.555570,-0.831470), dcomp(0.471397,-0.881921), 
        dcomp(0.382683,-0.923880), dcomp(0.290285,-0.956940), dcomp(0.195090,-0.980785), dcomp(0.098017,-0.995185), 
        dcomp(0.000000,-1.000000), dcomp(-0.098017,-0.995185), dcomp(-0.195090,-0.980785), dcomp(-0.290285,-0.956940), 
        dcomp(-0.382683,-0.923880), dcomp(-0.471397,-0.881921), dcomp(-0.555570,-0.831470), dcomp(-0.634393,-0.773010), 
        dcomp(-0.707107,-0.707107), dcomp(-0.773010,-0.634393), dcomp(-0.831470,-0.555570), dcomp(-0.881921,-0.471397), 
        dcomp(-0.923880,-0.382683), dcomp(-0.956940,-0.290285), dcomp(-0.980785,-0.195090), dcomp(-0.995185,-0.098017), 

    // Base 128
    dcomp(1.000000,0.000000), dcomp(0.998795,-0.049068), dcomp(0.995185,-0.098017), dcomp(0.989177,-0.146730), 
        dcomp(0.980785,-0.195090), dcomp(0.970031,-0.242980), dcomp(0.956940,-0.290285), dcomp(0.941544,-0.336890), 
        dcomp(0.923880,-0.382683), dcomp(0.903989,-0.427555), dcomp(0.881921,-0.471397), dcomp(0.857729,-0.514103), 
        dcomp(0.831470,-0.555570), dcomp(0.803208,-0.595699), dcomp(0.773010,-0.634393), dcomp(0.740951,-0.671559), 
        dcomp(0.707107,-0.707107), dcomp(0.671559,-0.740951), dcomp(0.634393,-0.773010), dcomp(0.595699,-0.803208), 
        dcomp(0.555570,-0.831470), dcomp(0.514103,-0.857729), dcomp(0.471397,-0.881921), dcomp(0.427555,-0.903989), 
        dcomp(0.382683,-0.923880), dcomp(0.336890,-0.941544), dcomp(0.290285,-0.956940), dcomp(0.242980,-0.970031), 
        dcomp(0.195090,-0.980785), dcomp(0.146730,-0.989177), dcomp(0.098017,-0.995185), dcomp(0.049068,-0.998795), 
        dcomp(0.000000,-1.000000), dcomp(-0.049068,-0.998795), dcomp(-0.098017,-0.995185), dcomp(-0.146730,-0.989177), 
        dcomp(-0.195090,-0.980785), dcomp(-0.242980,-0.970031), dcomp(-0.290285,-0.956940), dcomp(-0.336890,-0.941544), 
        dcomp(-0.382683,-0.923880), dcomp(-0.427555,-0.903989), dcomp(-0.471397,-0.881921), dcomp(-0.514103,-0.857729), 
        dcomp(-0.555570,-0.831470), dcomp(-0.595699,-0.803208), dcomp(-0.634393,-0.773010), dcomp(-0.671559,-0.740951), 
        dcomp(-0.707107,-0.707107), dcomp(-0.740951,-0.671559), dcomp(-0.773010,-0.634393), dcomp(-0.803208,-0.595699), 
        dcomp(-0.831470,-0.555570), dcomp(-0.857729,-0.514103), dcomp(-0.881921,-0.471397), dcomp(-0.903989,-0.427555), 
        dcomp(-0.923880,-0.382683), dcomp(-0.941544,-0.336890), dcomp(-0.956940,-0.290285), dcomp(-0.970031,-0.242980), 
        dcomp(-0.980785,-0.195090), dcomp(-0.989177,-0.146730), dcomp(-0.995185,-0.098017), dcomp(-0.998795,-0.049068), 
};
