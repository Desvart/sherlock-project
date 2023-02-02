% SPHERE - System for Perfect and Honest Element Recognition and Evaluation
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
% See also 

% Projects :
%   Main     : Sherlock Holmes II, eSherlock
%   Previous : Son des Montres I-II-III, Wavelet Watches I-II, Alarming Sounds, Iris II, Dr. Watson, 
%              Whales and Dolphins Opera I-II, Cliking Mouses, Batloc, Sherlock Holmes I
%
% © 2009-2015 Pitch Corp.
%   Build   : Matlab R2012b (8.0.0.783) x64 - Windows 7 x64
%             Matlab R2013a (8.1.0.604) x64 - Windows 7 x64
%
% History
% 11.01.b0.5604 Insert estimated best results extraction
% 10.02.b0.5603	Change how confusion matrix are handled due to a modification in 
%               cross_validation_loop function.
% 10.03.b9.5512	Export cross-validation section.
% 10.01.b0.5123 Do a learning over all relevant characteristics combination to determine the best
%               subset and so the features.
% 9.10.b0.5010  Change accuracy definition to take into account specificity and sensitivity and 
%               their respective chance level estimations.
% 9.00.b0.4521  Adaptation for Sherlcok Holmes I-II (from 5.1.b0)
% 8.00.b0.4111  Adaptation for Dr. Watson and Whales and Dolphins Opera I-II. (from 5.1.b0)
% 7.15.b0.3016  Adaptation for Iris II. (from 5.1.b0)
% 7.00.b0.2818  Adaptation for Alarming Sounds. (from 5.1.b0)
% 6.00.b0.2309  Adaptation for SDM III and Wavelet Watches I-II.
% 5.01.b0.1902  Transpose confusion matrix estimation.
% 5.00.b0.1901  Add estimation of the chance level distribution. For this, standard accuracy have
%               been used.
% 4.00.b0.1527  Add a feature selection option.
% 3.00.b0.1311  Remove cross-validation option to keep only leave-one-out strategy.
% 2.04.b6.0703  Bayesian script is operationnal. Some modifications have been done about the way
%               geatures are handle after being loaded (PCA-LDA).
% 2.00.b0.0625  Split GMM and Bayes into different scripts. There are to many differences to put
%               them together.
% 1.00.b0.0412  First functionnal version
% 0.00.a0.0000	File creation (2009.02.03)

% Notes
% COV matlab function has been checked : all green.
% PCA matlab function has been checked : all green.

% Lexicon (suffixes, prefixes)
% Feat              feature
% Char              characteristic
% Obs               observation
% L{File; Obs}      Learning file (a.k. training file) or observation
% T{File; Obs}      Testing file or observation
% n{Feat; Obs}      number of features or observations
% ELabel            estimate label
% Arr               Array
% Vec               Vector
% CAr               Cell array
% Boo               Boolean
% Thresh            Threshold
% Val               Value
% Sel               Selection



%% Init. environment


%%% Clean workspace

close all;
clear all;
clc;


%%% Configure Matlab profiler

matlabProfilerActiveBoo = false;
if matlabProfilerActiveBoo,
    profile on;
end


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


%%% Select data source

% Real data
% dataSetRPath    = './data/datasetWAP2.mat';
% outputRPath     = './data/confusionMatrixArr_WAP2.mat';
dataSetRPath    = './data/datasetCorr5.mat';
outputRPath     = './data/confusionMatrixArr_Corr5.mat';

                   
%%% Select stistically pertinent characteristics
 
% Characteristics to keep
charIdxToKeep       = [1, 4, 5, 7, 9, 10, 11, 12, 13, 21, 25, 26, 27, 28, 29, 34, 37, 38];
% charIdxToKeep       = [1, 4, 5, 6, 7, 11, 12, 13, 14, 18];

nCharMax            = length(charIdxToKeep);
nBruteForceLoops    = 2^nCharMax;



%% Brute force training (to do all relevant characteristics combinations)


%%% Preallocation

confMatEstimator        = nan(1, nBruteForceLoops);
confusionMatrixArr      = nan(2, 2, nBruteForceLoops);


%%% Init

fileIdxPerClassCAr      = {classE00; classE0x};
nFilesPerClassArr       = cellfun('length', fileIdxPerClassCAr);
nFiles                  = sum(nFilesPerClassArr);
nObsPerClassArr         = nFilesPerClassArr * nObsPerFile;

fileLabelVec            = ones(nFiles, 1);
fileLabelVec(classE0x)  = 2;

MatFileStruct           = whos('-file', dataSetRPath);
MatObj                  = matfile(dataSetRPath);

tStart                  = tic;
tStart0                 = tStart;
ticVec                  = nan(1, nBruteForceLoops);


%%% Start brute force loop
    
for iBruteForceLoop = 1 : nBruteForceLoops,
    
    
    
    %% Display processing remaining time.
    
    ticVec(iBruteForceLoop) = toc(tStart);
    tStart                  = tic();
    
    if ~mod(iBruteForceLoop, 32),    
        
        tElapse = toc(tStart0);
        etaVal  = (nanmean(ticVec) * nBruteForceLoops - tElapse);
        etaH    = floor(etaVal / 60 / 60);
        etaM    = floor(etaVal / 60) - etaH * 60;
        etaS    = floor(etaVal) - etaH * 60 * 60 - etaM * 60;
        
        fprintf('Main loop : processing iteration %d/%d (ETA: %02dH-%02dM-%02dS)...\n', ...
                                                iBruteForceLoop, nBruteForceLoops, etaH, etaM, etaS);
    end
    
    
    
    %% Build relevant characteristics subset
    
    
    %%% Convert loop index in binary mask
    
    binVec          = dec2binArr(iBruteForceLoop, nCharMax);
    maskVec         = logical(binVec);
    
    
    %%% Select characteristics to keep
    
    charIdxToKeepSel = charIdxToKeep(maskVec);
    nChars           = length(charIdxToKeepSel);
    nFeats           = nChars; % Being in a suboptimal configuration feature subspaces are not used.

  
    
    %% Load data and build dataset and build characteristics name cell array
    
    
    allObsArr = nan(nFiles, nObsPerFile, nChars); % Prealloc.

    for iChar = 1 : nChars,
    
        % string name of the current characteristic
        charKeptNameStr = MatFileStruct(charIdxToKeepSel(iChar)).name; 
        % "Load" characteristic values
        evalStr         = ['MatObj.', charKeptNameStr];
        featValArr      = eval(evalStr)'; 

        
        %%% Concevert feature saved format into a format useable by cross_validation_loop function
        
        for iFile = 1 : nFiles,
            for iObs = 1 : nObsPerFile,
                obsIdx2                       = (iFile-1)*nObsPerFile + iObs; % Saved format index
                allObsArr(iFile, iObs, iChar) = featValArr(obsIdx2);
            end
        end
        
    end



    %% Start cross-validation loop (leave-one-out scheme)

    
    confusionMatrixArr(:, :, iBruteForceLoop) = cross_validation_loop(allObsArr, fileLabelVec, nFeats);   
    
    
    %%% Save results once each 1024 process.
    
    if ~mod(iBruteForceLoop, 2^10),
        
        fprintf('Saving...\n')
        save(outputRPath, 'confusionMatrixArr');
        
    end



end % for iBruteForceLoop = 1 : nBruteForceLoop,



%% Save all learning process confusion matrix


fprintf('Saving...\n')
save(outputRPath, 'confusionMatrixArr');



%% Compare all confusion matrix by their accuracy (modified version)


%%% Normalize confusion matrix

confusionMatNormArr = confusionMatrixArr / ( sum(nObsPerClassArr) ); 


%%% Compute sensitivity and specificity (own version)

sensitivityValVec = ( confusionMatNormArr(1, 1, :) ./ sum(confusionMatNormArr(:, 1, :)) - 1 ).^2;
specificityValVec = ( confusionMatNormArr(2, 2, :) ./ sum(confusionMatNormArr(:, 2, :)) - 1 ).^2;


%%% Evaluate the confusion matrix estimator

confMatEstimatorVec = squeeze(sensitivityValVec + specificityValVec);
% plot(confMatEstimatorVec);


%%% Extract most pertinent learning sets

confMatEstimatorSortedVec   = sort(confMatEstimatorVec);
confMatEstimatorThresh      = mean(confMatEstimatorSortedVec(1:30));
eBestResultsIdVec           = find(confMatEstimatorVec < confMatEstimatorThresh);
nEBestResults               = length(eBestResultsIdVec);



%% Clean environment


%%% Remove library path

rmpath('./lib/');   % project lib
rmpath('./elib/');  % external lib


%%% Launch Matlab profiler

if matlabProfilerActiveBoo,
    profile viewer;
end



% eof
