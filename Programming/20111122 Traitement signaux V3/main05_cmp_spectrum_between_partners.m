%% Init script
close all;
clear all;
clc;

fullscreen = get(0,'ScreenSize');


%%% User inputs
lib = {'Lib_algo', 'Lib_UI'};
databasePath = '../../Data/20111100_Witschi_DB1/';
signalDuration      = 2;

%config opt
stdftN              = 1024*4;
stdftWin            = sqrt(hann(stdftN, 'periodic'));
% stdftWin            = rectwin(stdftN);
stdftShift          = 8/128;

% config fast
% % stdftN              = 512/4;
% % stdftWin            = sqrt(hann(stdftN, 'periodic'));
% % stdftShift          = 1/4;

th = 1.5;


shouldPrint = false;
printFlag = 'on';
if shouldPrint == true;
    printFlag = 'off';
end


%%% Load library
for iLib = 1 : length(lib),
    if exist(['./', lib{iLib}, '/'], 'dir'), 
        addpath(genpath(['./', lib{iLib}, '/'])); 
    end
end


%%% Load database path
[~, folderName] = extract_folder_inventory(databasePath);

regQuery = 'P01|P02|P03|P05|P06|P08';
regAnswer = regexp(folderName, regQuery, 'match');
folderName = [regAnswer{:}];
nFolder = length(folderName);


hWaitbar = waitbar(0/(nFolder+1), sprintf('Please wait. Processing folder 1/%d...', nFolder));
for iFolder = 1 : nFolder,
   
    [~, fileName] = extract_folder_inventory([databasePath, folderName{iFolder}, '/V1.2/']);
    regQuery = 'E00';
    regQuery = 'P[0-9]{2}+_M[0-9]{2}+_E00_N[0-9]{2}+_T[0-9]{4}+_V1.mat';
    regAnswer = regexp(fileName, regQuery, 'match');
    fileName = [regAnswer{:}];
    nFile = length(fileName);
    
    
    psd  = zeros(nFile, floor(stdftN/2 + 1));
    psdH = zeros(nFile, floor(stdftN/2 + 1));
    psdA = zeros(nFile, floor(stdftN/2 + 1));
    
    hWaitbar2 = waitbar(0/(nFile+1), sprintf('Please wait. Processing file 1/%d...', nFile));
    for iFile = 1 : nFile,
       
        %%% Load signal
        matObj = matfile([databasePath, folderName{iFolder}, '/V1.2/', fileName{iFile}]);
        fs     = double(matObj.fs);
        signal = double(matObj.signalPzt(1, 1:signalDuration*fs));

        %%% Compute spectrogram
        [stdft, stdftTAxis, stdftFAxis] = stdft_(signal, stdftWin, stdftShift, fs);
        normStdft = stdft/max(max(stdft));

        %%% Compute Power Spectrum Density (PSD)
        psd(iFile, :) = sum(stdft, 2);

        %%% Compute Power Time Density (equivalent to PSD but in time)
        ptd = sum(stdft, 1);

        %%% Keep only harmonics from spectrogram
        t = db(median(ptd/max(ptd)));

        normStdftH = normStdft;
        noiseLevel = median(normStdft(ceil(end/2), :));
        AttackIdx = db(ptd/max(ptd))>t/th;
        normStdftH(:, AttackIdx) = noiseLevel*ones(length(psd(iFile, :)), sum(AttackIdx));
        o = ones(size(normStdftH));
        noiseLoc = db(normStdftH)<db(mean(normStdftH(ceil(end/2), :)))*4/5;
        normStdftH(noiseLoc) = noiseLevel*o(noiseLoc);


        %%% Keep only attack from spectrogram
        normStdftA = normStdft;
        noiseLevel = median(normStdftA(ceil(end/2), :));
        normStdftA(:, db(ptd/max(ptd))<t/th) = noiseLevel*ones(length(psd), sum(db(ptd/max(ptd))<t/th));

        %%% Compute Power Spectrum Density (PSD)
        psdH(iFile, :) = sum(normStdftH, 2);
        psdA(iFile, :) = sum(normStdftA, 2);
        
        waitbar(iFile/(nFile+1), hWaitbar2, sprintf('Please wait. Processing file %d/%d...', iFile, nFile));
    end
    close(hWaitbar2);
    
    psd = psd / max(max(psd));
    
    medianGrp = median(psdH, 2);
    psdH = bsxfun(@minus, psdH, medianGrp);
    psdH = psdH / max(max(psdH));
    
    psdM = mean(psd);
    psdS = std(psd);
    psdBU = psdM + 2*psdS;
    psdBU(psdBU<0) = zeros(1, sum(psdBU<0));
    psdBL = psdM - 2*psdS;
    psdBL(psdBL<0) = zeros(1, sum(psdBL<0));
    
    psdHM = mean(psdH);
    psdHS = std(psdH);
    psdHBU = psdHM + 2*psdHS;
    psdHBU(psdHBU<0) = zeros(1, sum(psdHBU<0));
    psdHBL = psdHM - 2*psdHS;
    psdHBL(psdHBL<0) = zeros(1, sum(psdHBL<0));
    
%     if iFolder == 1 || iFolder == 4,
%         hGui1 = figure('Position',[0 0 fullscreen(3) fullscreen(4)], ...
%               'color', 'white', ...
%               'Visible', printFlag);
%     end
%   
%     figure(hGui1);
%     subplot(3, 1, mod(iFolder-1, 3)+1); hold on;
% 
%     plot(stdftFAxis/1e3, psd');
% 
%     axis tight;
%     xlabel('Frequency [kHz]');
%     ylabel('Normalized energy magnitude [-]');
%     title(['Spectrum ', folderName{iFolder}], 'FontWeight','bold');
%     
%     if iFolder == 1 || iFolder == 4,
%         hGui11 = figure('Position',[0 0 fullscreen(3) fullscreen(4)], ...
%               'color', 'white', ...
%               'Visible', printFlag);
%     end
%   
%     figure(hGui11);
%     subplot(3, 1, mod(iFolder-1, 3)+1); hold on;
% 
%     plot(stdftFAxis/1e3, psdM);
%     plot(stdftFAxis/1e3, psdBU, ':k');
%     plot(stdftFAxis/1e3, psdBL, ':k');
% 
%     axis tight;
%     xlabel('Frequency [kHz]');
%     ylabel('Energy magnitude [-]');
%     title(['Spectrum dispersion ', folderName{iFolder}], 'FontWeight','bold');
%     legend('Moyenne spectrale', 'Ecart-type spectral (2 \sigma)');

%     if iFolder == 1 || iFolder == 4,
%         hGui2 = figure('Position',[0 0 fullscreen(3) fullscreen(4)], ...
%               'color', 'white', ...
%               'Visible', printFlag);
%     end
%   
%     figure(hGui2);
%     subplot(3, 1, mod(iFolder-1, 3)+1);   
% 
%     plot(stdftFAxis/1e3, psdH');
% 
%     axis tight;
%     xlabel('Frequency [kHz]');
%     ylabel('Normalized energy magnitude [-]');
%     title(['Spectrum - Harmonics ', folderName{iFolder}], 'FontWeight','bold');
%     
%     
    if iFolder == 1 || iFolder == 4,
        hGui11 = figure('Position',[0 0 fullscreen(3) fullscreen(4)], ...
              'color', 'white', ...
              'Visible', printFlag);
    end
  
    figure(hGui11);
    subplot(3, 1, mod(iFolder-1, 3)+1); hold on;

    plot(stdftFAxis/1e3, psdHM);
    plot(stdftFAxis/1e3, psdHBU, ':k');
    plot(stdftFAxis/1e3, psdHBL, ':k');

    axis tight;
    xlabel('Frequency [kHz]');
    ylabel('Normalized energy magnitude [-]');
    title(['Spectrum dispersion - Harmonics ', folderName{iFolder}], 'FontWeight','bold');
    legend('Moyenne spectrale', 'Ecart-type spectral (2 \sigma)');
    
    if iFolder == 1 || iFolder == 4,
        hGui3 = figure('Position',[0 0 fullscreen(3) fullscreen(4)], ...
              'color', 'white', ...
              'Visible', printFlag);
    end
  
    figure(hGui3);
    subplot(3, 1, mod(iFolder-1, 3)+1);   

    plot(stdftFAxis/1e3, psdA');

    axis tight;
    xlabel('Frequency [kHz]');
    ylabel('Energy magnitude [-]');
    title(['Spectrum - Attacks ', folderName{iFolder}], 'FontWeight','bold');
    
    waitbar(iFolder/(nFolder+1), hWaitbar, sprintf('Please wait. Processing folder %d/%d...', iFolder, nFolder));
end
close(hWaitbar);

