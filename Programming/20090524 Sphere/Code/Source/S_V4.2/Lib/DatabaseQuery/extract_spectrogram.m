% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% This function extracts spectrogram features from the input signal. Various settings can be
% changed in the 'User settings' part to select the exact wanted features.
%
% Input
%   - signal [dbl 1xn]  signal
%   - fs     [int 1x1]  sampling rate
%
% Output
%   - feat   [dbl dxm]  features extracted
%   - nbFeat [int 1x1]  number of extracted features
%
%
% Author    : Pitch Corp.
% Date      : 2010.11.08
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

function [feat,nbBlock] = extract_spectrogram(signal, fs, featExtractParam)
    
    % Check inputs
    error(nargchk(3, 3, nargin));
    

    % -------------------------------------------------------------------------------------------- %
    % User settings
    % -------------------------------------------------------------------------------------------- %
    
    %%% Short Time Discrete Fourier Transform (STDFT) parameters
    N      = featExtractParam(2);
    shift  = featExtractParam(3);
    
    win = sqrt(hann(N, 'periodic'));
%     win = hannSide(N, shift);
    
    % Power threshold : all frame with not enough energy are discarded
    powThresh = 25; % dB
    
    %%% Channel type
    % 32 uniform bands up to 16000 hz
%     channelFreqLim = 0 : 500 : 16000;     

    % Bark channels
    chanFreq = [0, 100, 200, 300, 400, 510, 630, 770, 920, 1080, 1270, 1480, 1720, 2000, 2320, ...
                2700, 3150, 3700, 4400, 5300, 6400, 7700, 9500, 12000, 15500, 21000];
                
    % Custom channels
%     chanFreq = 0 : 500 : 1600;

    
    % -------------------------------------------------------------------------------------------- %
    % Compute STDFT (discarding blocks with unsufficient power)
    % -------------------------------------------------------------------------------------------- %

    % Represent signal under its block form
    block = buildBlock(signal, N, shift, 0);
    
    %%% Discard blocks with unsufficient power
    blockPow     = 10*log10(sum(block.^2)/N);     % Power for each block
    blockReduced = block(:,blockPow > powThresh); % Keep only blocks with sufficient power
    nbBlock      = size(blockReduced, 2);         % Update number of blocks

    % Windowing signal
    blockWin = blockReduced .* repmat(win, 1, nbBlock); 

    % Apply DFT on signal
    spec = fft(blockWin)/N;

    %%% Compute the unilateral power spectrum
    powSpecB = (real(spec)).^2 + (imag(spec)).^2;
    powSpecU = [powSpecB(1,:);2*powSpecB(2:N/2,:);powSpecB(N/2+1,:)];
    
    
    % -------------------------------------------------------------------------------------------- %
    % Regrouping of bands (uniform) into channels (non-uniform)
    % -------------------------------------------------------------------------------------------- %
    
    %%% Loop for every channel
    nbChan  = length(chanFreq) - 1;
    fAxis   = linspace(0, fs/2, N/2+1); % Frequency axis over [0 fs/2]
    chanPow = zeros(nbChan, nbBlock); % Preallocation
    for chanId = 1:nbChan,
        chan = powSpecU(fAxis >= chanFreq(chanId) & fAxis <  chanFreq(chanId+1), :);
        chanPow(chanId,:) = sum(chan) / size(chan, 1);
    end
    
    %%% Express spectrum in dB and normalize
    chanPow = 10*log10(chanPow); % Power Spectrum in dB
    maxPow  = max(max(chanPow));
    feat    = chanPow - maxPow;  % Normalized Power
    
end


% FUNCTION --------------------------------------------------------------------------------------- %
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
        signal = [signal,zeros(1, paddingSample)];
        
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
        block(:,blockId) = signal(start:stop);
    end

end


% EoF -------------------------------------------------------------------------------------------- %
