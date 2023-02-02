function [feature, nFeature] = stdft_extraction(signal, fs)
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

% todo: - Verify validity of regroup_band_in_channel function!
%       - Comment last functions

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.14  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % Put signal in its time-block representation
    window  = config_('stdftWindow');
    N = length(window);
    [block, nBlock] = build_block(signal, N, config_('stdftShift'));
    
    % Discard features with a power lower than a threshold given by user
    stdftPowerThreshold = config_('stdftPowerThreshold');
    if stdftPowerThreshold ~= 0,
        [block, nBlock] = discard_block_with_little_energy(block, config_('stdftPowerThreshold'));
    end
    
    % Compute STDFT
    unilateralPowerSpectrogram = stdft(block, window);

    % Regroup feature in channels
    stdftChannelName = config_('stdftChannelName');
    if ~isempty(stdftChannelName),
        channel = channel_selection(stdftChannelName);
        feature = regroup_band_in_channel(unilateralPowerSpectrogram, channel, fs);
    else
        feature = unilateralPowerSpectrogram;
    end
    
    nFeature = nBlock;

end


function [block, nBlock] = build_block(signal, N, shift)
% BUILD_BLOCK   Transform 1D-signal in its time-block representation. Each block has an overlap
%               of N-shift pads. The output matrix "block" holds a signal block per column.
%               
% Synopsis  build_block(signal, N, shift)
%
% Input
%       - signal [dbl 1xn]  Signal
%       - N      [int 1x1]  Window size
%       - shift  [dbl 1x1]  Shift in ratio of N between each block (overlap = 1 - shift). 
%                           Shift should an integer number of times N.
%
% Output
%       - block  [dbl dxm]  Time-block reprensentation of "signal" 1D-signal.
%       - nBlock [int 1x1]  Number of blocks present in "block".

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.03.03  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % Compute some usefull parameters
    signalLength = length(signal);
    frameLength  = N * shift;

    % Calculate the total number of blocks, taking overlap into account
    nBlock = floor((signalLength-N)/frameLength) + 1;

    % Troncate signal to fill the matrix without padding it
    signal = signal(1:N+frameLength*(nBlock-1));
        
    % Loop to fill in the matrix
    block = zeros(N, nBlock); % Preallocation
    for iBlock = 1:nBlock,
        start = (iBlock-1)*frameLength + 1;
        stop  = (iBlock-1)*frameLength + N;
        block(:, iBlock) = signal(start:stop);
    end

end




function [block, nBlock] = discard_block_with_little_energy(block, powerThresholdDb)
% DISCARD_BLOCK_WITH_LITTLE_ENERGY   Discard blocks with power lower than a given threshold.
%
% Input
%       - block             [dbl dxm]  Unilateral power spectrogram to threshold
%       - powerThresholdDb  [int 1x1]  Power threshold
%
% Output
%       - block  [dbl dxn]  Unilateral power spectrogram thresholded
%       - nBlock [int 1x1]  Number of blocks

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.03.03  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    N              = size(block, 1);
    blockPower     = sum(block.^2, 1) / N;                  % Power for each block
    hasEnoughPower = blockPower > 10^(powerThresholdDb/10); % Location of block with enough power
    block          = block(:, hasEnoughPower);              % Keep only blocks with sufficient power
    nBlock         = size(block, 2);                        % Number of block kept

end




function unilateralPowerSpectrum = stdft(block, window)
% v0.5.2 2011.03.03

    [N, nBlock] = size(block);
    
    % Compute windowed signal
    blockWindowed = block .* window(:, ones(1, nBlock)); 

    % Compute DFT on each block
    spectrum = fft(blockWindowed) / N;

    % Compute unilateral power spectrum of each block
    bilateralPowerSpectrum  = real(spectrum).^2 + imag(spectrum).^2;
    unilateralPowerSpectrum = [bilateralPowerSpectrum(1, :); ...
                             2*bilateralPowerSpectrum(2:N/2, :); ...
                               bilateralPowerSpectrum(N/2+1, :)];
                           
end




function channel = regroup_band_in_channel(unilateralPowerSpectrogram, channelDefinition, fs)
% v0.5.2 2011.03.03

    [N, nBlock] = size(unilateralPowerSpectrogram);
    nChannel  = length(channelDefinition) - 1;
    
    fAxis   = linspace(0, fs/2, N/2+1); % Frequency axis over [0 fs/2]
    
    channel = zeros(nChannel, nBlock); % Preallocation
    for iChannel = 1:nChannel,
        doesThisBandBelongToThisChannel = (fAxis >= channelDefinition(iChannel)) & (fAxis <  channelDefinition(iChannel+1));
        bandForThisChannel = unilateralPowerSpectrogram(doesThisBandBelongToThisChannel, :);
        channel(iChannel, :) = sum(bandForThisChannel, 1) / size(bandForThisChannel, 1);
    end

end
% --- EoF

















