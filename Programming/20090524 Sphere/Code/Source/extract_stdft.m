function [feat, nbBlock] = extract_stdft(signal, fs, featParam)
% EXTRACT_STDFT   This function extracts spectrogram features from the input signal.
%
% Input
%   - signal       [dbl 1xn]  signal
%   - fs           [int 1x1]  sampling rate
%   - extractParam [struct]  Feature extraction parameters
%                            .type    [str 1xn] type of feature to extract ('STDFT', 'MFCC', ...)
%                            .window  [dbl 1xw] window to apply the STDFT
%                            .shift   [dbl 1x1] STDFT shift
%                            .powThr  [int 1x1] Power threshold.
%                            .channel [dbl 1xn] Channel bands
%
% Output
%   - feat    [dbl dxm]  features extracted
%   - nbBlock [int 1x1]  number of extracted features

% Project Sphere: Alpha 0.2.2
% Author: Pitch Corp.  -  2010.08.06  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % -------------------------------------------------------------------------------------------- %
    % User settings
    % -------------------------------------------------------------------------------------------- %
    
    %%% Short Time Discrete Fourier Transform (STDFT) parameters
    win     = featParam.window;
    N       = length(win);
    shift   = featParam.shift;
    powThr  = featParam.powThr; % Power threshold : all frame with not enough energy are discarded
    channel = featParam.channel;

    
    % -------------------------------------------------------------------------------------------- %
    % Compute STDFT (discarding blocks with unsufficient power)
    % -------------------------------------------------------------------------------------------- %

    % Represent signal under its block form
    block = buildBlock(signal, N, shift, 0);
    
    %%% Discard blocks with unsufficient power
    blockPow     = 10*log10(sum(block.^2)/N);   % Power for each block
    blockReduced = block(:, blockPow > powThr);  % Keep only blocks with sufficient power
    nbBlock      = size(blockReduced, 2);       % Update number of blocks

    % Windowing signal
    blockWin = blockReduced .* repmat(win, 1, nbBlock); 

    % Apply DFT on signal
    spec = fft(blockWin)/N;

    %%% Compute the unilateral power spectrum
    powSpecB = (real(spec)).^2 + (imag(spec)).^2;
    powSpecU = [powSpecB(1, :); 2*powSpecB(2:N/2, :); powSpecB(N/2+1, :)];
    
    
    % -------------------------------------------------------------------------------------------- %
    % Regroup bands (uniform) into channels (non-uniform)
    % -------------------------------------------------------------------------------------------- %
    
    if channel ~= 0,
        %%% Loop for every channel
        nbChan  = length(channel) - 1;
        fAxis   = linspace(0, fs/2, N/2+1); % Frequency axis over [0 fs/2]
        chanPow = zeros(nbChan, nbBlock); % Preallocation
        for chanId = 1:nbChan,
            chan = powSpecU(fAxis >= channel(chanId) & fAxis <  channel(chanId+1), :);
            chanPow(chanId, :) = sum(chan) / size(chan, 1);
        end

        %%% Express spectrum in dB and normalize
        chanPow = 10*log10(chanPow); % Power Spectrum in dB
        maxPow  = max(max(chanPow));
        feat    = chanPow - maxPow;  % Normalized Power
    else
        feat    = 10*log10(powSpecU);
    end
    
end


% SUB FUNCTION ----------------------------------------------------------------------------------- %
% This function re-arrange input vector signal in a matrix, each column holding a block of signal
% Note : shift should an integer number of times N.
% ------------------------------------------------------------------------------------------------ %

function [block, nbBlock] = buildBlock(signal, N, shift, padFlag)
    
    %%% Check inputs
    error(nargchk(3, 4, nargin));
    if nargin == 3,
        padFlag = 1;
    end
 
    %%% Compute some usefull parameters
    signalLength = length(signal);
    frameLength  = N*shift;

    %%% Pad signal with zeros to fit final matrix
    if padFlag, 
        
        % Calculate the total number of blocks, taking overlap into account
        nbBlock = ceil(signalLength/frameLength);

        %%% Zero-padding by 'paddingSample' zeros to complete the matrix
        paddingSample = N - signalLength + (nbBlock-1)*frameLength;
        signal = [signal, zeros(1, paddingSample)];
        
    %%% troncate signal to fit final matrix
    else 
        
        % Calculate the total number of blocks, taking overlap into account
        nbBlock = floor((signalLength-N)/frameLength) + 1;

        %%% Troncate signal to fill the matrix without padding it
        stop   = N + frameLength*(nbBlock-1);
        signal = signal(1:stop);
        
    end
        
    block = zeros(N, nbBlock); % Preallocation
    %%% Loop to fill in the matrix
    for blockId = 1:nbBlock,
        start = (blockId-1)*frameLength + 1;
        stop  = (blockId-1)*frameLength + N;
        block(:, blockId) = signal(start:stop);
    end

end


% EoF -------------------------------------------------------------------------------------------- %
