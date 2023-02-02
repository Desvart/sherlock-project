% ******************************************************************
% File to extract features from the sounds
% ******************************************************************

function [feat] = features(x,fs);


%--------------------------------------------------------------------
% Global Initializations
%--------------------------------------------------------------------

% Make x a line vector
if (size(x,2) == 1), x = x.'; end;


% ******************************************************************
% 1. Overlapped DFTs for Frequency-domain transformation of the signal
% ******************************************************************


%--------------------------------------------------------------------
%             Configuration of the transform
%--------------------------------------------------------------------

% Select transform properties
%L = 1024; % Size of the window (time-domain blocksize)
%R = 7/8 * L; % Shift from one block to another (or decimation factor)
%N = L; % Number of DFT points

% Select transform properties
L = 4096; % Size of the window (time-domain blocksize)
R = 4/8 * L; % Shift from one block to another (or decimation factor)
N = L; % Number of DFT points

% Calculate other parameters
OS = N/R; % Oversampling
OVL = L-R; % Overlap

%Select windows
W = sqrt(hann(L,'periodic')); % Square-root of Hanning window
% W = hann(L,'periodic'); % Hanning window
% W = boxcar(L); % Rectangular window
% Window with hann-shaped sides on overlapped parts (R>L/2)
%W = hann_side(L, OVL); 

% Power threshold (in dB) under which a signal block is discarded 
Pth = 25;


%--------------------------------------------------------------------
%  Blocking, Windowing and Time-to-frequency transform 
%--------------------------------------------------------------------

% Build time-domain matrix (1 block per column) 
[xblocks, nblocks] = build_blocks(x, L, OVL);

% Discard blocks with unsufficient power
Pblocks = 10 * log10(sum(xblocks.^2)/L); % Block power
xblocks = xblocks(:,find(Pblocks > Pth)); % New time-domain matrix
nblocks = size(xblocks,2); % Update number of blocks

% Perform windowing of each block
wxblocks = xblocks .* repmat(W, 1, nblocks); 

% Calculate Frequency spectrum for every block, using the FFT algorithm
X = fft(wxblocks)/N; % DFT spectrum (complex)

% Calculate Power Spectrum
PXb = (real(X)).^2 + (imag(X)).^2; % Bilateral Power spectrum
PXu = [PXb(1,:); 2*PXb(2:N/2,:); PXb(N/2+1,:)]; % Unilateral Power Spectrum


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




