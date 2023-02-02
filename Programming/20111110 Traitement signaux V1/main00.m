% This script constructs different representations of watch signals. The 
% goal is to provide an initial overview of the signals to the industrial 
% partners so they can realize the difficulties and can put images on the 
% adressed issue.

% Sherlock Holmes - 2011.11.22
% Pitch Corp.


%%% Init script
close all;
clear all;
clc;
if exist('./Lib', 'dir'), addpath(genpath('Lib')); end


%%% Load signal
nSignal = 3;
dataPath = 'Data/';
rootName = 'ETA2801-2_1_';
load([dataPath, rootName, num2str(1), '.mat'], 'fs');
signalDuration = 1; %s
signals = zeros(nSignal, fs * signalDuration);
for iSignal = 1 : nSignal,
    matObj  = matfile([dataPath, rootName, num2str(iSignal), '.mat']);
    signals(iSignal, :)  = matObj.signal(1, 1:fs);
end


for iSignal = 1 : nSignal,
%%% Time domain analysis
% ~ Energy representation
% - Macro-pulse detection
% - Empyrical Mode Decomposition (EMD)
% - Macro-pulse recognition
% - Micro-pulse detection
    signal = signals(iSignal, :);
    time_domain_analysis;
    time_domain_analysis_disp;
    time_domain_analysis_plot;



%%% Spectral domain analysis
% - Short Time Fourier Transform
% - Envelopp and fine structure separation (cepstral analysis)
% - Hilbert transform
% - Enhanced Morlet Analysis
%     spectral_domain_analysis;
%     spectral_domain_analysis_disp;
%     spectral_domain_analysis_plot;
end

%%% Cross signals analysis
% - xcorr
% cross_signal_analysis.m
% cross_signal_analysis_plot.m


%%% Close script
if exist('./Lib', 'dir'), rmpath(genpath('Lib')); end