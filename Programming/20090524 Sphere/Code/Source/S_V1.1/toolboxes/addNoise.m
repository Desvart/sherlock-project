% ----------------------------------------------------------------------------------------
% Function : bayes_Training.m
% 
% Purpose  : This function adds white gaussian random noise to the input signal to reach
%            specified SNR.
%            Input signal should be a line vector.
%
%
% Inputs :  
%       signal  [vector] signal to noise
%       
%       snr     [scalar] SNR ratio in decibel
%
% Outputs : 
%       signal  [vector] noised signal
%       
%
%
% Author    : Pitch Corp.
% Date      : 06.06.2010
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------


function signal = addNoise(signal, snr)

    % Note : For white Gaussian noise, the level corresponds to the variance
    %        if n gaussian white noise => var(n) = sum(n.^2)/length(n)
   
    signalSize = length(signal);
    soundlevel = 10*log10(sum(signal.^2)/signalSize); % Sound level (in average)
    noiselevel = soundlevel - snr;                    % Noise level
    noisesigma = 10^(noiselevel/20);                  % Standard deviation of the noise
    noise      = noisesigma * randn(1, signalSize);   % Noise generation for specified SNR
    signal     = signal + noise;                      % Add noise
    
end %function


% --------------------------------- End of file ------------------------------------------
