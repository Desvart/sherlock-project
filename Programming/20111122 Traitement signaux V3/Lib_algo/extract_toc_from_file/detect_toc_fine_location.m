function [tocFineLocation, nLongestTocPad, threshold, noiseLevel, meanLevel] = detect_toc_fine_location(signal, nWindowPad, tocCoarseLocation, nToc)
%
% Project TicLoc : Alpha 0.0.7 - 2011.03.30

    % --- Build threshold for fine tocs detection
    meanLevel  = mean(signal);
    isNoise    = signal < meanLevel;
    noiseLevel = mean(signal(isNoise));
    noiseVariation = std(signal(isNoise));
    threshold  = noiseLevel + (meanLevel-noiseLevel)*noiseVariation/2;
    
    % --- Detect pics locations which go through threshold
    binarizedSignal = binarize_signal(signal, threshold);
    [presumedTocStartId, presumedTocStopId] = detect_binary_signal_gradiant(binarizedSignal);
    
    % --- Refine results using the coarse detection
    tocFirstId = zeros(1, nToc);
    tocLastId  = zeros(1, nToc);
    for iToc = 1:nToc,
        isTocLocation =   tocCoarseLocation(iToc) >= presumedTocStartId ...
                        & tocCoarseLocation(iToc) <= presumedTocStopId;
                    
        tocFirstId(iToc) = presumedTocStartId(isTocLocation);
        tocLastId(iToc)  = presumedTocStopId(isTocLocation);
    end
    
    % --- Adjust detected locations to better fit TicLoc project needs.
    tocFineLocation = max(1, [tocFirstId - round(nWindowPad/24); ...
                              tocLastId  - round(nWindowPad*2/3)]);
    if tocLastId(end) == length(signal),
        tocFineLocation(2, end) = tocLastId(end);
    end
    
    nLongestTocPad = max(tocFineLocation(1, 2:end) - tocFineLocation(1, 1:end-1)) + 1;
    
end