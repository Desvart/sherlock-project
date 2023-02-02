%% Init script
% close all;
clear all;
clc;


%%% User inputs
lib = {'Lib_algo', 'Lib_UI'};
databasePath = '../../Data/20111100_Witschi_DB1/P05/V1/';
signalDuration      = 1;

nHistBin            = 250;
powerWinDuration    = 1.25e-3/8;

%config opt
stdftN              = 1024;
stdftWin            = sqrt(hann(stdftN, 'periodic'));
stdftShift          = 1/128;

% config fast
% stdftN              = 512;
% stdftWin            = sqrt(hann(stdftN, 'periodic'));
% stdftShift          = 1/4;


%%% Load library
for iLib = 1 : length(lib),
    if exist(['./', lib{iLib}, '/'], 'dir'), 
        addpath(genpath(['./', lib{iLib}, '/'])); 
    end
end


%%% Load signal
[filePathList, nFile] = load_file_path_list(databasePath);


% for iFile = 1 : nFile,
iFile = 1;


    %%% Load signal
    matObj = matfile(filePathList{iFile});
    fs = double(matObj.fs);
    signal = double(matObj.signalPzt(1, 1:signalDuration*fs));

    

    
    %% Time domain analysis
    
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
    signalPower = running_mean(signalEnergy, floor(fs*powerWinDuration), true);
    
    %%% Compute statistics about signal power signal
    powerMin = min(signalPower);
    powerMax = max(signalPower);
    powerDynamicRange = energyMax - energyMin;
    powerMean = mean(signalPower);
    powerMedian = median(signalPower);
    
    [powerHist, powerHistFreq] = hist(10*log10(signalPower), nHistBin);

    
    
    
    %% Spectral domain analysis
    
    %%% Compute spectrum
    [spectrum, fAxis] = dft_(signal, fs);
    
    
    %%% Split spectrum in fine structure and envelopp
    [bh, ah] = butter(8, 1/16, 'high');
    fineStruct = filtfilt(bh, ah, spectrum);
    
    [bl, al] = butter(8, 1/16, 'low');
    envelopp = filtfilt(bl, al, spectrum);
    
    %%% Compute statistics about signal power signal
    [spectrumHist, spectrumHistFreq]     = hist(spectrum, nHistBin);
    [fineStructHist, fineStructHistFreq] = hist(fineStruct, nHistBin);
    [enveloppHist, enveloppHistFreq]     = hist(envelopp, nHistBin);
    
    [spectrumHistDb, spectrumHistFreqDb]     = hist(db(spectrum), nHistBin);
    [enveloppHistDb, enveloppHistFreqDb]     = hist(db(envelopp), nHistBin);
    
    
    
    %% Bi-spectrum analysis
    
    
    
    
    %% Time-domain analysis - Spectrogram
    
    %%% Compute spectrogram
    [stdft, stdftTAxis, stdftFAxis] = stdft_(signal, stdftWin, stdftShift, fs);
    
    %%% Compute Power Spectrum Density (PSD)
    psd = sum(stdft, 2);
    
    %%% Compute Power Time Density (equivalent to PSD but in time)
    ptd = sum(stdft, 1);
  
    
    
    %% Time-domain analysis - Hilbert-Huang
    
    
    
    
    
    
    
%     %% Display 
%     fprintf('Time-domain signal\n');
%     fprintf('Signal min \t\t\t: %f\n', signalMin);
%     fprintf('Signal max \t\t\t: %f\n', signalMax);
%     fprintf('Dynamic range \t\t: %f\n', signalDynamicRange);
%     fprintf('Signal mean \t\t: %f\n', signalMean);
%     fprintf('Signal median \t\t: %f\n\n', signalMedian);
%     
%     fprintf('Signal mean (<=0) \t: %f\n', signalMeanMinus);
%     fprintf('Signal median (<=0) : %f\n\n', signalMedianMinus);
%    
%     fprintf('Signal mean (>0) \t: %f\n', signalMeanPlus);
%     fprintf('Signal median (>0)  : %f\n\n', signalMedianPlus);
%     
%     fprintf('Energy signal\n');
%     fprintf('Energy min \t\t\t: %2.1f dB\n', 10*log10(energyMin));
%     fprintf('Energy max \t\t\t: %2.1f dB\n', 10*log10(energyMax));
%     fprintf('Energy dynamic range: %2.1f dB\n', 10*log10(energyDynamicRange));
%     fprintf('Energy mean \t\t: %2.1f dB\n', 10*log10(energyMean));
%     fprintf('Energy median \t\t: %2.1f dB\n\n', 10*log10(energyMedian));
%     
%     fprintf('Power signal\n');
%     fprintf('Power min \t\t\t: %2.1f dB\n', 10*log10(powerMin));
%     fprintf('Power max \t\t\t: %2.1f dB\n', 10*log10(powerMax));
%     fprintf('Power dynamic range : %2.1f dB\n', 10*log10(powerDynamicRange));
%     fprintf('Power mean \t\t\t: %2.1f dB\n', 10*log10(powerMean));
%     fprintf('Power median \t\t: %2.1f dB\n\n', 10*log10(powerMedian));
%     
% %     fprintf('Noise level \t\t: %f dB\n\n', noiseLevel);
%     
% 
% 
% 
% 
% 
% 
% 
%     
%     
%     %% Time domain plot
%     figure('color', 'white', 'name', sprintf('Movement: %s', filePathList{iFile}(end-18-7:end-7)));
%     
%     
%     %%% Subplot [1,2] : Raw signal
%     subplot(2, 7, 2:7); hold on; 
%     
%     plot(tAxis*1e3, signal);
%     plot(tAxis*1e3, signalMeanMinus*ones(1, sSignal), '--r');
%     plot(tAxis*1e3, signalMeanPlus*ones(1, sSignal), '-.r');
%     plot(tAxis*1e3, signalMedianMinus*ones(1, sSignal), '--c');
%     plot(tAxis*1e3, signalMedianPlus*ones(1, sSignal), '-.c');
%     
%     axis tight;
%     
%     xlabel('Time [ms]');
%     ylabel('Amplitude [-]');
%     legend('Raw signal', sprintf('Negative mean (%0.3fe-3)', signalMeanMinus*1e3), sprintf('Positive mean (%0.3fe-3)', signalMeanPlus*1e3), ...
%                          sprintf('Negative median (%0.3fe-3)', signalMedianMinus*1e3), sprintf('Positive median (%0.3fe-3)', signalMedianPlus*1e3));
%     
%     
%     %%% Subplot [2,2] : Signal energy + signal power in dB 
%     subplot(2, 7, 9:14); hold on;
%     
%     energyNorm       = signalEnergy/max(signalEnergy);
%     energyMeanNorm   = energyMean/max(signalEnergy);
%     energyMedianNorm = energyMedian/max(signalEnergy);
%     
%     powerNorm        = signalPower/max(signalEnergy);
%     powerMinNorm     = powerMin/max(signalEnergy);
%     powerMeanNorm    = powerMean/max(signalEnergy);
%     powerMedianNorm  = powerMedian/max(signalEnergy);
%     
%     plot(tAxis*1e3, 10*log10(energyNorm), '.');
%     plot(tAxis*1e3, 10*log10(energyMeanNorm)*ones(1, sSignal), '--r');
%     plot(tAxis*1e3, 10*log10(energyMedianNorm)*ones(1, sSignal), '--c');
%     
%     plot(tAxis*1e3, 10*log10(powerNorm), 'r');
%     plot(tAxis*1e3, 10*log10(powerMinNorm)*ones(1, sSignal), '-.g');
%     plot(tAxis*1e3, 10*log10(powerMeanNorm)*ones(1, sSignal), '--c');
%     plot(tAxis*1e3, 10*log10(powerMedianNorm)*ones(1, sSignal), '-.c');
%     
%     axis tight;
%     ylim([10*log10(energyMedianNorm)-3, max(10*log10(signalEnergy))]);
%     
%     xlabel('Time [ms]');
%     ylabel('Normalized (to max energy) magnitude [dB]');
%     legend('Energy signal (Teager-Kaiser)', sprintf('Energy mean (%2.2f dB)', 10*log10(energyMeanNorm)), sprintf('Energy median (%2.2f dB)', 10*log10(energyMedianNorm)), ...
%             sprintf('Power signal (win = %0.2f ms ~= %d S)', powerWinDuration*1e3, floor(fs*powerWinDuration)), ...
%             sprintf('Normalized power min (%2.1f dB)', 10*log10(powerMinNorm)), ...
%             sprintf('Normalized power mean (%2.1f dB)', 10*log10(powerMeanNorm)), sprintf('Normalized power median (%2.1f dB)', 10*log10(powerMedianNorm)));
%     
%     
%     %%% Subplot [1,1] : -
%     % -
%     
%     
%     %%% Subplot [2,1] : Histogram of signal energy + signal power in dB
%     subplot(2, 7, 8); hold on;
%     
%     plot(energyHist(2:end)/1e3, energyHistFreq(2:end)-10*log10(max(signalEnergy)));
%     plot(energyHist(2:end)/1e3, 10*log10(energyMeanNorm)*ones(1, nHistBin-1), '.k');
%     plot(energyHist(2:end)/1e3, 10*log10(energyMedianNorm)*ones(1, nHistBin-1), '.c');
%     
%     plot(powerHist(2:end)/1e3, powerHistFreq(2:end)-10*log10(max(signalEnergy)), 'r');
%     plot(powerHist(2:end)/1e3, 10*log10(powerMeanNorm)*ones(1, nHistBin-1), '--k');
%     plot(powerHist(2:end)/1e3, 10*log10(powerMedianNorm)*ones(1, nHistBin-1), '--c');
%     
%     set(gca, 'XDir', 'reverse');
%     axis tight;
%     ylim([10*log10(energyMedianNorm)-3, max(10*log10(signalEnergy))]); % minus 3 dB to see the median level on graph
%     
%     xlabel('of samples [kS]');
%     ylabel('Normalized (to max energy) magnitude [dB]');
%     legend('Energy histogram', sprintf('Energy mean (%2.2f dB)', 10*log10(energyMeanNorm)), sprintf('Energy median (%2.2f dB)', 10*log10(energyMedianNorm)),...
%            'Power histogram', sprintf('Power mean (%2.2f dB)', 10*log10(powerMeanNorm)), sprintf('Power median (%2.2f dB)', 10*log10(powerMedianNorm)),...
%            'location', 'North');
%     
%     
%        
%        
%     %% Spectrum domain plot
%     figure('color', 'white', 'name', sprintf('Movement: %s', filePathList{iFile}(end-18-7:end-7)));
%     
%     %%% Subplot [1,2] : Spectrum + envelopp 
%     subplot(2, 14, 2:7); hold on;
%     
%     plot(fAxis/1e3, spectrum/max(spectrum));
%     plot(fAxis/1e3, envelopp/max(spectrum), 'r');
%     
%     axis tight;
%     xlabel('Frequency [kHz]');
% %     ylabel('Magnitude [-]');
%     legend('Spectrum', 'Spectrum envelopp', 'location', 'NorthWest');
%     title('Spectrum magnitude');
%     
% 
%     %%% Subplot [1,3] : Spectrum + envelopp in dB
%     subplot(2, 14, 8:13);hold on;
%     
%     plot(fAxis/1e3, 10*log10(spectrum/max(spectrum)));
%     plot(fAxis/1e3, 10*log10(envelopp/max(spectrum)), 'r');
% 
%     axis tight;
%     ylim([min(10*log10(envelopp/max(spectrum)))-10, 0]); % minus 10 dB to see a little behind the end of envelopp
%     
%     xlabel('Frequency [kHz]');
%     ylabel('Energy [dB]');
% %     legend('Spectrum', 'Spectrum envelopp');
%     title('Spectrum power');
%     
%     
%     %%% Subplot [2,2] : Fine structure
%     subplot(2, 14, 16:21); hold on;
%     
%     plot(fAxis/1e3, fineStruct/max(spectrum));
%     
%     axis tight;
%     xlabel('Frequency [kHz]');
% %     ylabel('Magnitude [-]');
%     legend('Spectrum fine structure', 'location', 'NorthWest');
%     
%     
%     %%% Subplot [2,3] : Fine structure in dB
%     subplot(2, 14, 22:27); hold on;
%     
%     fineStructDb = 10*log10(spectrum/max(spectrum))-10*log10(envelopp/max(spectrum));
%     
%     plot(fAxis/1e3, fineStructDb-max(fineStructDb));
%     
%     axis tight;
%     ylim([min(10*log10(envelopp/max(spectrum)))-10, 0]); % minus 3 dB to see the median level on graph
%     
%     xlabel('Frequency [kHz]');
%     ylabel('Energy [dB]');
% %     legend('Spectrum fine structure');
%     
%     
%     %%% Subplot [1,1] : histogram of spectrum + envelopp
%     subplot(2, 14, 1); hold on;
%     
%     plot(spectrumHist(3:end)/1e3, spectrumHistFreq(3:end)/max(spectrum));
%     plot(enveloppHist(3:end)/1e3, enveloppHistFreq(3:end)/max(spectrum), 'r');
%     
%     set(gca, 'XDir', 'reverse');
%     axis tight;
%     
%     xlabel('Hist [kS]');
%     ylabel('Magnitude [-]');
% %     legend('Spectrum', 'Spectrum envelopp');
%     
%     
%     %%% Subplot [1,4] : histogram of spectrum + envelopp in dB
%     subplot(2, 14, 14); hold on;
%     
%     plot(spectrumHistDb(1:end)/1e3, spectrumHistFreqDb(1:end)-db(max(spectrum)));
%     plot(enveloppHistDb(1:end)/1e3, enveloppHistFreqDb(1:end)-db(max(spectrum)), 'r');
%     
%     set(gca, 'XDir', 'reverse', 'YAxisLocation', 'right');
%     axis tight;
%     ylim([min(10*log10(envelopp/max(spectrum)))-10, 0]); % minus 10 dB to see a little behind the end of envelopp
%     
%     xlabel('Hist [kS]');
%     ylabel('Energy [dB]');
%     legend('Spectrum', 'Spectrum envelopp', 'location', 'NorthEast');
%     
%     
%     %%% Subplot [2,1] : histogram of envelopp
%     subplot(2, 14, 15);
%     
%     plot(fineStructHist(1:end)/1e3, fineStructHistFreq(1:end)/max(spectrum));
%     
%     set(gca, 'XDir', 'reverse');
%     axis tight;
%     
%     xlabel('Hist [kS]');
%     ylabel('Magnitude [-]');
% %     legend('Spectrum fine structure');
%     
%     
%     %%% Subplot [2,4] : histogram of envelopp in dB
%     subplot(2, 14, 28);
%     
%     [fineStructHistDb, fineStructHistFreqDb] = hist(fineStructDb, nHistBin);
%     plot(fineStructHistDb(1:end)/1e3, fineStructHistFreqDb(1:end)-max(fineStructHistFreqDb));
%     
%     set(gca, 'XDir', 'reverse', 'YAxisLocation', 'right');
%     axis tight;
%     ylim([min(10*log10(envelopp/max(spectrum)))-10, 0]); % minus 10 dB to see a little behind the end of envelopp
%     
%     xlabel('Hist [kS]');
%     ylabel('Energy [dB]');
%     legend('Spectrum fine structure', 'location', 'NorthEast');
%     

    %% Bi-spectrum plot

    
    
    %% Time-frequency domain plot - Spectrogram
    hGui = figure('color', 'white', 'name', sprintf('Movement: %s', filePathList{iFile}(end-18-7:end-7)));
    
    %%% Subplot [1,2] : spectrogram magnitude in dB
    subplot(6, 7, [2:7, 9:14, 16:21, 23:28, 30:35]); hold on;
    
    mesh(stdftTAxis*1e3, stdftFAxis/1e3, db(stdft/max(max(stdft)))); shading flat;
    
%     xlabel('Time [ms]');
    ylabel('Frequency [kHz]');
    title(sprintf('Spectrogram (N = %d = %2.1f ms @ fs = %d kS/s, S = 1/%d = %2.1f ms @ fs = %d kS/s)', ...
                                stdftN, stdftN/fs*1e3, fs/1e3, stdftShift^-1, stdftShift*stdftN/fs*1e3, fs/1e3));
    
    
    %%% Subplot [1,1] : Power Spectrum Densisty (PSD)
    subplot(6, 7, 1:7:29);
    
    plot(db(psd/max(psd)), stdftFAxis/1e3);
    
    set(gca, 'XDir', 'reverse');
    axis tight;
    
    xlabel('Energy [dB]');
%     ylabel('Frequency [kHz]');
    title('PSD');
    
    
    %%% Subplot [2, 1] : -
    % -
    
    
    %%% Subplot [2, 2] : Power Time Density (PTD)
    subplot(6, 7, 37:42);
    
    plot(stdftTAxis*1e3, db(ptd/max(ptd)));

    axis tight;
    
    xlabel('Time [ms]');
    ylabel('Energy [dB]');
    title('PTD');
    
    
    %% Time-frequency domain plot - Hilbert-Huang
    
    
   
    
%     pause
% close all;
% end







%% Close script
for iLib = 1 : length(lib),
    if exist(['./', lib{iLib}, '/'], 'dir'), 
        rmpath(genpath(['./', lib{iLib}, '/'])); 
    end
end
