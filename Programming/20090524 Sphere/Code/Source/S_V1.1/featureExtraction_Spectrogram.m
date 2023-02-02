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
%       nbChannel   [scalar] Number of channels of the feature (= feature dimension)
%
%       nBlocks     [scalar] Number of frames of the feature
%       
%
%
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------


function [feature, nbChannel, nBlocks] = featureExtraction_Spectrogram(signal, fs)


    % ------------------------------------------------------------------------------------
    % User settings
    % ------------------------------------------------------------------------------------
    
    %%% Short Time Discrete Fourier Transform (STDFT) parameters
    N      = 2048;
    shift  = 1/4;
    
    window = sqrt(hann(N, 'periodic'));
%     window = hann_side(N, shift);
    
    
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
    % Script initialization
    % ------------------------------------------------------------------------------------
    
    signal = signal(:)';

    
    % ------------------------------------------------------------------------------------
    % Compute STDFT (discarding blocks with unsufficient power)
    % ------------------------------------------------------------------------------------

    %%% Compute usefull value for the STDFT
    frameLength     = N*shift;

    signalLength    = length(signal);
    nBlocks         = ceil(signalLength / frameLength);

    paddingLength   = (nBlocks-1)*frameLength + N - signalLength;

    %%% Signal padding for boundary conditions
    paddedSignal    = [signal, zeros(1, paddingLength)];

    %%% Signal matrixing
    blocksPos       = 1:frameLength:signalLength;
    bandsPos        = 1:N;
    signalMatrix    = paddedSignal(ones(N,1)*(blocksPos-1) + bandsPos'*ones(1,nBlocks));
    
    %%% Discard blocks with unsufficient power
    blockPower      = 10*log10(sum(signalMatrix.^2)/N);             % Power for each block
    signalMatrix    = signalMatrix(:, blockPower>powerThreshold);   % Keep only blocks with sufficient power
    nBlocks         = size(signalMatrix, 2);                        % Update number of blocks

    %%% Windowing signal
    windowMatrix    = window * ones(1, nBlocks);
    signalWindowed  = signalMatrix .* windowMatrix;

    %%% Apply DFT on signal
    spectrum        = fft(signalWindowed)/N;

    %%% Compute the unilateral power spectrum
    powerSpectrum   = real(spectrum(1:N/2+1, :)).^2 + imag(spectrum(1:N/2+1, :)).^2;
    powerSpectrum   = [powerSpectrum(1,:); 2*powerSpectrum(2:end-1, :); powerSpectrum(end,:)];
    
    
    % ------------------------------------------------------------------------------------
    % Regrouping of bands (uniform) into channels (non-uniform)
    % ------------------------------------------------------------------------------------
    
    %%% Loop for every channel
    nbChannel     = length(channelFreqLim) - 1;
    frequencyAxis = linspace(0, fs/2, N/2+1); % Frequency axis over [0 fs/2]
    channelPower  = zeros(nbChannel, nBlocks);
    for i = 1 : nbChannel,
        channel = powerSpectrum(frequencyAxis >= channelFreqLim(i) & ...
                                frequencyAxis <  channelFreqLim(i+1), :);
        channelPower(i,:) = sum(channel) / size(channel, 1);
    end
    
    %%% Express spectrum in dB and normalize
    channelPower = 10*log10(channelPower);      % Power Spectrum in dB
    maximumPower = max(max(channelPower));
    channelPower = channelPower - maximumPower; % Normalized Power
    feature      = channelPower;
    
    
end %function


% --------------------------------- End of file ------------------------------------------
