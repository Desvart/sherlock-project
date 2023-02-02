% ******************************************************************
% File to extract features from the sounds
% ******************************************************************

function [feat] = WOLA_features(x,fs);

%--------------------------------------------------------------------
% Global Initializations
%--------------------------------------------------------------------

% Constants (don't change!)
WOLA_ODD    = 1;
WOLA_EVEN   = 0;


%--------------------------------------------------------------------
%             Configuration of the filterbank
%--------------------------------------------------------------------

% Filterbank
R = 512; % Shift from one block to another (or decimation factor)
N = 2048; % Number of points in frequency
La = 4096; % Size of the window (time-domain blocksize)
stacking = WOLA_EVEN; % Band stacking
Wa = sinc((-La/2:La/2-1)/N)'.* brennan(La,0); % Brenann filter

% FFT with sqrt(hann) windows
% R = 2048; % Shift from one block to another (or decimation factor)
% N = 4096; % Number of points in frequency
% La = 4096; % Size of the window (time-domain blocksize)
% stacking = WOLA_EVEN; % Band stacking
% Wa = sqrt(hann(La,'periodic')); % Square-root of Hanning window

% Allocate wola object
wid = wolainit(La, La, R, N, stacking, 'unrestricted');
% Set analysis window
wolasetanawin(wid, Wa);


%----------------------------------------------------------
%                     WOLA Processing
%----------------------------------------------------------

% Filterbank Analysis
X = wolaanalyze2(wid, x);
% Re-organize bands correctly for EVEN stacking
if (stacking == WOLA_EVEN),
    X = [real(X(1,:)); X(2:N/2,:); imag(X(1,:))]/N;
else 
    X = X/N;  
end;

% Delete wola object
wolaclose(wid);

% Calculate Power Spectrum
PXu = (real(X)).^2 + (imag(X)).^2; % Unilateral Power spectrum

% Calculate total power in every block
if (stacking == WOLA_EVEN),
    Pblocks =  PXu(1,:) + sum(2*PXu(2:N/2,:),1) + PXu(N/2+1,:);
else
    Pblocks = sum(2*PXu,1);
end;

% Discard blocks with unsufficient power
Pth = 25; % Power threshold (in dB) under which a signal block is discarded
Pblocks = 10 * log10(Pblocks); % Total power (dB) in every block
PXu = PXu(:,find(Pblocks > Pth)); % New power spectrum matrix


%--------------------------------------------------------------------
%  Regrouping of bands (uniform) into channels (non-uniform)
%--------------------------------------------------------------------

% Regroup bands into channels: several options
% A. Specify channel limits according to the 25 critical bands (Bark scale)
channels = [0 100 200 300 400 510 630 770 920 1080 1270 1480 1720 ...
    2000 2320 2700 3150 3700 4400 5300 6400 7700 9500 12000 15500 21000];
% B. Specify limits for 32 uniform bands up to 16000 hz
%channels = [0:500:16000]; 

% Frequency axis over [0 fs/2]
f = linspace(0, fs/2, N/2+1);

% Number of channels
N_channels = length(channels) - 1;

% Loop for every channel
for i = 1:N_channels,
    % Find the indexes of the frequency bins in every channel
    bin_index{i} = find((f >= channels(i)) & (f < channels(i+1)));
    % Number of frequency bins in every channel  
    N_bins(i) = length(bin_index{i});
end;


%--------------------------------------------------------------------
%  Calculate Power in every channel
%--------------------------------------------------------------------

% Power in every channel
for i = 1:N_channels,
   Pch(i,:) = sum(PXu(bin_index{i},:)) / N_bins(i);
end;

% Express power spectrum in dB and normalize
P = 10*log10(Pch); % Power Spectrum in dB
Pmax = max(max(P)); % Maximum Power
P = P - Pmax; % Normalized Power
feat = P;



