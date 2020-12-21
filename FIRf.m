function Hd = FIRf
%FIRF Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.5 and DSP System Toolbox 9.7.
% Generated on: 18-Dec-2020 18:25:13

% FIR Window Lowpass filter designed using the FIR1 function.

% All frequency values are in Hz.
Fs = 30000;  % Sampling Frequency

N    = 10;       % Order
Fc   = 2000;     % Cutoff Frequency
flag = 'scale';  % Sampling Flag

% Create the window vector for the design algorithm.
win = hamming(N+1);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Fc/(Fs/2), 'low', win, flag);
Hd = dfilt.dffir(b);

% [EOF]