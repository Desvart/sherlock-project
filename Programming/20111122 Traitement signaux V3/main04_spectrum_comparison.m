%% Init script
close all;
clear all;
clc;

fullscreen = get(0,'ScreenSize');


%%% User inputs
lib = {'Lib_algo', 'Lib_UI'};
databasePath = '../../Base_de_donnees/20111100_Witschi_DB1/P02/V1.2/';
spec = {'T:1800, P:E, N6=E2++', ...
        ' ', ...
        'T:1800, P:S, N10+N12:modif. pont ancre', ...
        ' ', ...
        'T:0090, P:E, N11: E3 démarrage difficile', ...
        'T:0090, P:E+S, -', ...
        ' ', ...
        'T:1800, P:E+S, E5:complication', ...
        };
signalDuration      = 2;

%config opt
stdftN              = 1024*4;
stdftWin            = sqrt(hann(stdftN, 'periodic'));
% stdftWin            = rectwin(stdftN);
stdftShift          = 8/128;

% config fast
% stdftN              = 512/4;
% stdftWin            = sqrt(hann(stdftN, 'periodic'));
% stdftShift          = 1/4;

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


%%% Load signal
[filePathList, nFile] = load_file_path_list(databasePath);

psdH = zeros(nFile, floor(stdftN/2 + 1));
psdA = zeros(nFile, floor(stdftN/2 + 1));

hWaitbar = waitbar(1/(nFile+1), sprintf('Please wait. Processing file 1/%d...', nFile));
for iFile = 1 : nFile,
    
    %%% Load signal
    matObj = matfile(filePathList{iFile});
    fs = double(matObj.fs);
    signal = double(matObj.signalPzt(1, 1:signalDuration*fs));

    %%% Compute spectrogram
    [stdft, stdftTAxis, stdftFAxis] = stdft_(signal, stdftWin, stdftShift, fs);
    normStdft = stdft/max(max(stdft));
    
    %%% Compute Power Spectrum Density (PSD)
    psd = sum(stdft, 2);
    
    %%% Compute Power Time Density (equivalent to PSD but in time)
    ptd = sum(stdft, 1);

    %%% Keep only harmonics from spectrogram
    t = db(median(ptd/max(ptd)));
    
    normStdftH = normStdft;
    noiseLevel = median(normStdft(ceil(end/2), :));
    AttackIdx = db(ptd/max(ptd))>t/th;
    normStdftH(:, AttackIdx) = noiseLevel*ones(length(psd), sum(AttackIdx));
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
    

    waitbar(iFile/(nFile+1), hWaitbar, sprintf('Please wait. Processing file %d/%d...', iFile, nFile));
end
close(hWaitbar);


medianGrp = median(psdH, 2);
psdH = bsxfun(@minus, psdH, medianGrp);

t = {'Harmonics without known default', 'Attacks without known default',...
    'Harmonics with "Echappement non lubrifié"', 'Attacks with "Echappement non lubrifié"',...
    'Harmonics with "Spiral décentré"', 'Attacks with "Spiral décentré"',...
    'Harmonics with "Palettes sur impulsion"', 'Attacks with "Palettes sur impulsion"', ...
    'Harmonics with "Complication"', 'Attacks with "Complication"'};

hGui = figure('Position',[0 0 fullscreen(3) fullscreen(4)], ...
           'color', 'white', ...
           'Visible', printFlag);
       
annotation('textbox', 'string', [databasePath(end-7 : end-6), ' + ', spec{str2double(databasePath(end-7 : end-6))}], 'Position', [0, 0, 0.1, 0.1], 'FitBoxToText', 'on');
for i = 1 : nFile/3,
    
    subplot(nFile/3, 2, (i-1)*2 + 1);
    plot(stdftFAxis/1e3, psdH((i-1)*3+1+(0:2), :));
    
    axis tight;
    xlabel('Frequency [kHz]');
    ylabel('Energy magnitude [-]');
    title(t{(i-1)*2 + 1}, 'FontWeight','bold');
    
    subplot(nFile/3, 2, (i-1)*2 + 2);
    plot(stdftFAxis/1e3, psdA((i-1)*3+1+(0:2), :));
    
    axis tight;
    xlabel('Frequency [kHz]');
    ylabel('Energy magnitude [-]');
    title(t{(i-1)*2 + 2}, 'FontWeight','bold');
    
end

if shouldPrint == true,
    orient(hGui, 'landscape');
    print(hGui);
end

% figure;
% for i = 1 : 4,
%     
%     subplot(4, 2, (i-1)*2 + 1);
%     plot(1:floor(stdftN/2 + 1), db(psdH((i-1)*3+1+(0:2), :) + min(min(psdH((i-1)*3+1+(0:2), :)))));
%     axis tight;
%     
%     subplot(4, 2, (i-1)*2 + 2);
%     plot(1:floor(stdftN/2 + 1), db(psdA((i-1)*3+1+(0:2), :) + min(min(psdA((i-1)*3+1+(0:2), :)))));
%     axis tight;
%     
% end
