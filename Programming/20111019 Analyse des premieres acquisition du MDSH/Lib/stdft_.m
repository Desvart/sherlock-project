function [stdft, optOut1, optOut2, optOut3] = stdft_(signal, win, shift, fs)
% STDFT_  This function performs a short-time DFT of a given signal.
%
% Inputs
% - signal  [dbl 1xn] Signal to process
% - win     [dbl 1xw] Window to apply on time blocks. Block size is window size.
%        or [int 1x1] Block size. Window is then assumed to be rectangular.
% - shift   [dbl 1x1] Fraction of block to shift between each block to garantire an overlaping 
%           between blocks.
% - [fs]    [int 1x1] Signal sampling frequency. Default: fs = [];
%
% Outputs
% if nargout == 1,
% - stdft           [dbl C wxb] complexe bilateral short-time dft.
%
% if nargout == 2,
% - stdft           [dbl wxb] magnitude bilateral short-time dft.
% - optOut1         [dbl wxb] phase bilateral short-time dft.
%
% if nargout == 3,
% - stdft           [dbl vxb]magnitude unilateral short-time dft.
% - optOut1         [dbl 1xb] STDFT temporal axis. If fs input exists, then stdftTAxis is in ms else
%                   it is in samples.
% - optOut2         [dbl 1xv] STDFT frequential axis. If fs input exists, then stdftFAxis is in kHz,
%                   else it is in rad.
%
% if nargout == 4,
% - stdft           [dbl vxb]magnitude unilateral short-time dft.
% - optOut1         [dbl vxb] phase unilateral short-time dft.
% - optOut2         [dbl 1xb] STDFT temporal axis. If fs input exists, then stdftTAxis is in ms else
%                   it is in samples.
% - optOut3         [dbl 1xv] STDFT frequential axis. If fs input exists, then stdftFAxis is in kHz,
%                   else it is in rad.

% All possible synopsis that make sens:
%
% stdft                                         = stdft_(signal, win, shift);
% [stdft, stdftPhase]                           = stdft_(signal, win, shift);
%
% [stdft, stdftTAxis, stdftFAxis]               = stdft_(signal, win, shift);
% [stdft, stdftPhase, stdftTAxis, stdftFAxis]   = stdft_(signal, win, shift);
%
% [stdft, stdftTAxis, stdftFAxis]               = stdft_(signal, win, shift, fs);
% [stdft, stdftPhase, stdftTAxis, stdftFAxis]   = stdft_(signal, win, shift, fs);


% Project name      : -
% File author       : Pitch Corp.
% Date of creation  : 2011.06.07
% Version           : 0.0.1 (released: 2011.06.08 - not peer reviewed)
% Copyright         : Copyleft
% ------------------------------------------------------------------------------------------------ %


    %%% Handle inputs

    error(nargchk(3, 4, nargin));
    error(nargchk(1, 4, nargout));

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
    
    

    %%% Function core

    sFrame          = N*shift;
    sSignal         = length(signal);
    nBlock          = floor((sSignal-N)/sFrame) + 1;
    sTruncSignal    = N + (nBlock-1)*sFrame;
    truncSignal     = signal(1:sTruncSignal);

    % Signal matrixing (vectorized implementation)
    blockPos        = 1:sFrame:sSignal-N+1;
    bandPos         = 1:N;
    signalMatrix    = truncSignal(ones(N, 1)*(blockPos-1) + bandPos'*ones(1, nBlock));

    % Windowing signal
    winMatrix       = win' * ones(1, nBlock);
    signalWindowed  = signalMatrix .* winMatrix;

    % Apply DFT on signal
    spectrum        = fft(signalWindowed)/N;
    
    

    %%% Format outputs

    if nargout == 1,
        stdft = spectrum;
        
    end
    
    if nargout == 2,
        stdft = abs(spectrum);
        stdftPhase = angle(spectrum);
        
        optOut1 = stdftPhase;
        
    end
    
    if nargout == 3 || nargout == 4,
        stdft = abs(spectrum);
        fNyquistId = floor(N/2) + 1;
        if mod(N, 2) == 0, % if N is even
            stdft = [stdft(1, :); 2*stdft(2:fNyquistId-1, :); stdft(fNyquistId, :)];

        else % if N is odd
            stdft = [stdft(1, :); 2*stdft(2:fNyquistId, :)];

        end
        
        if ~isempty(fs),
            stdftTAxis = 0:sFrame/fs:(nBlock-1)*sFrame/fs;
            stdftFAxis = 0:fs/N:fs/2;
            
        else
            stdftTAxis = 0:nBlock-1;
            stdftFAxis = 0:2*pi/N:pi;
            
        end
        
        optOut1 = stdftTAxis;
        optOut2 = stdftFAxis;

    end
    
    if nargout == 4,
        stdftPhase = angle(spectrum(1:fNyquistId, :));
        
        optOut1 = stdftPhase;
        optOut2 = stdftTAxis;
        optOut3 = stdftFAxis;
        
    end

end

% ------------------------------------------------------------------------------------------------ %

