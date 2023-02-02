function [rawTocIdx, nToc] = SH_raw_toc_detection(signal, noiseLevelDb, fs)

    if noiseLevelDb > 0 && noiseLevelDb < 1,
        noiseLevelDb = 10*log10(noiseLevelDb);
    end

    %% Threshold signal
    
    % Evaluate detection threshold
    rawTocThresholdDb = noiseLevelDb / 3;

    % Apply thresholding
    energyDb = 10*log10(signal.^2);
    energyDbTh = energyDb - rawTocThresholdDb;
    energyDbTh(energyDbTh <= 0) = 0;

    %% Handle multiple peaks belonging to same toc
   
    % Low filtering threshold signal to remove threshold multiple crossing
    nRMeanPad = 10e-3 * fs;
    energyDbBloc = running_mean(energyDbTh, nRMeanPad, true);

    % Create binarized signal: 1 where there is a toc, 0 otherwise
    energyDbBlocBin = energyDbBloc;
    energyDbBlocBin(energyDbBloc >  min(energyDbBloc)) = 1;
    energyDbBlocBin(energyDbBloc <= min(energyDbBloc)) = 0;

    % Detect beginning and ending of each blocks
    blocBorderSignal = energyDbBlocBin(2:end) - energyDbBlocBin(1:end-1);
    idx = 1:length(blocBorderSignal);
    startIdx = idx(blocBorderSignal == +1);
    stopIdx  = idx(blocBorderSignal == -1);
    
    % Handle first and last blocks
    if stopIdx(1) < startIdx(1),
        stopIdx = stopIdx(2:end);
    end
    
    if stopIdx(end) < startIdx(end),
        startIdx = startIdx(1:end-1);
    end

    %% Extract maximum index of each blocks
    
    % Extract maximum relative indexes of each blocks (vectorial implementation)
    matrixedSignal = matrixing_signal(energyDbTh, startIdx, max(stopIdx-startIdx));
    [~, maxIdxRel] = max(matrixedSignal);
    nToc = length(maxIdxRel);
    
    % Compute absolute indexes
    rawTocIdx = startIdx + maxIdxRel -1 ;

end