close all;
clear all;
clc;
if exist('./Lib', 'dir'), addpath(genpath('Lib')); end
if ~exist('./Lib', 'dir'), mkdir('Output'); end

%%% Load signals
% Merz said that canal 0 contains the acoustic signal and the canal 7 the PZT signal.
% Three signals are available : msg.mat (générateur), omega.mat, russisch.mat

load('Data/omega.mat', 'Data1_AI_0', 'Data1_AI_7', 'Sample_rate', 'Start_time');
fs          = double(Sample_rate);  clear Sample_rate;
signalAco   = double(Data1_AI_0(1:1*fs)');   clear Data1_AI_0;
signalPzt   = double(Data1_AI_7(1:1*fs)');   clear Data1_AI_7;
timeStamp   = double(Start_time);   clear Start_time;


sSignal = length(signalAco);
tAxisSignalAco = 0:1/fs:(sSignal-1)/fs;
tAxisSignalPzt = tAxisSignalAco;


figure('color', 'white');

subplot(211);
plot(tAxisSignalAco, signalAco); axis tight;
xlabel('Time [s]');
ylabel('Amplitude [-]');
title('Acoustic signal');

subplot(212);
plot(tAxisSignalPzt, signalPzt); axis tight;
xlabel('Time [s]');
ylabel('Amplitude [-]');
title('PZT signal');


[dft, fAxis] = dft_(signalPzt, fs);

figure('color', 'white');
plot(fAxis, db(dft));


[stdft, tAxis, fAxis] = stdft_(signalPzt, sqrt(hann(2*2048, 'periodic')), 1/4, 200e3);

% plot(sum(stdft));
m = median(sum(stdft)/size(stdft, 1));

stdft2 = stdft;
stdft2(stdft<m*4) = min(min(stdft));

figure('color', 'white');
pcolor(tAxis, fAxis, db(stdft/max(max(stdft)))); shading flat;
figure('color', 'white');
pcolor(tAxis, fAxis, db(stdft2/max(max(stdft)))); shading flat;
% mesh(tAxis, fAxis, db(stdft/max(max(stdft)))); shading flat;

if exist('./Lib', 'dir'), rmpath(genpath('Lib')); end
