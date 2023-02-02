% Spectral split demonstration

% This script was produced purely for demonstration purposes. It may 
% therefore contain errors.

% Project   : SH (-)
% Author    : Pitch
% Creation  : 2012.03.25  
% Last edit : 2012.03.25
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------- %

%% Init script

close all; clear all; clc;
plotFlag = true;


%% Load signal

% matObj  = matfile('../../Base_de_donnees/20111100_Witschi_DB1/P02/V1.2/P02_M01_E00_N02_T1800_V1.mat');
% fs      = matObj.fs;
% signal  = matObj.signalPzt(1, 8000:fs/2+8000);

matObj  = matfile('signal.mat');
fs      = matObj.fs;
signal  = matObj.signal;
timeAx  = axis_(signal, fs);

% Signal normalization
signal = signal ./ max(signal);


%% Script core

%%% Compute spectrogram

% Spectrogram parameters
N = 1024;
S = 1/256;
win = sqrt(hann(N, 'periodic'));

% Compute spectrogram
[stdftUM, stdftUP, sStopPadding, tAxis, fAxis] = stdftA_(signal, win, S, fs);
[nBand, nBlock] = size(stdftUM);


%%% Cepstral split to compute envelope and fine structure

cutingIdx = round((N/2)*5/100); %This way of spliting cepstrogram is a bit rude and can be done more softly
[envelope, fineStruct] = cepstral_split(stdftUM, cutingIdx);


%%% Way back to time domain signals
% This reconstruction algorithm is a mathematical trick and not the 
% theoretical way of doing "correctly" the reconstruction, but in most case
% this way of doing it is good enough.

% signalA = stdftI_(envelope, stdftUP, win', S, sStopPadding);
% signalM = stdftI_(fineStruct, stdftUP, win', S, sStopPadding);
% 
% signalA1 = stdftI_(stdftUM./fineStruct, stdftUP, win', S, sStopPadding);
% signalM1 = stdftI_(stdftUM./envelope, stdftUP, win', S, sStopPadding);


%% Plots

if plotFlag,
    
    figure('color', 'white');
    
    % Time domain signal
    subplot(2, 2, 1);
    
    plot(timeAx*1e3, 10*log10(signal.^2));
    axis tight;
    
    xlabel('Time [ms]');
    ylabel('Energy [dB]')
    title('Signal energy');
    
    
    % Spectrogram
    subplot(2, 2, 3);
    
    stdftUMDb = db(stdftUM);
    minThreshold = mean(mean(stdftUMDb(abs(stdftUMDb)~=Inf)));
    stdftUMDb(stdftUMDb < minThreshold) = minThreshold;
    
    pcolor(tAxis*1e3, fAxis/1e3, stdftUMDb);
    shading flat;
    
    xlabel('Time [ms]');
    ylabel('Frequency [kHz]');
    title('Signal spectrogram');
    
    
	% Fine structure spectrogram
    subplot(2, 2, 2);
    
    th = mean(fineStruct(~isnan(fineStruct))); 
    fineStruct(fineStruct <= th*2.5) = 0.1;
    
    pcolor(tAxis*1e3, fAxis/1e3, db(fineStruct)); 
    shading flat;
       
    xlabel('Time [ms]');
    ylabel('Frequency [kHz]');
    title('Signal fine structure spectrogram');
    
    
    % Envelope spectrogram
    subplot(2, 2, 4);
    
    envelopeDb = db(envelope);
    minThreshold = mean(mean(envelopeDb(abs(envelopeDb)~=Inf & ~isnan(envelopeDb))));
    envelopeDb(envelopeDb < minThreshold) = minThreshold;
    
    pcolor(tAxis*1e3, fAxis/1e3, envelopeDb); 
    shading flat;
    
    xlabel('Time [ms]');
    ylabel('Frequency [kHz]');
    title('Signal envelope spectrogram');
end
