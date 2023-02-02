function signal = stdftI_(stdftUM, stdftUP, win, shift, sStopPadding)
% STDFTI_    Compute time domain signal from its spectrogram.
%
% Inputs
% - stdftUM      [dbl baxbl] unilateral magnitude spectrogram
% - stdftUP      [dbl baxbl] unilateral phase spectrogram
% - win          [dbl 1xN] window to apply to each block. Block size is 
%                defined by win size (N).
% - shift        [dbl 1x1] shift ratio between blocks.
% - sStopPadding [int 1x1] size of the final padding used to build stdftUM.
%
% Output
% - signal  [dbl 1xn] signal to process
%
% See also : stdftA_

% Project   : SDM (4.3)
% Author    : Pitch
% Creation  : 2009.10.11  
% Last edit : 2010.03.01
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------- %

    %% Check inputs
    
    error(nargchk(4, 5, nargin));
    error(nargchk(1, 1, nargout));
    
    if nargin == 4,
        sStopPadding = 0;
    end
    
    [win, nBand, nBlock, N, sFrame] = check_inputs(stdftUM, stdftUP, win, shift, sStopPadding);

    
    %% Function core
    
    % Phase restoring
    stdftU = stdftUM .* exp(1j * stdftUP);

    % Rebuild the entire time-frenquency matrix
    if rem(N, 2) == 0, % if N is even
        stdftU = [stdftU(1,:) ; 1/2*stdftU(2:nBand-1,:) ; stdftU(nBand,:)];
    else % if N is odd
        stdftU = [stdftU(1,:) ; 1/2*stdftU(2:nBand,:)];
    end
    bilateralMissingPart = conj(stdftU(nBand-1 : -1 : 2, :)); 
    stdft = [stdftU; bilateralMissingPart];   

    % Inverse transformation
    signalMatrix = real(ifft(stdft * N));    % "real" is used to remove numerical approximations
    winMatrix    = win * ones(1, nBlock);
    signalMatrix = signalMatrix .* winMatrix;

    % Overlap-add operation
    signalPadded = zeros(1, N + (nBlock-1) * sFrame); % Preallocating
    for iBlock = 1 : nBlock,
       a = 1 + (iBlock-1) * sFrame; % Index of first sample
       b = N + (iBlock-1) * sFrame; % Index of last sample
       signalPadded(a:b) = signalPadded(a:b) + signalMatrix(:, iBlock).'; % Perform overlap-add
    end

    % Rescaling to keep an energy equivalency
    signalPadded = signalPadded / ( (1/2)*(N/sFrame) );

    % Remove added samples 
    sStartPadding = N;
    signal = signalPadded(sStartPadding+1 : end-sStopPadding);

    if sStopPadding == 0,
        for idx = length(signal):-1:1,
            if abs(signal(idx)) > 1e-16,
                signal = signal(1:idx);
                break;
            end
        end
    end

end


function [win, nBand, nBlock, N, sFrame] = check_inputs(stdftUM, stdftUP, win, shift, sStopPadding)

    % check stdftUM validity
    [nBand, nBlock] = size(stdftUM);
    if nBand <= 1 || nBlock <= 1,
        error('First input should be a spectrogram');
    end
    
    if ~isreal(stdftUM),
        error('First input should be real, not complex.');
    end
    
    % check stdftUP validity
    [nBandP, nBlockP] = size(stdftUP);
    if nBandP ~= nBand || nBlockP ~= nBlock,
        error('First and second inputs should have same size.');
    end
    
    if ~isreal(stdftUP),
        error('Second input should be real, not complex.');
    end
    
    % check win validity
    [w1, w2] = size(win);
    if ~xor(w1 == 1, w2 == 1),
        error('Third input should be a vector, not a scalar or a matrix.');
    else
        win = win(:);
    end
    
    if ~isreal(win),
        error('Third input should be real, not complex.');
    end
    
    N = length(win);
    
    % Check shift validity
    if sum(size(shift)) ~= 2,
       error('Third input should be a scalar, not a vector or a matrix.');
    end
    
    if isscalar(shift),
        if shift <= 0 || shift > 1,
            error('Third input should be between ]0, 1].');
        end
    else
        error('Third input should be a scalar.');
    end
	
    sFrame = N * shift;
    if round(sFrame) ~= sFrame,
        error('Third input should be a fractional integer of second input size.');
    end
    
    % check sStopPadding
    if sum(size(sStopPadding)) ~= 2,
        error('Fifth input should be a scalar, not a vector or a matrix.');
    end
    
    if ~isreal(sStopPadding) || round(sStopPadding) ~= sStopPadding,
        error('Fifth input should be a real integer, not a complexe or a double value.');
    end

end