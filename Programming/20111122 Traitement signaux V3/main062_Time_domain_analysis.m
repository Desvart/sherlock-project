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
    power = zeros(nFile, signalDuration*fs);
    tAxis = (0:(signalDuration*fs)-1)/fs;
    
    synchro = [23358, 17178, 41514;...
               20540, 28710, 28260;...
               10000,  4537, 32270;...
               14870, 24320,  2424]' - 2000;
           
    synchro = ones(4, 3)';
           
    
    hWaitbar2 = waitbar(0/(nFile+1), sprintf('Please wait. Processing file 1/%d...', nFile));
    for iFile = 1 : nFile,
       
        %%% Load signal
        matObj = matfile([databasePath, folderName{iFolder}, '/V1.2/', fileName{iFile}]);
        fs     = double(matObj.fs);
        signal(iFile, :) = double(matObj.signalPzt(1, synchro(iFile):synchro(iFile)+signalDuration*fs-1));

        %%% Computer power
        power(iFile, :) = running_mean(signal(iFile, :).^2, 2500, 'true');
        
        
        
        
        
        
        
        
        
        
        
        waitbar(iFile/(nFile+1), hWaitbar2, sprintf('Please wait. Processing file %d/%d...', iFile, nFile));
        
    end
    
    close(hWaitbar2);

    
    
    
    signal2 = signal;
    offset = [0, 0.2, 0.4, 1, 1.2, 1.4, 2, 2.2, 2.4, 3, 3.2, 3.4]';
    signal2 = bsxfun(@minus, signal2, offset);

    figure('Position',[0 0 fullscreen(3) fullscreen(4)], ...
              'color', 'white');
    hold on;
    
    plot(1:fs*signalDuration, signal2(1:3, :));
    plot(1:fs*signalDuration, signal2(4:6, :));
    plot(1:fs*signalDuration, signal2(7:9, :));
    plot(1:fs*signalDuration, signal2(10:12, :));

    axis tight;
    xlabel('Time [ms]');
    ylabel('Amplitude [-]');
    
    
    
%     power2 = db(power, 'voltage');
%     offset = [0, 150, 300, 500, 650, 800, 1000, 1150, 1300, 1500, 1650, 1800]';
%     power2 = bsxfun(@minus, power2, offset);
%     
%     figure('Position',[0 0 fullscreen(3) fullscreen(4)], ...
%            'color', 'white');
%     hold on;
%     
%     plot(1:fs*signalDuration, power2(1:3, :));
%     plot(1:fs*signalDuration, power2(4:6, :));
%     plot(1:fs*signalDuration, power2(7:9, :));
%     plot(1:fs*signalDuration, power2(10:12, :));
% 
%     axis tight;
%     xlabel('Time [ms]');
%     ylabel('Power magnitude [-]');

    

    
    
    
    
    
    
    
    
    
    
    
    
    waitbar(iFolder/(nFolder+1), hWaitbar, sprintf('Please wait. Processing folder %d/%d...', iFolder, nFolder));
end

close(hWaitbar);










