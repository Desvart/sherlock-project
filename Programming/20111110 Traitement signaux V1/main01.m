% Interesting stat to extract:
% X zeros crossing for tic and for tac
% - When tics and tacs detected, plot 3 tics in front of 3 tacs
% - Mean energy for tic and tac
% X Mean level sound
% - EMD?
% - Energy and time duration of each micro-pulse
% - Global Spectrum
% - Spectrum of tocs
% - STFT of tocs
% - bispectrum
% - cepstrum
% - MFCC
% - Enhanced Morlet Transform?

%%% Init script

close all;
clear all;
clc;
if exist('./Lib', 'dir'), addpath(genpath('Lib')); end


%%% Load signal

matObj = matfile('Data/omega1.mat');
% f = fs/20; signal = double(Data1_AI_7(f:f+fs-1))'; save('Data/russisch1.mat', 'signal', 'fs');
matObj = matfile('Data/russisch1.mat');
fs = matObj.fs;
signal = matObj.signal(1, 1:fs);


%%% 

% - Build signal axis
sSignal = length(signal);
tAxis = 0:1/fs:(sSignal-1)/fs;

% - Build signal power
powerWinDuration = 1.25e-3;
sPowerWin = powerWinDuration * fs;

signalEnergyStd = signal.^2;
signalPowerStd = running_mean(signalEnergyStd, sPowerWin);

signalEnergyTko = teager_kaiser_operator(signal);
signalPowerTko = running_mean(signalEnergyTko, sPowerWin);

% - Zeros crossing activity
sZeroCrossingWin = 25;
zeroCrossingWinDuration = sZeroCrossingWin / fs;
zeroCrossing = zeros(4, sSignal);
yf = zeros(4, sSignal);
minDetected = zeros(4,1);
minDetectedIdx = zeros(4,1);
[b,a] = butter(4, (fs/512)/(fs/2), 'low');
for i = 1 : 4,
    zeroCrossing(i,:) = zero_crossing_signal(signal, sZeroCrossingWin*i*2);
    
    yf(i,:) = double(filtfilt(b,a,zeroCrossing(i,:)));
    
    [minDetected(i), minDetectedIdx(i)] = min(zeroCrossing(i,(sZeroCrossingWin*i*2+1):end));
    minDetectedIdx(i) = minDetectedIdx(i) + sZeroCrossingWin*i*2;
    minGlobIdx{i} = zeroCrossing(i, zeroCrossing(i, :) < (minDetected(i)+1e-3));
end

halfSignal = zeros(1, sSignal);
halfSignal(signal >= 0) = signal(signal >= 0);




% - Spectrum domain results

% Spectrum


% Spectrogram

% Scalogram


%%% Compute various caracteristics

% - Mean energy level
meanPowerStdLevel = mean(signalPowerStd);
meanPowerTkoLevel = mean(signalPowerTko);
medianPowerStdLevel = median(signalPowerStd);
medianPowerTkoLevel = median(signalPowerTko);


%%% Plot results
plot04


%%% Display caracteristics
fprintf('Energy levels:\n');
fprintf('- Mean Std \t: %f\n', meanPowerStdLevel);
fprintf('- Mean Tko \t: %f\n', meanPowerTkoLevel);
fprintf('- Median Std \t: %f\n', medianPowerStdLevel);
fprintf('- Median Tko \t: %f\n', medianPowerTkoLevel);


%%% Close script

if exist('./Lib', 'dir'), rmpath(genpath('Lib')); end
