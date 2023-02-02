function [tocCoarseLocation, nToc, threshold] = detect_toc_coarse_location(signalPowerDb)
% DETECT_TOC_COARSE_LOCATION  Detect toc location. The criteria used to define the toc location is
%                             the maximum power of each toc.
% 
% Synopsis  detect_toc_coarse_location(signalPowerDb)
%
% Input     signalPowerDb       [dbl 1xn] power signal where we should find tocs
%
% Output    tocCoarseLocation   [int 1xt] index position (based on signalPowerDb) of each detected 
%                               toc.
%           nToc                [int 1x1] number of tocs detected
%           threshold           [int 1x1] threshold value used for this detection

% Project TicLoc : Alpha 0.0.7 - 2011.03.30

    % --- Build threshold for coarse tocs detection
    signalMaxDb = max(signalPowerDb);
    signalMinDb = min(signalPowerDb);
    threshold = signalMaxDb - (signalMaxDb-signalMinDb)/3;
    
    % --- Detect pics locations which go through threshold
    binarizedSignal = binarize_signal(signalPowerDb, threshold);
    [tocStartId, tocStopId, nToc] = detect_binary_signal_gradiant(binarizedSignal);
    
    % --- Detect maximum location of each presumed toc
    tocCoarseRelativeLocation = zeros(1, nToc); % Preallocation
    for iToc = 1:nToc, % Compute relative location (relative to toc beginning) of each presumed toc
        [~, tocCoarseRelativeLocation(iToc)] = max(signalPowerDb(tocStartId(iToc):tocStopId(iToc)));
    end
    tocCoarseLocation = min(tocCoarseRelativeLocation + tocStartId, length(signalPowerDb)); % Compute absolut location of each presumed toc
    
    % --- Some presumed toc are anomalies due to thresholding a noisy signal with a simple
    % threshold. This part adresses this issue.
    nAnomaly = -1; % initialization for while loop
    while nAnomaly ~= 0,
        % Compute distance between presumed tocs
        distBetweenToc = tocCoarseLocation(2:end) - tocCoarseLocation(1:end-1); 

        % Detect anomalies based on toc inter-distance
        anomalyId = find(distBetweenToc < mean(distBetweenToc)/2);
        nAnomaly = length(anomalyId);

        % Respect to power levels, discard anomalies and keep maximum power location
        isAnomaly = signalPowerDb(tocCoarseLocation(anomalyId)) >= signalPowerDb(tocCoarseLocation(anomalyId+1));
        anomalyId(isAnomaly) = anomalyId(isAnomaly) + 1;
        tocCoarseLocation(anomalyId) = []; % Discard anomalies
    end
    
    nToc = length(tocCoarseLocation);

end
