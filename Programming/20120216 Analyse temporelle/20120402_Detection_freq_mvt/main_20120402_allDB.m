% Test pour détecter la position grossière de chaque toc
% 2012.04.02 - 2012.04.02

%% Init script
close all; clear all; clc;
addpath('./Lib/');
fullscreen = get(0,'ScreenSize');
diary('./Output/globalView.txt');


%% Script param

%%% Database root path
databasePath = '../../../Base_de_donnees/20111100_Witschi_DB1/';

%%% Signal sample size to evaluate movement frequency.
sampleSize   = 5; % sec.

%%% Output flag
plotFlag = true;
dispFlag = true;


%% Loop to iterate through all files of the entire database.
[~, folderName] = extract_folder_inventory(databasePath);

regQuery = 'P01|P03|P04|P05|P06|P07|P08|P09';
regAnswer = regexp(folderName, regQuery, 'match');
folderName = [regAnswer{:}];
nFolder = length(folderName);

tic;
hWaitbar = waitbar(0/(nFolder+1), sprintf('Please wait. Processing folder 1/%d...', nFolder));
for iFolder = 1 : nFolder,
% for iFolder = 2,
   
    iFolderName = folderName{iFolder};
    [~, fileName] = extract_folder_inventory([databasePath, iFolderName, '/V1.2/']);
    %regQuery = 'E00';
    regQuery = 'P[0-9]{2}+_M[0-9]{2}+_E[0-9]{2}_N[0-9]{2}+_T[0-9]{4}+_V1.mat';
    regAnswer = regexp(fileName, regQuery, 'match');
    fileName = [regAnswer{:}];
    nFile = length(fileName);      
    
    
    
    %%% Figure 1
    if plotFlag == true,
        hFig = figure('Name',  iFolderName, ...
                      'Position',[0 0 fullscreen(3) fullscreen(4)], ...
                      'color', 'white', ...
                      'Visible', 'off');
        nLine = 6;
        nCol  = 2;
    end
    
    if dispFlag == true,
        fprintf('\n%s :\n----------------------\n', iFolderName);
    end
    
    waitbarPos = get(hWaitbar, 'position');
    hWaitbar2 = waitbar(0/(nFile+1), sprintf('Please wait. Processing file 1/%d...', nFile), 'position', waitbarPos + [0, - 2*waitbarPos(4), 0, 0]);
    for iFile = 1 : min(nFile, nLine*nCol),
%     for iFile = 9:10,

        %% Load signal
        matObj = matfile([databasePath, iFolderName, '/V1.2/', fileName{iFile}]);
        fs     = matObj.fs;
        signal = matObj.signalPzt(1, 1:sampleSize*fs);
        signal = signal ./ max(signal); % Normalisation du signal


        %% Extraction de la fréquence du signal

        %%% Calcul de l'énergie et réduction de la dynamique du bruit
        [noiseLevelDb, plotLevelDb] = SH_estimate_noise(signal);


        %%% Détection des maximum de chaque toc.
        [rawTocIdx, nToc] = SH_raw_toc_detection(signal, noiseLevelDb, fs);


        %%% Calcul de la période des tocs
        f1t = rawTocIdx(3:2:end) - rawTocIdx(1:2:end-2);
        f2t = rawTocIdx(4:2:end) - rawTocIdx(2:2:end-2);
        tm  =  floor(mean([mean(f1t), mean(f2t)])/2);
        tv  = max([std(f1t), std(f2t)]);
%         if tv/tm*100 >= 0.2,
%             error('First bloc contains an anomaly.');
%         end



        %% Disp
        if dispFlag == true,
            fprintf('Mvt #%2.0d @ %2.0f alt/s = %4.0f éch. (sigma_max = %5.0f éch.; var. = %5.2f%%) \n', iFile, fs/tm, tm, tv, tv/tm*100);
        end


        %% Plot
        if plotFlag,

            %%% Prepare signal for plot
            signal = signal(1:fs);
            timeAx = axis_(signal, fs);

            
            %%% Subplots selection
            if iFile <= nLine, iSubplot = (iFile-1)*2 + 1; end
            if iFile >  nLine, iSubplot = (iFile-6)*2; end
            subplot(nLine, nCol, iSubplot);
            
            %%% Plot
            plot(timeAx*1e3, signal);

            %%% Plot param
            axis tight;

            xlabel('Time [ms]');
            ylabel('Amplitude [-]');
            title(sprintf('Raw signal #%d (f = %2.0f alt./s, sigma = %3.0f éch.)', iFile, fs/tm, tv));

        end
        
    %%% Update waitbar
    waitbar(iFile/(nFile+1), hWaitbar2, sprintf('Please wait. Processing file %d/%d...', iFile, nFile));    
    end
    close(hWaitbar2);
    
    
    %% Save plots
    set(hFig, 'visible', 'on');
    saveas(hFig, ['./Output/mvt_freq_detection_P0', iFolderName, '.fig'],  'fig');
    saveas(hFig, ['./Output/mvt_freq_detection_P0', iFolderName, '.tiff'], 'tiffn');
    close(hFig);
    
    
%%% Update waitbar    
waitbar(iFolder/(nFolder+1), hWaitbar, sprintf('Please wait. Processing folder %d/%d...', iFolder, nFolder));
end
close(hWaitbar);

%%%
t = toc;
m = floor(t/60);
s = floor(t-m*60);
fprintf('Script executed in %d min %d sec.\n', m, s);



%% Close script
diary off;
rmpath('./Lib/');

% eof