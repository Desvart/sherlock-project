close all;
clear all;
clc;

% fs = 200e3;
% t= 0:1/fs:1-1/fs;
% signal = sin(1*pi*t*10e3);

%%% Chargement du signal
matObj  = matfile('P01_M01_E00_N01_T1800_V1.mat');
fs      = matObj.fs;
signal  = matObj.signalPzt(1, 1:fs/2);
timeAx  = axis_(signal, fs);


%%% Normalisation du signal
signal = signal ./ max(signal);


%%% Input analyse spectrale
N = 256;
shift = 1/N;
win = sqrt(hann(N, 'periodic'))';


%%% Analyse spectrale

[spectrumUM, spectrumUP] = stdftA_(signal, win, shift, fs);
    
    

% Input reconstruction
% spectrumU = spectrumUM;
phase    = spectrumUP;
win = sqrt(hann(N, 'periodic'))';
shift;

%%% Reconstruction spectrale

signal2 = stdftI_(spectrumUM, spectrumUP, win, shift);


%%% Compute SNR and plot original signal and reconstruction one.
snr = db(mean(signal)/(mean(signal-signal2))) %320 dB
plot(signal); hold on; plot(signal2, '--r');