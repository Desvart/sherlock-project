%%% Main 02 : plot signal and post-process

close all; clear all; clc;
if exist('./Lib', 'dir'), addpath(genpath('Lib')); end

load('Data/signal1', 'fs');
[b,a] = butter(8, 500/(fs/2), 'high');
h = zeros(1, 5);


for iFile = 1 : 5,
    load(['Data/signal', num2str(iFile)]);
    
    signal = signal(1:fs);
    signalFiltered = filtfilt(b, a, signal);
    
    
    [dft, dftFAxis] = dft_(signal, fs);
    [dftFiltered, dftFAxis] = dft_(signalFiltered, fs);
    
    
    
    win = sqrt(hann(512, 'periodic'));
    shift = 1/4;
    [stdft, tAxis, fAxis] = stdft_(signal, win, shift, fs);
    [stdftF, tAxis, fAxis] = stdft_(signalFiltered, win, shift, fs);
    
    
    
    h(1) = figure(1);
    
    subplot(2, 5, iFile);
    plot((0:length(signal)-1)/fs, signal); axis tight;
    title(['Signal ', num2str(iFile)]);
    xlabel('Time [ms]');
    ylabel('Amplitude [-]');
    
    subplot(2, 5, 5+iFile);
    plot((0:length(signal)-1)/fs, signalFiltered); axis tight;
    title(['Signal ', num2str(iFile), 'filtered']);
    xlabel('Time [ms]');
    ylabel('Amplitude [-]');
    
    
    h(iFile+1) = figure(iFile+1);
    
    subplot(1, 8, 2:4);
    pcolor(tAxis*1e3, fAxis/1e3, db(stdft/max(max(stdft)))); shading flat;
    title(['Signal ', num2str(iFile), ' - Spectrogram power (dB) [N=', num2str(length(win)), ' S=', num2str(shift), ']']);
    xlabel('Time [ms]');
    ylabel('Frequency [kHz]');
    
    subplot(1, 8, 5:7);
    pcolor(tAxis*1e3, fAxis/1e3, db(stdftF/max(max(stdftF)))); shading flat;
    title(['Signal ', num2str(iFile), ' filtered - Spectrogram power (dB) [N=', num2str(length(win)), ' S=', num2str(shift), ']']);
    xlabel('Time [ms]');
    ylabel('Frequency [kHz]');
    
    subplot(1, 8, 1);
    plot(db(dft/max(dft)), dftFAxis/1e3); axis tight; set(gca, 'XDir', 'reverse');
    title(['Signal ', num2str(iFile), ' - Spectrum power']);
    ylabel('Frequency [kHz]');
    xlabel('Magnitude [dB]');
    
    
    subplot(1, 8, 8);
    plot(db(dftFiltered/max(dftFiltered)), dftFAxis/1e3); axis tight; set(gca, 'XDir', 'reverse');
    title(['Signal ', num2str(iFile), ' - Spectrum power']);
    ylabel('Frequency [kHz]');
    xlabel('Magnitude [dB]');
    
end

for iFig = 1:5+1,
    set(h(iFig), 'color', 'white');
end

if exist('./Lib', 'dir'), rmpath(genpath('Lib')); end
