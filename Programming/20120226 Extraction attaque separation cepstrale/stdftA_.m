function [spectrumUM, spectrumUP, sStopPadding, tAxis, fAxis] = stdftA_(signal, win, shift, fs)
%
% % 2012.02.26

    %%% Handle inputs

    error(nargchk(3, 4, nargin));
    error(nargchk(1, 5, nargout));

    if nargin <= 3,
        fs = [];
    end

    [s1, s2] = size(signal);
    if xor(s1 == 1, s2 == 1), % if signal is a vector
        signal = signal(:)';

    else
        error('Input signal should be a vector. It seems that signal is a matrix or a scalar.'); 

    end

    [w1, w2] = size(win);
    if xor(w1 == 1, w2 == 1), % if window is a vector
        N = length(win);
        win = win(:)';

    elseif isscalar(win),
        N = win;
        win = rectwin(N)';
%         win = sqrt(hann(N, 'periodic'))';

    else    
        error('Input win should be a vector. It seems that win is a matrix.');

    end
    
    if ~is_pow2(N),
        warning('function:badInput', 'N is not a power of 2. DFT computing will be slower.\n');
        
    end
    
    if isscalar(shift),
        if shift <= 0 || shift > 1,
            error('Input shift should be between ]0, 1].');
            
        end
        
    else
        error('Input shift should be a scalar.');
        
    end
    
    if ~is_int(shift*N),
        error('Shift input should be a fractional integer of win size.');
        
    end
    
    
    
% Compute padding size
sStartPadding   = N;
startPadding    = zeros(1, sStartPadding);
% startPadding = ones(1, sStartPadding) * mean(signal(1:sStartPadding));
sFrame          = N*shift;
sSignal         = length(signal);
nBlock          = ceil((sSignal+N)/sFrame);
sStopPadding    = N - ((sSignal+N)-(nBlock-1)*sFrame);
stopPadding     = zeros(1, sStopPadding);
% stopPadding     = ones(1, sStopPadding) * mean(signal(end-sStopPadding:end));
signalPadded    = [startPadding, signal, stopPadding];

% Signal matrixing (vectorized implementation)
blockPos        = 1:sFrame:sSignal+N;
bandPos         = 1:N;
signalMatrix    = signalPadded(ones(N, 1)*(blockPos-1) + bandPos'*ones(1, nBlock));

% Windowing signal
winMatrix       = win' * ones(1, nBlock);
signalWindowed  = signalMatrix .* winMatrix;

% Apply DFT on signal
spectrumU        = fft(signalWindowed)/N;
      
% Extract unilateral matrix
nBand  = N/2 + 1;      % number of frequential bands
spectrumU  = [spectrumU(1,:) ; 2*spectrumU(2:nBand-1,:) ; spectrumU(nBand,:)];
spectrumUM = abs(spectrumU);        % Unilateral Magnitude Time-Frequency Matrix
spectrumUP = angle(spectrumU);      % Unilateral Phase Time-Frequency Matrix

tRes = sFrame/fs;
tAxis = (0:nBlock-1)*tRes;
fRes = fs/N;
fAxis = (0:nBand-1)*fRes;


end