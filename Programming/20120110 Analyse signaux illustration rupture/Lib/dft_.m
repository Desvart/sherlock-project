function [spectrum, spectrumAxis, phase] = dft_(signal, fs, win)
% DFT_  This function performs a DFT using FFT built-in matlab function but at a higher level of
%       use.
%       If only one output is requested, then this is a bilateral spectrum. 
%       If two outputs are requested, then first output is the unilateral spectrum and the second is
%       its axis.
%
% Inputs
% - signal      [dbl 1xn] Signal to process
% - [fs]        [int 1x1] Sampling rate of signal (Hz)
% - [win]       [dbl 1xm] Window to apply to signal before computing DFT. If window size (m) is
%               smaller than signal size, then only the m first elements of signal are used to
%               compute the DFT.
%            or [int 1x1] If window is an integer (w), then only the w first elements of signal are
%               used to compute the DFT. This is equivalent to apply a w-pad rectangular windows on
%               signal.
%
% Outputs
% - spectrum    [dbl 1xn] If only one output is requested, spectrum is the bilateral complex 
%               spectrum.
%            or [dbl 1xp] If more than one output is resquested, spectrum is the magnitude of the
%               unilateral spectrum.
% - [spectrumAxis]  [dbl 1xp] This is the axis of spectrum. If fs exists, then spectrumAxis is
%                   between 0:fNyq (fNyq = Nyquist frequency), else spetrumAxis is between 0:pi.
% - [phase]     [dbl 1xp] this is the angle of the unilateral spectrum.


% Project name      : -
% File author       : Pitch Corp.
% Date of creation  : 2011.05.24
% Version           : 0.0.1 (released: 2011.06.05 - not peer reviewed)
% Copyright         : Copyleft
% ------------------------------------------------------------------------------------------------ %


    %%% Handle inputs
    % At the end of this section, signal is a row vector, window is a row vector and the DFT size 
    % (N) is defined.

    error(nargchk(1, 3, nargin));
    error(nargchk(0, 3, nargout));

    [s1, s2] = size(signal);
    if xor(s1 == 1, s2 == 1), % if signal is a vector
        signal = signal(:)';

    else
        error('Input signal should be a vector. It seems that signal is a matrix or a scalar.'); 

    end


    if nargin <= 2, % if window is not defined
        win = ones(1, length(signal));

    end

    if nargin <= 1, % if window and fs are not defined
        fs = [];

    end

    [w1, w2] = size(win);
    if xor(w1 == 1, w2 == 1), % if window is a vector
        N = length(win);
        win = win(:)';
        signal = signal(1:N);

    elseif isscalar(win),
        N = window;
        win = ones(1, N);
        signal = signal(1:N);

    else    
        error('Input win should be a vector. It seems that win is a matrix.');

    end



    %%% Function core
    % Compute complex bilateral spectrum

    complexSpectrum = fft(signal .* win) / N;
    magSpectrum     = abs(complexSpectrum);
    phase           = angle(complexSpectrum);



    %%% Format outputs
    % if 1 output : output  = complex bilateral spectrum
    % if 2 outputs: outputs = magnitude unilateral spectrum, spectrum axis
    % if 3 outputs: outputs = magnitude unilateral spectrum, spectrum axis and unilateral phase
    
    if nargout == 1,
        spectrum = complexSpectrum;

    end

    if nargout >= 2,
        fNyquistId = floor(N/2) + 1;
        
        if mod(N, 2) == 0, % if N is even
            spectrum = [magSpectrum(1), 2*magSpectrum(2:fNyquistId-1), magSpectrum(fNyquistId)];

        else % if N is odd
            spectrum = [magSpectrum(1), 2*magSpectrum(2:fNyquistId)];

        end
        
        if ~isempty(fs),
            spectrumAxis = 0 : fs/N : fs/2;

        else
            spectrumAxis = 0 : 2*pi/N : pi;

        end

    end

    if nargout == 3,
        phase = phase(1:fNyquistId);

    end

end

% ------------------------------------------------------------------------------------------------ %

