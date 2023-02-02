function [unilateralPowerSpectrum, nBlock] = stdft(signal, window, shift)
% EXTRACT_STDFT   Compute unilateral Short Time Discrete Fourier Transform (STDFT) of the input 
%                 signal.
%
% Synopsis  stdft(signal, window, shift)
%
% Input
%       - signal [dbl 1xn] Signal
%       - window [dbl 1xw] Window to apply on signal blocks before to compute DFT
%       - shift  [dbl 1x1] Shift in ratio of window size between each block (overlap = 1 - shift)
%
% Output
%       - unilateralPowerSpectrum [dbl dxm] Unilateral power spectrogramme of input signal
%       - nBlock                  [int 1x1] Number of blocks of the power spectrogramme.

% Notes: This version of STDFT algorithm is adapted to Sphere Project needs. Thus, signal is not
% padded to fit time-block representation but its end is troncated. Also the only available output
% is the unilateral STDFT and not the bilateral STDFT.

% Todo:

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.03.03  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % Put signal in its time-block representation
    N = length(window);
    [block, nBlock] = build_block(signal, N, shift);

    % Compute windowed signal
    blockWindowed = block .* window(:, ones(1,4)); 

    % Compute DFT on each block
    spectrum = fft(blockWindowed) / N;

    % Compute unilateral power spectrum of each block
    bilateralPowerSpectrum  = real(spectrum).^2 + imag(spectrum).^2;
    unilateralPowerSpectrum = [bilateralPowerSpectrum(1, :); ...
                             2*bilateralPowerSpectrum(2:N/2, :); ...
                               bilateralPowerSpectrum(N/2+1, :)];
    
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
% --- EoF
