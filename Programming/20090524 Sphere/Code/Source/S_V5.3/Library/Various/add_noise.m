function noisedSignal = add_noise(signal, snr)
% ADD_NOISE     This function adds white gaussian noise to the input signal to reach specified SNR.
% Note : For white Gaussian noise, the level corresponds to the variance
%        if n gaussian white noise => var(n) = sum(n.^2)/length(n)
%
% Input
%   - signal [dbl nx1] signal to noised
%   - snr    [int 1x1] snr level that signal should reached
%
% Ouput
%   - noisedSignal [dbl nx1] noised signal

% Project Sphere: Alpha 0.5.0
% Author: AD - Pitch Corp.  -  2011.01.03  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % Compute signal size
    nSignalSample = length(signal);
    
    % Compute average sound level
    soundLevel = 10*log10(sum(signal.^2)/nSignalSample); % dB
    
    % Compute noise level to add to original signal
    noiseLevel = soundLevel - snr; % dB
    
    % Compute standard deviation of the noise
    noiseSigma = 10^(noiseLevel/20);
    
    % Generate noise for specified SNR
    noise = noiseSigma * randn(1, nSignalSample);
    
    % Add noise to signal
    noisedSignal = signal + noise;
    
end


% EoF -------------------------------------------------------------------------------------------- %
