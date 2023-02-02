%% Init script
close all;
clear all;
clc;

fullscreen = get(0,'ScreenSize');


%%% User inputs
lib = {'Lib_algo', 'Lib_UI'};
databasePath = '../../Data/20111100_Witschi_DB1/';
signalDuration      = 2;



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
% for iFolder = 1 : nFolder,
for iFolder = 1,
   
    [~, fileName] = extract_folder_inventory([databasePath, folderName{iFolder}, '/V1.2/']);
    regQuery = 'E00';
    regQuery = 'P[0-9]{2}+_M[0-9]{2}+_E[0-9]{2}_N[0-9]{2}+_T[0-9]{4}+_V1.mat';
    regAnswer = regexp(fileName, regQuery, 'match');
    fileName = [regAnswer{:}];
    nFile = length(fileName);
    
    
    fs = 200e3;
    signal = zeros(nFile, signalDuration*fs);
    tAxis = (0:(signalDuration*fs)-1)/fs;
    
    
    
    hWaitbar2 = waitbar(0/(nFile+1), sprintf('Please wait. Processing file 1/%d...', nFile));
    for iFile = 1 : nFile,
       
        %%% Load signal
        matObj = matfile([databasePath, folderName{iFolder}, '/V1.2/', fileName{iFile}]);
        fs     = double(matObj.fs);
        signal(iFile, :) = double(matObj.signalPzt(1, 1:signalDuration*fs));

        %%%
        
        
        
        
        
        
        
        
        
        
        
        waitbar(iFile/(nFile+1), hWaitbar2, sprintf('Please wait. Processing file %d/%d...', iFile, nFile));
        
    end
    
    close(hWaitbar2);
    
    
    synchro = [23358, 17178, 41514;...
               20540, 28710, 28260;...
               10000,  4537, 32270;...
               14870, 24320,  2424] - 200;
    
    
    
%     if iFolder == 1 || iFolder == 4,
        hGui1 = figure('Position',[0 0 fullscreen(3) fullscreen(4)], ...
              'color', 'white', ...
              'Visible', printFlag);
%     end
 
    figure(hGui1);
%     subplot(3, 1, 1); 
    hold on;
%     for i = 1 : nFile,
        
    signal2 = zeros(3, fs);
    signal2(1, :) = signal(1, synchro(1, 1):synchro(1, 1)+fs-1);
    signal2(2, :) = signal(2, synchro(1, 2):synchro(1, 2)+fs-1)+0.2;
    signal2(3, :) = signal(3, synchro(1, 3):synchro(1, 3)+fs-1)+0.4;

%             plot(1:fs*2, signal(1:3, :));
%         plot(tAxis*1e3, db(signal(1:3, :)));
%         plot(1:fs*2, db(signal(1:3, :)));
%         plot(1:fs, db(signal2(1:3, :)));
        plot(1:fs, signal2(1:3, :));

        axis tight;
        xlabel('Time [ms]');
        ylabel('Normalized energy magnitude [-]');
    %     title(['Spectrum ', folderName{iFolder}], 'FontWeight','bold');
    
    
    
    %     if iFolder == 1 || iFolder == 4,
%         hGui2 = figure('Position',[0 0 fullscreen(3) fullscreen(4)], ...
%               'color', 'white', ...
%               'Visible', printFlag);
% %     end
 
%     figure(hGui2);
%     subplot(3, 1, 1); 
    hold on;
%     for i = 1 : nFile,
        
    signal2 = zeros(3, fs);
    signal2(1, :) = signal(4, synchro(2, 1):synchro(2, 1)+fs-1)-1;
    signal2(2, :) = signal(5, synchro(2, 2):synchro(2, 2)+fs-1)-1+0.2;
    signal2(3, :) = signal(6, synchro(2, 3):synchro(2, 3)+fs-1)-1+0.4;

%             plot(1:fs*2, signal(1:3, :));
%         plot(tAxis*1e3, db(signal(1:3, :)));
%         plot(1:fs*2, db(signal(1:3, :)));
%         plot(1:fs, db(signal2(1:3, :)));
        plot(1:fs, signal2(1:3, :));

        axis tight;
        xlabel('Time [ms]');
        ylabel('Normalized energy magnitude [-]');
    %     title(['Spectrum ', folderName{iFolder}], 'FontWeight','bold');
    
    
    signal2 = zeros(3, fs);
    signal2(1, :) = signal(7, synchro(3, 1):synchro(3, 1)+fs-1)-2;
    signal2(2, :) = signal(8, synchro(3, 2):synchro(3, 2)+fs-1)-2+0.2;
    signal2(3, :) = signal(9, synchro(3, 3):synchro(3, 3)+fs-1)-2+0.4;

%             plot(1:fs*2, signal(1:3, :));
%         plot(tAxis*1e3, db(signal(1:3, :)));
%         plot(1:fs*2, db(signal(1:3, :)));
%         plot(1:fs, db(signal2(1:3, :)));
        plot(1:fs, signal2(1:3, :));

        axis tight;
        xlabel('Time [ms]');
        ylabel('Normalized energy magnitude [-]');
        
        
        
    signal2 = zeros(3, fs);
    signal2(1, :) = signal(10, synchro(4, 1):synchro(4, 1)+fs-1)-3;
    signal2(2, :) = signal(11, synchro(4, 2):synchro(4, 2)+fs-1)-3+0.2;
    signal2(3, :) = signal(12, synchro(4, 3):synchro(4, 3)+fs-1)-3+0.4;

%             plot(1:fs*2, signal(1:3, :));
%         plot(tAxis*1e3, db(signal(1:3, :)));
%         plot(1:fs*2, db(signal(1:3, :)));
%         plot(1:fs, db(signal2(1:3, :)));
        plot(1:fs, signal2(1:3, :));

        axis tight;
        xlabel('Time [ms]');
        ylabel('Normalized energy magnitude [-]');
    
    
%     end


    

    
    
    
    
    
    
    
    
    
    
    
    
    waitbar(iFolder/(nFolder+1), hWaitbar, sprintf('Please wait. Processing folder %d/%d...', iFolder, nFolder));
end

close(hWaitbar);










