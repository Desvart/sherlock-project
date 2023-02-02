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

% Compute padding size
sStartPadding   = N;
startPadding    = zeros(1, sStartPadding);
% startPadding = ones(1, sStartPadding) * mean(signal(1:sStartPadding));
sFrame          = N*shift;
sSignal         = length(signal);
nBlock          = ceil((sSignal+N)/sFrame);
sStopPadding    = N - ((sSignal+N)-(nBlock-1)*sFrame);
stopPadding     = zeros(1, sStopPadding);
% stopPadding     = ones(1, sStopPadding) * mean(signal(end-sStopPadding:end));
signalPadded    = [startPadding, signal, stopPadding];

% Signal matrixing (vectorized implementation)
blockPos        = 1:sFrame:sSignal+N;
bandPos         = 1:N;
signalMatrix    = signalPadded(ones(N, 1)*(blockPos-1) + bandPos'*ones(1, nBlock));

% Windowing signal
winMatrix       = win' * ones(1, nBlock);
signalWindowed  = signalMatrix .* winMatrix;

% Apply DFT on signal
spectrumU        = fft(signalWindowed)/N;
      
% Extract unilateral matrix
nBand  = N/2 + 1;      % number of frequential bands
spectrumU  = [spectrumU(1,:) ; 2*spectrumU(2:nBand-1,:) ; spectrumU(nBand,:)];
spectrumUM = abs(spectrumU);        % Unilateral Magnitude Time-Frequency Matrix
spectrumUP = angle(spectrumU);      % Unilateral Phase Time-Frequency Matrix
    
    
% pcolor(db(spectrumUM)); shading flat;
    
    

% Input reconstruction
% spectrumU = spectrumUM;
phase    = spectrumUP;
win = sqrt(hann(N, 'periodic'))';
shift;

%%% Reconstruction spectrale

% Restauration de la phase
[nBand, nBlock] = size(spectrumUM);
N = (nBand-1)*2;
sFrame = N * shift;
spectrumU2 = spectrumUM .* exp(1j * phase);

% Rebuild the entire time-frenquency matrix
spectrumU = [spectrumU(1,:) ; 1/2*spectrumU(2:nBand-1,:) ; spectrumU(nBand,:)];
bilateralMissingPart = conj(spectrumU(nBand-1 : -1 : 2, :)); 
spectrum = [spectrumU ; bilateralMissingPart];   

% Inverse transformation
signalMatrix = real(ifft(spectrum * N));    % Inverse DFT Transformation and remove residual imaginary components
winMatrix       = win' * ones(1, nBlock);
signalMatrix = signalMatrix .* winMatrix;       % Windowing of each block

% Overlap-add operation
signalPadded = zeros(1, N + (nBlock-1) * sFrame); % Preallocating
for i = 1 : nBlock,                           % Loop for every block 
   a = 1 + (i-1) * sFrame;                      % Index of first sample
   b = N + (i-1) * sFrame;                  % Index of last sample
   signalPadded(a:b) = signalPadded(a:b) + signalMatrix(:,i).';% Perform overlap-add
end
    
% Rescaling 
signalPadded = signalPadded / ( (1/2)*(N/sFrame) );
    
% Remove added samples 
signal2 = signalPadded(sStartPadding + 1 : end - sStopPadding);


%%% Compute SNR and plot original signal and reconstruction one.
snr = db(mean(signal)/(mean(signal-signal2))) %320 dB
plot(signal); hold on; plot(signal2, '--r');