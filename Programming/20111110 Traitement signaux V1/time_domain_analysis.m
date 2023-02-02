

% - Build signal axis
sSignal = length(signal);
tAxis = 0:1/fs:(sSignal-1)/fs;

% - Build signal power
powerWinDuration = 1.25e-3;
sPowerWin = powerWinDuration * fs;

signalEnergyStd = signal.^2;
signalPowerStd = running_mean(signalEnergyStd, sPowerWin);

signalEnergyTko = teager_kaiser_operator(signal);
signalPowerTko = running_mean(signalEnergyTko, sPowerWin);


% - Compute mean distance between two consecutive tocs
[distanceInterToc, signalFirstCleanId] = determine_watch_frequency(watchPath, fs);
[extractedToc, ~, ~ ,minSTocForThisBlock] = extract_toc_from_block(signal', sWindow, distanceInterToc);


% - Zeros crossing activity
sZeroCrossingWin = 25;
zeroCrossingWinDuration = sZeroCrossingWin / fs;
zeroCrossing = zeros(4, sSignal);
yf = zeros(4, sSignal);
minDetected = zeros(4,1);
minDetectedIdx = zeros(4,1);
[b,a] = butter(4, (fs/512)/(fs/2), 'low');
for i = 1 : 4,
    zeroCrossing(i,:) = zero_crossing_signal(signal, sZeroCrossingWin*i*2);
    
    yf(i,:) = double(filtfilt(b,a,zeroCrossing(i,:)));
    
    [minDetected(i), minDetectedIdx(i)] = min(zeroCrossing(i,(sZeroCrossingWin*i*2+1):end));
    minDetectedIdx(i) = minDetectedIdx(i) + sZeroCrossingWin*i*2;
    minGlobIdx{i} = zeroCrossing(i, zeroCrossing(i, :) < (minDetected(i)+1e-3));
end

halfSignal = zeros(1, sSignal);
halfSignal(signal >= 0) = signal(signal >= 0);


%%% Compute various caracteristics

% - Mean energy level
meanPowerStdLevel = mean(signalPowerStd);
meanPowerTkoLevel = mean(signalPowerTko);
medianPowerStdLevel = median(signalPowerStd);
medianPowerTkoLevel = median(signalPowerTko);



