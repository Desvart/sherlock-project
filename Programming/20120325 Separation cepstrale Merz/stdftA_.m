function [spectrumUM, spectrumUP, sStopPadding, tAxis, fAxis] = stdftA_(signal, win, shift, fs)
% STDFTA_    Compute spectrogram of a signal. Output parameters are given
% to allow a reconstruction.
%
% Inputs
% - signal  [dbl 1xn] signal to process
% - win     [int 1x1] Block size. DFT window is rectangular.
%        OR [dbl 1xN] window to apply to each block. Block size is defined 
%           by win size (N).
% - shift   [dbl 1x1] shift ratio between blocks.
% - [fs]    [int 1x1] Signal sampling frequency.
%           Default : 1 (normalized value)   
%
% Outputs
% - spectrumUM   [dbl baxbl] unilateral magnitude spectrogram
% - spectrumUP   [dbl baxbl] unilateral phase spectrogram
% - sStopPadding [int 1x1] size of the final padding. Usefull for
%                reconstruction.
% - tAxis        [1xbl] spectrogram time axis
% - fAxis        [1xba] spectrogram frequency axis
%
% See also : stdftI_

% Project   : SDM (4.2)
% Author    : Pitch
% Creation  : 2009.10.11  
% Last edit : 2010.01.25
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------- %

    %% Check inputs
    
    error(nargchk(3, 4, nargin));
    error(nargchk(1, 5, nargout));

    if nargin <= 3,
        fs = [];
    end
    
    [signal, win, shift, fs, N, sFrame] = check_inputs(signal, win, shift, fs);


    %% Function core
    
    % Compute padding size
    sStartPadding   = N;
    startPadding    = zeros(1, sStartPadding);
    sFrame          = N*shift;
    sSignal         = length(signal);
    nBlock          = ceil((sSignal+N)/sFrame);
    sStopPadding    = N - ((sSignal+N)-(nBlock-1)*sFrame);
    stopPadding     = zeros(1, sStopPadding);
    signalPadded    = [startPadding, signal, stopPadding];

    % Signal matrixing (vectorized implementation)
    blockPos        = 1 : sFrame : sSignal+N;
    bandPos         = 1 : N;
    signalMatrix    = signalPadded(ones(N, 1)*(blockPos-1) + bandPos'*ones(1, nBlock));

    % Windowing signal
    winMatrix       = win * ones(1, nBlock);
    signalWindowed  = signalMatrix .* winMatrix;

    % Apply DFT on matrixed signal
    spectrumU       = fft(signalWindowed)/N;

    % Extract unilateral matrix
    if rem(N, 2) == 0, % if N is even
        nBand      = N/2 + 1;               % number of frequential bands
        spectrumU  = [spectrumU(1,:) ; 2*spectrumU(2:nBand-1,:) ; spectrumU(nBand,:)];
    else % if N is odd
        nBand      = (N+1)/2;               % number of frequential bands
        spectrumU  = [spectrumU(1,:) ; 2*spectrumU(2:nBand,:)];
    end
    spectrumUM = abs(spectrumU);        % Unilateral Magnitude Time-Frequency Matrix
    spectrumUP = angle(spectrumU);      % Unilateral Phase Time-Frequency Matrix

    % Compute time and frequency axis of computed spectrogram
    tRes    = sFrame/fs;
    tAxis   = (0:nBlock-1)*tRes;
    fRes    = fs/N;
    fAxis   = (0:nBand-1)*fRes;

end


function [signal, win, shift, fs, N, sFrame] = check_inputs(signal, win, shift, fs)

    % Check signal size
    [s1, s2] = size(signal);
    if xor(s1 == 1, s2 == 1), % if signal is a vector
        signal = signal(:)';
    else
        error('First input should be a vector not a matrix or a scalar.'); 
    end

    % Check win size
    [w1, w2] = size(win);
    if xor(w1 == 1, w2 == 1), % if window is a vector
        N = length(win);
        win = win(:);
    elseif isscalar(win),
        N = win;
        win = rectwin(N);
    else    
        error('Second input should be a vector or a scalar not a matrix.');
    end
    
    % Check N validity
    if sum(size(N)) ~= 2,
           error('Third input should be a scalar, not a vector or a matrix.');
    end
    
    if ~isreal(N) || round(N) ~= N,
        error('Second input should be a real integer, not a complexe or a double value.');
    end
    
    % Check if N is a power of 2
    if bitand(N, N-1),
        warning('function:badInput', 'Second input size is not a power of 2. DFT computing will be slower.\n');
    end
    
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
	
    sFrame = shift*N;
    if round(sFrame) ~= sFrame,
        error('Third input should be a fractional integer of second input size.');
    end
    
    % Check fs validity
    if ~isempty(fs),
        if sum(size(fs)) ~= 2,
           error('Fourth input should be a scalar, not a vector or a matrix.');
        end
        
        if ~isreal(fs) || round(fs) ~= fs,
            error('Fourth input should be a real integer, not a complexe or a double value.');
        end
    else
        fs = 1;
    end
end