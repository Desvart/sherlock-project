function [toc, nToc, nLongestTocPad, minSToc, maxSToc] = extract_toc_from_block(signal, nWindowPad, distanceInterToc)
% 
% Project TicLoc: A0.0.8
% Author: Pitch Corp.  -  2011.04.07  -  Copyleft ;-P
% ------------------------------------------------------------------------------------------------ %

    % --- Compute signal instantaneous power in dB
    signalPowerDb = compute_signal_instantaneous_power(signal, nWindowPad, true);

    
    % --- Determine maximum energy of each toc
    [tocCoarseLocation, nToc, coarseThreshold] = detect_toc_coarse_location(signalPowerDb);

    
    % --- Determine regions where there is tocs
    [tocFineLocation, nLongestTocPad, fineThreshold, noiseLevel, meanLevel] = detect_toc_fine_location(signalPowerDb, nWindowPad, tocCoarseLocation, nToc);
    

    % ---
    minSToc = min(tocFineLocation(1, 2:end) - tocFineLocation(1, 1:end-1) + 1);
    maxSToc = max(tocFineLocation(1, 2:end) - tocFineLocation(1, 1:end-1) + 1);
    
    
    % --- Extract and concatenate tocs
    toc = extract_and_concatenate_toc_from_block(signal, nLongestTocPad, tocFineLocation, distanceInterToc, nToc);
    
end



