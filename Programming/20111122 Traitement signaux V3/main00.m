%%% Init script
close all;
clear all;
clc;

%%% User inputs
lib = {'Lib_algo', 'Lib_UI'};
databasePath = './Data/Processed/01/';
signalDuration = 1;
nHistBin = 250;
powerWinDuration = 1.25e-3/8;

%%% Load library
for iLib = 1 : length(lib),
    if exist(['./', lib{iLib}, '/'], 'dir'), 
        addpath(genpath(['./', lib{iLib}, '/'])); 
    end
end


%%% Load signal
[filePathList, nFile] = load_file_path_list(databasePath);


% for iFile = 1 : nFile,
iFile = 2;
    %%% Load signal
    matObj = matfile(filePathList{iFile});
    fs = double(matObj.fs);
    signal = double(matObj.signal(1, 1:signalDuration*fs));
    signal = signal(:)';

    %%% Compute temporal axis
    sSignal = length(signal);
    tAxis = (0:sSignal-1)/fs;

    %%% Compute statistics about time-domain signal
    signalMin = min(signal);
    signalMax = max(signal);
    signalDynamicRange = signalMax - signalMin;
    signalMean = mean(signal);
    signalMedian = median(signal);
   
    signalMeanMinus = mean(signal(signal<=0));
    signalMedianMinus = median(signal(signal<=0));
   
    signalMeanPlus = mean(signal(signal>=0));
    signalMedianPlus = median(signal(signal>=0));
    
    %%% Compute signal energy (Taiger-Kaiser)
    signalEnergy = teager_kaiser_operator(signal);
    signalEnergy(signalEnergy<=0) = min(signalEnergy(signalEnergy>0));
    
    %%% Compute statistics about signal energy signal
    energyMin = min(signalEnergy);
    energyMax = max(signalEnergy);
    energyDynamicRange = energyMax - energyMin;
    energyMean = mean(signalEnergy);
    energyMedian = median(signalEnergy);
    
    [energyHist, energyHistFreq] = hist(10*log10(signalEnergy), nHistBin);
    
    %%% Compute signal power
    signalPower = running_mean(signalEnergy, fs*powerWinDuration, true);
    
    %%% Compute statistics about signal power signal
    powerMin = min(signalPower);
    powerMax = max(signalPower);
    powerDynamicRange = energyMax - energyMin;
    powerMean = mean(signalPower);
    powerMedian = median(signalPower);
    
    [powerHist, powerHistFreq] = hist(10*log10(signalPower), nHistBin);
    
    %%% Detect noise level based on histogram
%     noiseLevel = detecte_noise_level(histogram, histogramFreq, energyMedian, true); % Pas encore au point!!

    %%% Compute spectrum 
%     [spectrum, fAxis] = dft_(signal, fs);
    
    %%% Compute bi-spectrum
    
    
    %%% Display 
    fprintf('Time-domain signal\n');
    fprintf('Signal min \t\t\t: %f\n', signalMin);
    fprintf('Signal max \t\t\t: %f\n', signalMax);
    fprintf('Dynamic range \t\t: %f\n', signalDynamicRange);
    fprintf('Signal mean \t\t: %f\n', signalMean);
    fprintf('Signal median \t\t: %f\n\n', signalMedian);
    
    fprintf('Signal mean (<=0) \t: %f\n', signalMeanMinus);
    fprintf('Signal median (<=0) : %f\n\n', signalMedianMinus);
   
    fprintf('Signal mean (>0) \t: %f\n', signalMeanPlus);
    fprintf('Signal median (>0)  : %f\n\n', signalMedianPlus);
    
    fprintf('Energy signal\n');
    fprintf('Energy min \t\t\t: %2.1f dB\n', 10*log10(energyMin));
    fprintf('Energy max \t\t\t: %2.1f dB\n', 10*log10(energyMax));
    fprintf('Energy dynamic range: %2.1f dB\n', 10*log10(energyDynamicRange));
    fprintf('Energy mean \t\t: %2.1f dB\n', 10*log10(energyMean));
    fprintf('Energy median \t\t: %2.1f dB\n\n', 10*log10(energyMedian));
    
    fprintf('Power signal\n');
    fprintf('Power min \t\t\t: %2.1f dB\n', 10*log10(powerMin));
    fprintf('Power max \t\t\t: %2.1f dB\n', 10*log10(powerMax));
    fprintf('Power dynamic range : %2.1f dB\n', 10*log10(powerDynamicRange));
    fprintf('Power mean \t\t\t: %2.1f dB\n', 10*log10(powerMean));
    fprintf('Power median \t\t: %2.1f dB\n\n', 10*log10(powerMedian));
    
%     fprintf('Noise level \t\t: %f dB\n\n', noiseLevel);
    
    %%% Generate plots and save them
    
    % Time domain
    figure('color', 'white'); 
    subplot(2, 1, 1); hold on;
    plot(tAxis*1e3, signal);
    plot(tAxis*1e3, signalMeanMinus*ones(1, sSignal), '--r');
    plot(tAxis*1e3, signalMeanPlus*ones(1, sSignal), '-.r');
    plot(tAxis*1e3, signalMedianMinus*ones(1, sSignal), '--c');
    plot(tAxis*1e3, signalMedianPlus*ones(1, sSignal), '-.c');
    axis tight;
    legend('Raw signal', sprintf('Negative mean (%0.3fe-3)', signalMeanMinus*1e3), sprintf('Positive mean (%0.3fe-3)', signalMeanPlus*1e3), ...
                         sprintf('Negative median (%0.3fe-3)', signalMedianMinus*1e3), sprintf('Positive median (%0.3fe-3)', signalMedianPlus*1e3));
    xlabel('Time [ms]');
    ylabel('Amplitude [-]');
    
    subplot(2, 1, 2); hold on;
    
    energyNorm = signalEnergy/max(signalEnergy);
    powerNorm  = signalPower /max(signalEnergy);
    powerMinNorm = powerMin/max(signalEnergy);
    powerMeanNorm = powerMean/max(signalEnergy);
    powerMedianNorm = powerMedian/max(signalEnergy);
    
    plot(tAxis*1e3, 10*log10(energyNorm));
    plot(tAxis*1e3, 10*log10(powerNorm), 'r');
    plot(tAxis*1e3, 10*log10(powerMinNorm)*ones(1, sSignal), '-.g');
    plot(tAxis*1e3, 10*log10(powerMeanNorm)*ones(1, sSignal), '--c');
    plot(tAxis*1e3, 10*log10(powerMedianNorm)*ones(1, sSignal), '-.c');
    axis tight;
    legend('Energy signal (Teager-Kaiser)', sprintf('Power signal (win = %0.2f ms = %d S)', powerWinDuration*1e3, fs*powerWinDuration), ...
            sprintf('Normalized power min (%2.1f dB)', 10*log10(powerMinNorm)), ...
            sprintf('Normalized power mean (%2.1f dB)', 10*log10(powerMeanNorm)), sprintf('Normalized power median (%2.1f dB)', 10*log10(powerMedianNorm)));
    xlabel('Time [ms]');
    ylabel('Normalized magnitude [dB]');
    
    
    
    % Energy
    figure('color', 'white'); 
    subplot(1, 7, 2:7); hold on;
    signalEnergy(signalEnergy<=0) = min(signalEnergy(signalEnergy>0));
    plot(tAxis*1e3, 10*log10(signalEnergy));
    plot(tAxis*1e3, 10*log10(energyMean)*ones(1, sSignal), '--r');
    plot(tAxis*1e3, 10*log10(energyMedian)*ones(1, sSignal), '--c');
%     plot(tAxis*1e3, noiseLevel*ones(1, sSignal), '--k');
    axis tight;
    ylim([10*log10(energyMedian)-3, max(10*log10(signalEnergy))]);
    legend('Signal energy (Teager-Kaiser)', sprintf('Energy mean (%2.2f dB)', 10*log10(energyMean)), sprintf('Energy median (%2.2f dB)', 10*log10(energyMedian)));
    xlabel('Time [ms]');
    ylabel('Magnitude [dB]');
    
    subplot(1, 7, 1); hold on;
    plot(energyHist(2:end)/1e3, energyHistFreq(2:end));
    plot(energyHist(2:end)/1e3, 10*log10(energyMean)*ones(1, nHistBin-1), '--r');
    plot(energyHist(2:end)/1e3, 10*log10(energyMedian)*ones(1, nHistBin-1), '--c');
%     plot(histogram(2:end)/1e3, noiseLevel*ones(1, nHistBin-1), '--k');
    set(gca, 'XDir', 'reverse');
    axis tight;
    ylim([10*log10(energyMedian)-3, max(10*log10(signalEnergy))]);
    legend('Histogram', sprintf('Energy mean (%2.2f dB)', 10*log10(energyMean)), sprintf('Energy median (%2.2f dB)', 10*log10(energyMedian)));
    xlabel('Nb of samples [kS]');
    ylabel('Magnitude [dB]');
    
%     figure;  plot(histogram(2:end), xn(2:end)); subplot(1,7,2:7); plot(10*log10(signalEnergy));

%     pause
% close all;
% end







%%% Close script
for iLib = 1 : length(lib),
    if exist(['./', lib{iLib}, '/'], 'dir'), 
        rmpath(genpath(['./', lib{iLib}, '/'])); 
    end
end
