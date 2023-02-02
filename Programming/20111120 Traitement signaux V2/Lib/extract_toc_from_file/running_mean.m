function signalFiltered = running_mean(signal, nWindowPad)
% RUNNING_MEAN  perform a running mean (also known as sliding mean) over signal with nWindowPad 
%               size. Output signal is padded with zeros to have the same size as input signal.
% 
% Synopsis  running_mean(signal, nWindowPad)
%
% Input     signal      [dbl 1xn] signal to filter
%           nWindowPad  [int 1x1] pad size of the running window
%
% Output    signalFiltered  [dbl 1xn] signal filtered and zero-padded to have the same size as input
%                           signal.

% Note: This implementation of the running mean is a fast one done without loop.

% Project TicLoc : Alpha 0.0.1 - 2011.03.09

    x = [0, cumsum(signal)/nWindowPad];
    signalFiltered = [zeros(1, nWindowPad-1), x(nWindowPad+1:end)-x(1:end-nWindowPad)];
    
end
