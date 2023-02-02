% ----------------------------------------------------------------------------------------
% Function : featureExtraction_Spectrogram.m
% 
% Purpose  : This function extracts spectrogram familly features from the input signal. 
%            Various settings can be changed in the 'User settings' part to select the
%            exact feature user want.
%
%
% Inputs :  
%       signal      [vector] signal wich we want to extract the feature
%       
%       fs          [scalar] signal sampling rate
%
% Outputs : 
%       feature     [matrix] Each column is the extracted feature for a signal frame
%
%       nBlocks     [scalar] Number of frames of the feature
% ----------------------------------------------------------------------------------------


function [feature, nbBlock] = featureExtraction_spectrogram(signal, fs)


    % ------------------------------------------------------------------------------------
    % User settings
    % ------------------------------------------------------------------------------------
    
    %%% Short Time Discrete Fourier Transform (STDFT) parameters
    N      = 2048;
    shift  = 1/4;
    
    window = sqrt(hann(N, 'periodic'));
%     window = hannSide(N, shift);
    
    
    %%% Power threshold : all frame with not enough energy are discarded
    powerThreshold = 25; % dB
    
    %%% Channel type
    % 32 uniform bands up to 16000 hz
%     channelFreqLim = 0 : 500 : 16000;     

    % Bark channels
    channelFreqLim = [0, 100, 200, 300, 400, 510, 630, 770, 920, 1080, 1270, 1480, ...
                      1720, 2000, 2320, 2700, 3150, 3700, 4400, 5300, 6400, 7700,  ...
                      9500, 12000, 15500, 21000];
            
    % Custom channels
%     channelFreqLim = 0 : 500 : 1600;

    
    % ------------------------------------------------------------------------------------
    % Compute STDFT (discarding blocks with unsufficient power)
    % ------------------------------------------------------------------------------------

    block  = buildBlock(signal, N, shift);
    
    %%% Discard blocks with unsufficient power
    blockPower      = 10*log10(sum(block.^2)/N);             % Power for each block
    blockReduced    = block(:, blockPower > powerThreshold); % Keep only blocks with sufficient power
    nbBlock         = size(blockReduced, 2);                 % Update number of blocks

    %%% Windowing signal
    blockWindowed = blockReduced .* repmat(window, 1, nbBlock); 

    %%% Apply DFT on signal
    spectrum = fft(blockWindowed)/N;

    %%% Compute the unilateral power spectrum
    powerSpectrumB = (real(spectrum)).^2 + (imag(spectrum)).^2;
    powerSpectrumU = [powerSpectrumB(1,:); 2*powerSpectrumB(2:N/2,:); powerSpectrumB(N/2+1,:)];
    
    
    % ------------------------------------------------------------------------------------
    % Regrouping of bands (uniform) into channels (non-uniform)
    % ------------------------------------------------------------------------------------
    
    %%% Loop for every channel
    nbChannel     = length(channelFreqLim) - 1;
    frequencyAxis = linspace(0, fs/2, N/2+1); % Frequency axis over [0 fs/2]
    channelPower  = zeros(nbChannel, nbBlock); % Preallocation
    for i = 1 : nbChannel,
        channel = powerSpectrumU(frequencyAxis >= channelFreqLim(i) & frequencyAxis <  channelFreqLim(i+1), :);
        channelPower(i, :) = sum(channel) / size(channel, 1);
    end
    
    %%% Express spectrum in dB and normalize
    channelPower = 10*log10(channelPower);      % Power Spectrum in dB
    maximumPower = max(max(channelPower));
    channelPower = channelPower - maximumPower; % Normalized Power
    feature      = channelPower;
    
    
end %function


% *************************************************************************
% File to build a matrix holding successive overlapped blocks of signal
% *************************************************************************

function block = buildBlock(signal, N, shift)
 
    % This routine re-arrange the input vector x in a matrix.
    % Every column holds one block of signal. Blocks can be overlapped
    % 'blocksize' mus be an integer number of times 'overlap'.
    % Typical values: blocksize = 2048, overlap = 128
 
    signalLength = length(signal);
    frameLength = N*shift;

    % Calculate the total number of blocks, taking overlap into account
    nbBlock = ceil(signalLength/frameLength);

    % Zero-padding by 'paddingSample' zeros to complete the matrix
    paddingSample = N - signalLength + (nbBlock-1)*frameLength;
    signal = [signal; zeros(paddingSample, 1)];

    block = zeros(N, nbBlock); % Preallocation
    % Loop to fill in the matrix
    for i = 1 : nbBlock, 
       block(:,i) = signal((i-1)*frameLength + 1 : (i-1)*frameLength + N);
    end

end

% --------------------------------- End of file ------------------------------------------




