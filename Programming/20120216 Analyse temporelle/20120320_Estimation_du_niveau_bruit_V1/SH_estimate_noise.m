function [noiseLevelDb, plotLevel] = SH_estimate_noise(signal, stdFactor)
% SH_ESTIMATE_NOISE     Estimate the noise level of the toc signal. Signal should be normalized
% between -1 et 1
% 2012.02.16

    % Default inputs
    if nargin == 1,
        stdFactor = 1.5;
    end
   
    % Compute signal energy in decibel
    energyDb = 10*log10(signal.^2);
    
    % If some values are egal to -Inf, put them at min value of the energy.
    energyDb(energyDb == -Inf) = min(energyDb(energyDb ~= -Inf));

    % Estimate rawly energy envelope by using a gaussian estimation (coarse model but sufficiently 
    % representative for the purpose).
    rMean = running_mean(energyDb, 200);
    rStd  = running_std( energyDb, 200);
    rawEnvelope = rMean + stdFactor * rStd;
    
    % Estimate a minimum value below which there is no interest to plot something.
    plotLevel = min(rawEnvelope);
    
    % Find the noise level by estimating the energy value most present in the raw envelope.
    [histRawEnvelope, histAxis]  = hist(rawEnvelope, 200);
    [~, maxHistIdx] = max(histRawEnvelope);
    noiseLevelDb = histAxis(maxHistIdx);

end