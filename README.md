# Function Generator & Signal Analysis

A MATLAB-based application for piecewise signal generation, real-time signal transformations, and Fourier analysis.

## Features

* **Fourier Analysis & Visualization:** Calculates total energy, 95% bandwidth, Fourier transforms, magnitude/phase spectra, and Fourier series signal reconstruction.
* **Piecewise Signal Generation:** Interactive configuration of custom signal segments across user-defined breakpoints using baseline mathematical functions:
  * DC, Ramp, Polynomial, Exponential, Sinusoidal, Gaussian pulse, and Sawtooth wave.
* **Signal Operations & Processing:** Apply dynamic modifications to generated signals:
  * Amplitude scaling, time shifting, time reversal, expansion, compression.
  * AWGN noise addition with configurable SNR.
  * Moving average signal smoothing.
* **Automated Batch Generation:** Programmatically generates and plots randomized multi-segment signals.

## Requirements & Running

* MATLAB (R2018b or newer recommended)
* Run the script directly in MATLAB:

```matlab
main.m
