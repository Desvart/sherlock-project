
%% SVN
    
% dbStack = dbstack();
% fileFullPathWithoutExtension = mfilename('fullpath');
% fileExtension = dbStack.file(length(dbStack.name)+1:end);
% fileFPath = [fileFullPathWithoutExtension, fileExtension];
% dateStr = datestr(now, 'yyyy.mm.dd - HH:MM:SS.FFF');
% svnRequest = ['!TortoiseProc.exe /command:commit ', ...
%               '/path:"', fileFPath, '" ', ...
%               '/logmsg:"Compilation : ', dateStr, '" ', ...
%               '/closeonend:0'];
% eval(svnRequest);


%% Init script

%%%
clear all;
close all;
clc;

%%% Add library path
addpath('./lib/');

%%% Script variables
FILE_NAME_TO_LOAD = 'visoBarilletDataset2.mat'; % Contains "datasetSignal" and "datasetToc"
VERBOSE = true;
DEBUG = true;
N_STEPS = 4;

%%% Init
% Command window script chronology informations
clockStr = datestr(clock, 'yyyy.mm.dd HH:MM:SS.FFF');
dispv('%s - Script takes control (T = 00:00:00.000).\n\n', clockStr, VERBOSE); 
mainTic = tic();
% Init script values
datasetToc = 0;
datasetSignal = 0;
iStep = 1;
% Load original datasets
load(FILE_NAME_TO_LOAD);



%%
[nObservations, nVars] = size(datasetToc);
datasetAnswer = datasetToc(nObservations, {'mvtId', 'barilletLevel', 'tocId'});

mvtIdStr = datasetAnswer.mvtId;
nMvts = str2double(mvtIdStr{1}(end-1));

nBarilletLevels = datasetAnswer.barilletLevel;

nTocs = datasetAnswer.tocId;


%%

distDegSImpSArray     = zeros(nMvts, nBarilletLevels, 4);
distImpSChuteSArray   = zeros(nMvts, nBarilletLevels, 4);
distChuteSTocEndArray = zeros(nMvts, nBarilletLevels, 4);
distDegSChuteSArray   = zeros(nMvts, nBarilletLevels, 4);
distDegSTocEndArray   = zeros(nMvts, nBarilletLevels, 4);
distChuteSChuteB1Array= zeros(nMvts, nBarilletLevels, 4);
distChuteSChuteB2Array= zeros(nMvts, nBarilletLevels, 4);
distImpSUfoSArray     = zeros(nMvts, nBarilletLevels, 4);

magDegRelArray        = zeros(nMvts, nBarilletLevels, 4);
magImpRelArray        = zeros(nMvts, nBarilletLevels, 4);
        

energyTocArray   = zeros(nMvts, nBarilletLevels, 4);
powerTocArray    = zeros(nMvts, nBarilletLevels, 4);
energyDegArray   = zeros(nMvts, nBarilletLevels, 4);
powerDegArray    = zeros(nMvts, nBarilletLevels, 4);
energyImpArray   = zeros(nMvts, nBarilletLevels, 4);
powerImpArray    = zeros(nMvts, nBarilletLevels, 4);
energyChuteArray = zeros(nMvts, nBarilletLevels, 4);
powerChuteArray  = zeros(nMvts, nBarilletLevels, 4);



for iMvt = 1 : nMvts,
    mvtId = ['ML156-0', int2str(iMvt), 'c'];

    for iBarilletLevel = 1 : nBarilletLevels,
        
        
        %% Load signal
        
        mvtRequest           = strcmp(datasetSignal.mvtId, mvtId);
        barilletLevelRequest = datasetSignal.barilletLevel == iBarilletLevel;
        dsRequest            = mvtRequest & barilletLevelRequest;
        dsAnswer             = datasetSignal(dsRequest, {'signal', 'normFactor'});
        signal               = dsAnswer.signal;
        normFactor           = dsAnswer.normFactor;

        mvtRequest           = strcmp(datasetToc.mvtId, mvtId);
        barilletLevelRequest = datasetToc.barilletLevel == iBarilletLevel;
        dsRequest            = mvtRequest & barilletLevelRequest;
        degSArray            = double(datasetToc(dsRequest, {'degS'}));
        impSArray            = double(datasetToc(dsRequest, {'impS'}));
        ufoSArray            = double(datasetToc(dsRequest, {'ufoS'}));
        chuteSArray          = double(datasetToc(dsRequest, {'chuteS'}));
        chuteB1Array         = double(datasetToc(dsRequest, {'chuteB1'}));
        chuteB2Array         = double(datasetToc(dsRequest, {'chuteB2'}));
        tocEndArray          = double(datasetToc(dsRequest, {'tocEnd'}));
        magDeg               = double(datasetToc(dsRequest, {'degRM'}));
        magImp               = double(datasetToc(dsRequest, {'impRM'}));
        magUfo               = double(datasetToc(dsRequest, {'ufoRM'}));
        isTicCellArray       = dataset2cell(datasetToc(dsRequest, {'isTic'}));
        isTicArray           = strcmp(isTicCellArray(2:end), 'Tic');
        isTacArray           = ~isTicArray;
        
        
        %% Dist degS-impS
        
        distDegSImpS = impSArray - degSArray;
        distDegSImpSArray(iMvt, iBarilletLevel, 1)      = mean(distDegSImpS(isTicArray));
        distDegSImpSArray(iMvt, iBarilletLevel, 2)      = std( distDegSImpS(isTicArray));
        distDegSImpSArray(iMvt, iBarilletLevel, 3)      = mean(distDegSImpS(isTacArray));
        distDegSImpSArray(iMvt, iBarilletLevel, 4)      = std( distDegSImpS(isTacArray));
        
        %% Dist impS-chuteS
        
        distImpSChuteS = chuteSArray - impSArray;
        distImpSChuteSArray(iMvt, iBarilletLevel, 1)    = mean(distImpSChuteS(isTicArray));
        distImpSChuteSArray(iMvt, iBarilletLevel, 2)    = std( distImpSChuteS(isTicArray));
        distImpSChuteSArray(iMvt, iBarilletLevel, 3)    = mean(distImpSChuteS(isTacArray));
        distImpSChuteSArray(iMvt, iBarilletLevel, 4)    = std( distImpSChuteS(isTacArray));
        
        
        %% Dist chuteS-tocEnd
        
        distChuteSTocEnd = tocEndArray - chuteSArray;
        distChuteSTocEndArray(iMvt, iBarilletLevel, 1)  = mean(distChuteSTocEnd(isTicArray));
        distChuteSTocEndArray(iMvt, iBarilletLevel, 2)  = std( distChuteSTocEnd(isTicArray));
        distChuteSTocEndArray(iMvt, iBarilletLevel, 3)  = mean(distChuteSTocEnd(isTacArray));        
        distChuteSTocEndArray(iMvt, iBarilletLevel, 4)  = std( distChuteSTocEnd(isTacArray));

        
        %% Dist degS-chuteS
        
        distDegSChuteS = chuteSArray - degSArray;
        distDegSChuteSArray(iMvt, iBarilletLevel, 1)    = mean(distDegSChuteS(isTicArray));
        distDegSChuteSArray(iMvt, iBarilletLevel, 2)    = std( distDegSChuteS(isTicArray));
        distDegSChuteSArray(iMvt, iBarilletLevel, 3)    = mean(distDegSChuteS(isTacArray));
        distDegSChuteSArray(iMvt, iBarilletLevel, 4)    = std( distDegSChuteS(isTacArray));
        
        
        %% Dist degS-tocEnd
        
        distDegSTocEnd = tocEndArray - degSArray;
        distDegSTocEndArray(iMvt, iBarilletLevel, 1)	= mean(distDegSTocEnd(isTicArray));
        distDegSTocEndArray(iMvt, iBarilletLevel, 2)    = std( distDegSTocEnd(isTicArray));
        distDegSTocEndArray(iMvt, iBarilletLevel, 3)    = mean(distDegSTocEnd(isTacArray));
        distDegSTocEndArray(iMvt, iBarilletLevel, 4)    = std( distDegSTocEnd(isTacArray));

        
        %% Dist chuteS-chuteB1
        
        distChuteSChuteB1 = chuteB1Array - chuteSArray;
        distChuteSChuteB1Array(iMvt, iBarilletLevel, 1)	= mean(distDegSTocEnd(isTicArray));
        distChuteSChuteB1Array(iMvt, iBarilletLevel, 2) = std( distDegSTocEnd(isTicArray));
        distChuteSChuteB1Array(iMvt, iBarilletLevel, 3) = mean(distDegSTocEnd(isTacArray));
        distChuteSChuteB1Array(iMvt, iBarilletLevel, 4) = std( distDegSTocEnd(isTacArray));
        
        
        %% Dist chuteS-chuteB2
        
        distChuteSChuteB2 = chuteB2Array - chuteSArray;
        distChuteSChuteB2Array(iMvt, iBarilletLevel, 1)	= mean(distDegSTocEnd(isTicArray));
        distChuteSChuteB2Array(iMvt, iBarilletLevel, 2) = std( distDegSTocEnd(isTicArray));
        distChuteSChuteB2Array(iMvt, iBarilletLevel, 3) = mean(distDegSTocEnd(isTacArray));
        distChuteSChuteB2Array(iMvt, iBarilletLevel, 4) = std( distDegSTocEnd(isTacArray));
        
        
        %% Dist chuteS-chuteB2
        
        distImpSUfoS = ufoSArray - impSArray;
        distImpSUfoSArray(iMvt, iBarilletLevel, 1)	= mean(distImpSUfoS(isTicArray));
        distImpSUfoSArray(iMvt, iBarilletLevel, 2)  = std( distImpSUfoS(isTicArray));
        distImpSUfoSArray(iMvt, iBarilletLevel, 3)  = mean(distImpSUfoS(isTacArray));
        distImpSUfoSArray(iMvt, iBarilletLevel, 4)  = std( distImpSUfoS(isTacArray));
        
        
        %% Toc energy
        
        signalEnergy = signal.^2;
        energyTocArray2 = zeros(1, nTocs);
        energyDegArray2 = zeros(1, nTocs);
        energyImpArray2 = zeros(1, nTocs);
        energyChuteArray2 = zeros(1, nTocs);
        for iToc = 1 : nTocs,
            % Energy/power of the all toc
            energyTocArray2(iToc) = sum(signalEnergy(degSArray(iToc):tocEndArray(iToc)));
            % Energy/power of the degagement
            energyDegArray2(iToc) = sum(signalEnergy(degSArray(iToc):impSArray(iToc)-1));
            % Energy/power of the impulsion
            energyImpArray2(iToc) = sum(signalEnergy(impSArray(iToc):chuteSArray(iToc)-1));
            % Energy/power of the chute
            energyChuteArray2(iToc) = sum(signalEnergy(chuteSArray(iToc):tocEndArray(iToc)));
        end
        
        energyTocArray(iMvt, iBarilletLevel, 1) = mean(energyTocArray2(isTicArray));
        energyTocArray(iMvt, iBarilletLevel, 2) = std( energyTocArray2(isTicArray));
        energyTocArray(iMvt, iBarilletLevel, 3) = mean(energyTocArray2(isTacArray));
        energyTocArray(iMvt, iBarilletLevel, 4) = std( energyTocArray2(isTacArray));
        
        energyDegArray(iMvt, iBarilletLevel, 1) = mean(energyDegArray2(isTicArray));
        energyDegArray(iMvt, iBarilletLevel, 2) = std( energyDegArray2(isTicArray));
        energyDegArray(iMvt, iBarilletLevel, 3) = mean(energyDegArray2(isTacArray));
        energyDegArray(iMvt, iBarilletLevel, 4) = std( energyDegArray2(isTacArray));
        
        energyImpArray(iMvt, iBarilletLevel, 1) = mean(energyImpArray2(isTicArray));
        energyImpArray(iMvt, iBarilletLevel, 2) = std( energyImpArray2(isTicArray));
        energyImpArray(iMvt, iBarilletLevel, 3) = mean(energyImpArray2(isTacArray));
        energyImpArray(iMvt, iBarilletLevel, 4) = std( energyImpArray2(isTacArray));
        
        energyChuteArray(iMvt, iBarilletLevel, 1) = mean(energyChuteArray2(isTicArray));
        energyChuteArray(iMvt, iBarilletLevel, 2) = std( energyChuteArray2(isTicArray));
        energyChuteArray(iMvt, iBarilletLevel, 3) = mean(energyChuteArray2(isTacArray));
        energyChuteArray(iMvt, iBarilletLevel, 4) = std( energyChuteArray2(isTacArray));
        
        
        
        
         %% Amplitudes
    
        magDegRelArray(iMvt, iBarilletLevel, 1) = mean(magDeg(isTicArray));
        magDegRelArray(iMvt, iBarilletLevel, 2) = std( magDeg(isTicArray));
        magDegRelArray(iMvt, iBarilletLevel, 3) = mean(magDeg(isTacArray));
        magDegRelArray(iMvt, iBarilletLevel, 4) = std( magDeg(isTacArray));

        magImpRelArray(iMvt, iBarilletLevel, 1)	= mean(magImp(isTicArray));
        magImpRelArray(iMvt, iBarilletLevel, 2)	= std( magImp(isTicArray));
        magImpRelArray(iMvt, iBarilletLevel, 3)	= mean(magImp(isTacArray));
        magImpRelArray(iMvt, iBarilletLevel, 4)	= std( magImp(isTacArray));
        
    end
    
    %% Plot
    
    
end

%  boxplot(distArray, 0.5:2:11);


%%
figure('Units', 'centimeters', 'Position', [60, 5, 25, 20], 'Color', 'white');

subplot(2, 3, 1);
titleStr = 'Distance moyenne entre le dégagement et l''impulsion';
plot_ESPS2(distDegSImpSArray/200, 'Temps [ms]', titleStr);
subplot(2, 3, 4);
titleStr = 'Energie moyenne du dégagement';
plot_ESPS2(energyDegArray, 'Energie relative [J]', titleStr);

subplot(2, 3, 2);
titleStr = 'Distance moyenne entre l''impulsion et la chute';
plot_ESPS2(distImpSChuteSArray/200, 'Temps [ms]', titleStr);
subplot(2, 3, 5);
titleStr = 'Energie moyenne de l''impulsion';
plot_ESPS2(energyImpArray, 'Energie relative [J]', titleStr);

subplot(2, 3, 3);
titleStr = 'Distance moyenne entre la chute et la fin du toc';
plot_ESPS2(distChuteSTocEndArray/200, 'Temps [ms]', titleStr);
subplot(2, 3, 6);
titleStr = 'Energie moyenne de la chute';
plot_ESPS2(energyChuteArray, 'Energie relative [J]', titleStr);


legend('1 tour de remontage - Tic', ...
       '1 tour de remontage - Tac', ...
       '2 tour de remontage', ...
       '3 tour de remontage', ...
       '4 tour de remontage', ...
       '5 tour de remontage', ...
       '6 tour de remontage', ...
       'Écart-type supérieur (1\sigma)', ...
       'Écart-type inférieur (1\sigma)');


   
%%
% figure('Units', 'centimeters', 'Position', [60, 5, 25, 20], 'Color', 'white');
% titleStr = 'Distance moyenne entre le dégagement et la chute';
% plot_ESPS2(distDegSImpSArray/200, 'Temps [ms]', titleStr);



%% Distance moyenne 1
figure('Units',    'pixels', ...
       'Position', [60, 5, 1248, 400], ...
       'Name', 'Distance moyenne 1', ...
       'Color',     'white');
   
subplot(1, 3, 1);
titleStr = 'Distance moyenne entre le dégagement et l''impulsion';
plot_ESPS2(distDegSImpSArray/200, 'Temps [ms]', titleStr);

subplot(1, 3, 2);
titleStr = 'Distance moyenne entre l''impulsion et la chute';
plot_ESPS2(distImpSChuteSArray/200, 'Temps [ms]', titleStr);

subplot(1, 3, 3);
titleStr = 'Distance moyenne entre la chute et la fin du toc';
plot_ESPS2(distChuteSTocEndArray/200, 'Temps [ms]', titleStr);



%% Distance moyenne 2
figure('Units',    'pixels', ...
       'Position', [60, 5, 1248, 400], ...
       'Name', 'Distance moyenne 2', ...
       'Color',     'white');
   
subplot(1, 3, 1);
titleStr = 'Distance moyenne entre le dégagement et l''impulsion';
plot_ESPS2(distDegSImpSArray/200, 'Temps [ms]', titleStr);

subplot(1, 3, 2);
titleStr = 'Distance moyenne entre la chute et la fin du chemin perdu';
plot_ESPS2(distChuteSChuteB1Array/200, 'Temps [ms]', titleStr);

subplot(1, 3, 3);
titleStr = 'Distance moyenne entre l''impulsion et la chute d''impulsion';
plot_ESPS2(distImpSUfoSArray/200, 'Temps [ms]', titleStr);



%% Energie

figure('Units',    'pixels', ...
       'Position', [60, 5, 1248, 400], ...
       'Name', 'Distance moyenne 2', ...
       'Color',     'white');
   
subplot(1, 3, 1);
titleStr = 'Energie moyenne du dégagement';
plot_ESPS2(energyDegArray, 'Energie relative [J]', titleStr);

subplot(1, 3, 2);
titleStr = 'Energie moyenne de l''impulsion';
plot_ESPS2(energyImpArray, 'Energie relative [J]', titleStr);

subplot(1, 3, 3);
titleStr = 'Energie moyenne de la chute';
plot_ESPS2(energyChuteArray, 'Energie relative [J]', titleStr);


%% Amplitudes


figure('Units',    'pixels', ...
       'Position', [60, 5, 1248, 400], ...
       'Name', 'Distance moyenne 2', ...
       'Color',     'white');
   
subplot(1, 3, 1);
titleStr = 'Amplitude relative moyenne du dégagement';
plot_ESPS2(magDegRelArray, 'Magnitude relative [V]', titleStr);

subplot(1, 3, 2);
titleStr = 'Amplitude relative moyenne de l''impulsion';
plot_ESPS2(magImpRelArray, 'Magnitude relative [V]', titleStr);




rmpath('./lib/');












