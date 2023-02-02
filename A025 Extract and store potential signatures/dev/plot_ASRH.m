
%% SVN
    
dbStack = dbstack();
fileFullPathWithoutExtension = mfilename('fullpath');
fileExtension = dbStack.file(length(dbStack.name)+1:end);
fileFPath = [fileFullPathWithoutExtension, fileExtension];
dateStr = datestr(now, 'yyyy.mm.dd - HH:MM:SS.FFF');
svnRequest = ['!TortoiseProc.exe /command:commit ', ...
              '/path:"', fileFPath, '" ', ...
              '/logmsg:"Compilation : ', dateStr, '" ', ...
              '/closeonend:0'];
eval(svnRequest);


%% Init script

%%%
clear all;
close all;
clc;

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

addpath('../Dependecies/');


%%
[nObservations, nVars] = size(datasetToc);
datasetAnswer = datasetToc(nObservations, {'mvtId', 'barilletLevel', 'tocId'});

mvtIdStr = datasetAnswer.mvtId;
nMvts = str2double(mvtIdStr{1}(end-1));

nBarilletLevels = datasetAnswer.barilletLevel;

nTocs = datasetAnswer.tocId;


%%

distTicMeanArray = zeros(nMvts, nBarilletLevels);
distTacMeanArray = zeros(nMvts, nBarilletLevels);
    
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
        chuteSArray          = double(datasetToc(dsRequest, {'chuteS'}));
        isTicCellArray       = dataset2cell(datasetToc(dsRequest, {'isTic'}));
        isTicCellArray(1)    = [];
        
        distTicMean = 0;
        distTacMean = 0;
        for iToc = 1 : nTocs,
            %% Load toc positions

            dist = chuteSArray(iToc) - degSArray(iToc);
            if strcmp('Tic', isTicCellArray{iToc}),
                distTicMean = distTicMean + dist/(nTocs/2);
            else
                distTacMean = distTacMean + dist/(nTocs/2);
            end

            distTicMeanArray(iMvt, iBarilletLevel) = distTicMean; 
            distTacMeanArray(iMvt, iBarilletLevel) = distTacMean;
        end
        
        
    end
    
    %% Plot
    
    
end

figure('Color', 'white'); hold on;
% bar(distTicMeanArray/200e3, 'group', 'BarWidth', 0.9, 'BaseValue',500/200e3);
% bar(distTacMeanArray/200e3, 'group', 'BarWidth', 0.5, 'BaseValue',500/200e3);
bar(distTicMeanArray/200, 'grouped', 'BarWidth', 0.9);
a = colormap('Jet');
legend('1 tour de remontage', '2 tour de remontage', '3 tour de remontage', '4 tour de remontage', '5 tour de remontage', '6 tour de remontage')
freezeColors;
bar(distTacMeanArray/200, 'grouped', 'BarWidth', 0.5, 'EdgeColor', 'r', 'LineWidth', 1);
a = a*1.4;
a(a>1)=1;
colormap(a);

allDist = [distTicMeanArray; distTacMeanArray];
ylim([min(min(allDist))-20, max(max(allDist))+20]/200);

xlabel('Id. du mouvement');
ylabel('Temps [ms]');
set(gca,'XTick',1:3, 'XTickLabel',1:3);
% legend(' ', 's', 'r','t', 'r','r','r','r', 'r','r','r','r', 'r','r','r','r')

str = {'Les barres les plus larges', 'correspondent aux tics, les', 'moins larges aux tocs.'};
annotation('textbox', [0.81 0.67, .1, .1], 'String', str);


 nowStr = datestr(clock, 'yyyy.mm.dd HH:MM:SS.FFF'); 
    dispv('\n%s - Script releases control (%s).\n', nowStr, s2hms(toc(mainTic)), VERBOSE);


%  boxplot(distTicMeanArray, 0.5:2:11);


figure('Units', 'centimeters',...
       'Position', [60, 5, 25, 25], ...
       'Color', 'white'); 
hold on;

h = stem(1-0.25:1:3.30, distTicMeanArray(:,1)/200);
set(h, 'LineWidth', 5, 'Marker', 'none', 'Color', [0, 0, 142]/255);
h = stem(1-0.22:1:3.30, distTacMeanArray(:,1)/200);
set(h, 'LineWidth', 5, 'Marker', 'square', 'Color', [0, 0, 142]/255);
set(h, 'Marker', '+', 'MarkerSize', 3, 'MarkerEdgeColor', [127, 127, 127]/255);
%%%
h = stem(1-0.15:1:3.30, distTicMeanArray(:,2)/200);
set(h, 'LineWidth', 5, 'Marker', 'none', 'Color', [0, 79, 255]/255);
h = stem(1-0.05:1:3.30, distTicMeanArray(:,3)/200);
set(h, 'LineWidth', 5, 'Marker', 'none', 'Color', [31, 255, 223]/255);
h = stem(1+0.05:1:3.30, distTicMeanArray(:,4)/200);
set(h, 'LineWidth', 5, 'Marker', 'none', 'Color', [239, 255, 15]/255);
h = stem(1+0.15:1:3.30, distTicMeanArray(:,5)/200);
set(h, 'LineWidth', 5, 'Marker', 'none', 'Color', [255, 63, 0]/255);
h = stem(1+0.25:1:3.30, distTicMeanArray(:,6)/200);
set(h, 'LineWidth', 5, 'Marker', 'none', 'Color', [127, 0, 0]/255);
%%%
h = stem(1-0.12:1:3.30, distTacMeanArray(:,2)/200);
set(h, 'LineWidth', 5, 'Marker', 'square', 'Color', [0, 79, 255]/255);
set(h, 'Marker', '+', 'MarkerSize', 3, 'MarkerEdgeColor', [127, 127, 127]/255);
h = stem(1-0.02:1:3.30, distTacMeanArray(:,3)/200);
set(h, 'LineWidth', 5, 'Marker', 'square', 'Color', [31, 255, 223]/255);
set(h, 'Marker', '+', 'MarkerSize', 3, 'MarkerEdgeColor', [127, 127, 127]/255);
h = stem(1+0.08:1:3.30, distTacMeanArray(:,4)/200);
set(h, 'LineWidth', 5, 'Marker', 'square', 'Color', [239, 255, 15]/255);
set(h, 'Marker', '+', 'MarkerSize', 3, 'MarkerEdgeColor', [127, 127, 127]/255);
h = stem(1+0.18:1:3.30, distTacMeanArray(:,5)/200);
set(h, 'LineWidth', 5, 'Marker', 'square', 'Color', [255, 63, 0]/255);
set(h, 'Marker', '+', 'MarkerSize', 3, 'MarkerEdgeColor', [127, 127, 127]/255);
h = stem(1+0.28:1:3.30, distTacMeanArray(:,6)/200);
set(h, 'LineWidth', 5, 'Marker', 'square', 'Color', [127, 0, 0]/255);
set(h, 'Marker', '+', 'MarkerSize', 3, 'MarkerEdgeColor', [127, 127, 127]/255);

ylim([min(min(allDist))-20, max(max(allDist))+20]/200);
set(gca,'XTick',1:3, 'XTickLabel',1:3);

xlabel('Id. du mouvement');
ylabel('Temps [ms]');
legend('1 tour de remontage - Tic', ...
       '1 tour de remontage - Tac', ...
       '2 tour de remontage', ...
       '3 tour de remontage', ...
       '4 tour de remontage', ...
       '5 tour de remontage', ...
       '6 tour de remontage');
   
str = 'Distance moyenne entre le dégagement et la chute';
title(str);

rmpath('../Dependecies/');












