function [envelope, fineStruct] = cepstral_split(stdftUM, cutingIdx)
% CEPSTRAL_SPLIT    Split spectrogram in its envelope and fine structure
% parts using a cepstral analysis.
% Be careful: this function only works on magnitude spectrogram and not on
% complex ones.
%
% Inputs
% - stdftUM     [dbl baxbl] unilateral spectrogram magnitude to split
% - cutingIdx   [int 1x1] quefrency index where the cepstrogram will be 
%               split.
%
% Outputs
% - envelope    [dbl baxbl] unilateral spectrogram magnitude of the
%               envelope.
% - fineStruct  [dbl baxbl] unilateral spectrogram magnitude of the
%               fine structure.

% Project   : SDM (4.3)
% Author    : Pitch
% Creation  : 2009.12.20  
% Last edit : 2011.07.30
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------- %
    
    %% Check inputs
    
    error(nargchk(2, 2, nargin));
    error(nargchk(1, 2, nargout));       
    nBand = check_inputs(stdftUM, cutingIdx);
    
    
    %% Function core
    
    % Compute cepstrogram
    cepstro = ifft(log(stdftUM)) / nBand;
    
    % Build envelope in cepstrogram domain by keeping cepstrogram low 
    % components
    cepstralLow  = cepstro;
    cepstralLow(cutingIdx : end-cutingIdx, :) = min(min(cepstro));

    % Build fine structure in cepstrogram domain by keeping cepstrogram 
    % high components
    cepstralHigh = cepstro;
    cepstralHigh([1:cutingIdx , end-cutingIdx : end], :) = min(min(cepstro));

    % Build envelope spectrogram based on envelope cepstrogram
    logEnvelope = real( fft(cepstralLow*nBand) ); % "real" is used to remove numerical approximations
    envelope   	= exp(logEnvelope);

    % Build fine structure spectrogram based on fine structure cepstrogram
    logFineStruct = real( fft(cepstralHigh*nBand) ); % "real" is used to remove numerical approximations
    fineStruct    = exp(logFineStruct);

end

    
function nBand = check_inputs(stdftUM, cutingIdx)
        
    % Check first input size
    [nBand, nBlock] = size(stdftUM);
    if nBand <= 1 || nBlock <= 1,
        error('First input should be a spectrogram');
    end

    % Check if first input is complex
    if ~isreal(stdftUM),
        error('First input should be a spectrogram magnitude and not a complex one.');
    end

    % Check second input size
    [c1, c2] = size(cutingIdx);
    if c1 > 1 || c2 > 1,
        error('Second input should be a scalar');
    end

    % Check if second input is complex
    if ~isreal(cutingIdx) || round(cutingIdx) ~= cutingIdx,
        error('Second input should be a real integer, not a complex or a double one.');
    end

end