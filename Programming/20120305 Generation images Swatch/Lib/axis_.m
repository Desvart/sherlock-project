function axis = axis_(signalLength, fs)
% AXIS_ This function builds the axis of a time-domain signal
%
% Inputs  : signalLength    [int 1x1] Signal length
%                        or [dbl 1xn] Signal
%           [fs]            [int 1x1] Sampling rate of signal
%
% Outputs : axis            [dbl 1xn] Signal axis

% Project name      : -
% File author       : Pitch Corp.
% Date of creation  : 2011.08.07
% Version           : 0.0.1 (released: never)
% Copyright         : Copyleft
% ------------------------------------------------------------------------------------------------ %


    % --- Handle inputs

    error(nargchk(1, 2, nargin));
    error(nargchk(1, 1, nargout));

    if nargin < 2,
        fs = 1;

    end

    if size(signalLength, 1) > 1 && size(signalLength, 2) > 1,
        error('signalLength should be a scalar or a vector but not a matrix.');

    end

    if length(signalLength) > 1,
       signalLength = length(signalLength);

    end



    % --- Function core

    axis = (0:signalLength-1)/fs;

end

% ------------------------------------------------------------------------------------------------ %

