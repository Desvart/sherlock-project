    
function signalPowerDb = compute_signal_instantaneous_power(signal, nWindowPad, shouldHandleInf)
% COMPUTE_SIGNAL_INSTANTANEOUS_POWER 
%
% Input     signal              [dbl 1xn] signal to process
%           fs                  [int 1x1] sampling rate of signal
%           powerWindowDuration [dbl 1x1] window size in milliseconds to compute the running mean.
%
% Output    signalPowerDb       [dbl 1xn] signal power in decibels.

% Note : If signal is a big array (60 sec @ 192 kHz), Matlab can have memory problems. Clear
% instruction are there to avoid those problems.

% Project TicLoc : Alpha 0.0.7 - 2011.04.01

    % Compute sound energy
    signalEnergy = signal.^2;

    % Compute a running mean over all signal
    signalPower  = running_mean(signalEnergy, nWindowPad);
    
    % Normalize signal
    signalPower = signalPower./max(signalPower);
    
    % Emphasis small values
    signalPowerDb = 10*log10(signalPower);
    
    % Replace -Inf caused by db conversion with the signal's lower non infinite value.
    if shouldHandleInf,
        signalPowerDb(1:nWindowPad-1) = min(signalPowerDb(nWindowPad:3*nWindowPad));
    end
    
end