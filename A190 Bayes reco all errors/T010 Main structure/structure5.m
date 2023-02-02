% 
%
% Script parameters :
% -
%
% Libraries needed :
% -
%
% File needed:
% - 
%
% Outputs : 
% - 
%
% See also ?

% Project : Sherlock Holmes
%
% � 2012-2015 Pitch Corp.
%   Author  : Pitch
%   Build   : Matlab R2012b (8.0.0.783) x64 - Windows 7 x64
%             Matlab R2013a (8.1.0.604) x64 - Windows 7 x64

% History
% 1.0.b0.0???	First functionnal version
% 0.1.a0.0015	Change script output
%       New output is the confusion matrix, a table contaning various accuracy indicators and the 
%       chance level of the classificator.
% 0.0.a0.0000	File creation (2013.07.10)

% Notes
% COV matlab function has been checked. All green.
% PCA matlab function has been checked. All green.

% Lexicon
% feat              feature
% car               caracteristic
% obs               observation
% L{File; Obs}      Learning file (a.k. training file) or observation
% T{File; Obs}      Testing file or observation
% n{Feat; Obs}      number of features or observations
% ELabel            estimate label
% Arr               Array
% Vec               Vector
% CAr               Cell array
% Boo               Boolean
% thresh            Threshold
% val               Value
% sel               Selection



%% Init. environment


%%% Clean workspace

close all;
clear all;
clc;

% profile on

%%% Add library path

addpath('./lib/');  % project lib
addpath('./elib/'); % external lib



%% Define script variables


%%% Files and observations useful values

nObsPerFile     = 10;
nFeats          = 15;


%%% Index of files belonging to class 'x'

classE00        = [1,2, 9,10, 17,18, 25:30];
classE01        = [3:4, 11:12, 19:20];
classE02        = [5:6, 13:14, 21:22];
classE03        = [7:8, 15:16, 23:24];
classE0x        = sort([classE01, classE02, classE03]);


%%% Caracteristics names

% caracteristicNamesArr    = ...
%     {'dist221', 'dist222', 'dist27', 'dist25', 'dist78', 'dist56', 'dist24', 'dist45', 'maxR27', ...
%      'maxR57', 'max2', 'max5', 'max7', 'maxR45', 'maxR65', 'max4', 'max6', 'std2', 'std4', ...
%      'std5', 'std6', 'std7', 'e0', 'e2', 'e4', 'e5', 'e6', 'e7', 'e8', 'e78', 'eR20', 'eR40', ...
%      'eR50', 'eR60', 'eR70', 'eR80', 'eR780', 'pit', 'nBounces'};

 
%%% Select data source
 
loadRealDataBoo = true;

% Real data
dataSetRPath    = './data/dataset.mat';

% "Fake" data
muFakeArr       = [1, 2;...
                   6, 4];
sigmaFakeCAr    = {[1.0, 0.5;  ...
                    0.5, 2.0], ...
                   [3.0, 0.5;  ...
                    0.5, 1.0]}; 

                   
%%% Select stistically pertinent caracteristics
 
% E-Value analysis
eValThresh = 1/1000;

% Caracteristics to keep
plotCarSelBoo = false;
carIdxToKeep          = [7,    10, 11, 12,         25, 26, 27, 28, 29,     37, 38];
carIdxToKeep          = [7, 9, 10, 11, 12, 13, 21, 25, 26, 27, 28, 29, 34, 37, 38];
carIdxToKeep          = [1, 4, 5, 7, 10, 11, 12, 13, 25, 27, 29, 37];
carIdxToKeep          = [1, 4, 5, 7, 9, 10, 11, 12, 13, 21, 25, 26, 27, 28, 29, 34, 37, 38];

% carIdxToKeep(logical(dec2binArr(1707, 12)))
% carIdxToKeep1(logical(dec2binArr(20811, 18)))

nCarMax = length(carIdxToKeep);
nBruteForceLoop = 2^nCarMax;


%%% Chance level computation

evaluateChanceLevelBoo      = false;
nLoopsToComputeChanceLevel  = 2500;


plotBoo = false;



    %% Extract global informations

    %%% Various number of elements

    fileIdxPerClassCAr  = {classE00; classE0x};
    nClasses            = length(fileIdxPerClassCAr);

    nFilesPerClassArr   = cellfun('length', fileIdxPerClassCAr);
    nFiles              = sum(nFilesPerClassArr);

    nObsPerClassArr     = nFilesPerClassArr * nObsPerFile;
    nObs                = sum(nObsPerClassArr);

    MatFileStruct       = whos('-file', dataSetRPath);
    nCaracteristics     = length(MatFileStruct);

    fileLabelVector             = ones(nFiles, 1);
    fileLabelVector(classE0x)   = 2;


confMatEstimator = nan(1, nBruteForceLoop);
confMat          = nan(2,2, nBruteForceLoop);

confusionMatrixArr = nan(2, 2, nBruteForceLoop);
a = nan(1, nBruteForceLoop);
% doneIteration = -1;
% parfor_progress(nBruteForceLoop);
MatObj = matfile(dataSetRPath);
MatFileStruct = whos('-file', dataSetRPath);
    tStart = tic;
    tStart0 = tStart;
    ticVec = nan(1, nBruteForceLoop);
for iBruteForceLoop = 1 : nBruteForceLoop,
%     tic
%     doneIteration = doneIteration + 1;
    ticVec(iBruteForceLoop) = toc(tStart);
    tStart = tic();
    
    if ~mod(iBruteForceLoop, 32),    
        tElapse = toc(tStart0);
        etaVal = (nanmean(ticVec) * nBruteForceLoop - tElapse);
        etaH = floor(etaVal / 60 / 60);
        etaM = floor(etaVal / 60) - etaH * 60;
        etaS = floor(etaVal) - etaH * 60 * 60 - etaM * 60;
        
%         etaMin = eta / 
        fprintf('Main loop : processing iteration %d/%d (ETA: %02dH-%02dM-%02dS)...\n', iBruteForceLoop, nBruteForceLoop, etaH, etaM, etaS);
    end
%     if ~mod(doneIteration, 32),
%         fprintf('Main loop : processing iteration %d/%d...\n', doneIteration, nBruteForceLoop);
%     end
    
    
    binVec          = dec2binArr(iBruteForceLoop, nCarMax);
    maskVec         = logical(binVec);
    carIdxToKeepSel = carIdxToKeep(maskVec);
    nCars           = length(carIdxToKeepSel);
    nFeats          = nCars;

  
    
    %% Load data and build dataset and build caracteristics name cell array

%     load(dataSetRPath);
%     MatObj = matfile(dataSetRPath);
%     MatFileStruct = whos('-file', dataSetRPath);
    
    allObsArr = nan(nFiles, nObsPerFile, nCars); % Prealloc.

    for iCar = 1 : nCars,
        
        carKeptNameStr  = MatFileStruct(carIdxToKeepSel(iCar)).name;
        evalStr = ['MatObj.', carKeptNameStr];
        featValArray    = eval(evalStr)'; % load caracteristic values

        for iFile = 1 : nFiles,
            for iObs = 1 : nObsPerFile,
                obsIdx2                      = (iFile-1)*nObsPerFile + iObs;
                allObsArr(iFile, iObs, iCar) = featValArray(obsIdx2);
            end
        end

    end



    %% Start cross-validation loop (leave-one-out scheme)

    confusionMatrixArr(:, :, iBruteForceLoop) = cross_validation_loop(allObsArr, fileLabelVector, nFeats);   
    
    if ~mod(iBruteForceLoop, 2^10),
        fprintf('Saving...\n')
        save('./data/confusionMatrixArr3.mat', 'confusionMatrixArr');
    end
%     a(iBruteForceLoop) = toc;

% parfor_progress;
end
% parfor_progress(0);


%% Save this validation process
% Save feature selection, bayesian model, confusion matrix and kappa values.




%% Clean environment

% Remove library path
rmpath('./lib/');   % project lib
rmpath('./elib/');  % external lib

% profile viewer

% eof
