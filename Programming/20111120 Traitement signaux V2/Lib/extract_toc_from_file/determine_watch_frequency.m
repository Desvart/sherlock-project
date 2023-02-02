function [distanceInterToc, signalFirstCleanId, watchFrequency] = determine_watch_frequency(watchPath, fs)

    % --- Load first two seconds
    signal = wavread(watchPath, [1, 2*fs]);

    % --- Compute signal instantaneous power in dB
    sWindow = 10e-3 * fs; % 10 ms @ 192 kHz
    signalPowerDb = compute_signal_instantaneous_power(signal', sWindow, true);

    % --- Determine maximum energy of each toc
    tocCoarseLocation = detect_toc_coarse_location(signalPowerDb);

    % --- Compute distance between tocs and watch frequency
    distanceInterToc = round(mean(tocCoarseLocation(2:end)-tocCoarseLocation(1:end-1)));
    %     watchFrequency   = cast(round(1/(2*distanceInterToc/fs)), 'uint32');
    watchFrequency   = round(1/(2*distanceInterToc/fs));
    
    % --- First index (half location between toc 1 and 2)
    signalFirstCleanId = tocCoarseLocation(2) - ceil(distanceInterToc/2);
    
end