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


%%% Add library path

addpath('./lib/');  % project lib
addpath('./elib/'); % external lib



%% Define script variables


%%% Files and observations useful values

nObsPerFile     = 10;
nFeats          = 2;


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
 
loadRealDataBoo = false;

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
plotCarSelBoo = true;
carToKeepIdx          = [19, 20, 23, 24, 26, 27, 35, 39];


%%% Chance level computation

nLoopsToComputeChanceLevel = 200;



%% Extract global informations


%%% Plot properties

screenSize          = get(0, 'ScreenSize');
plotPosition        = [screenSize(3), 1, screenSize(3:4)];


%%% Various number of elements

fileIdxPerClassCAr  = {classE00; classE0x};
nClasses            = length(fileIdxPerClassCAr);

nFilesPerClassArray = cellfun('length', fileIdxPerClassCAr);
nFiles              = sum(nFilesPerClassArray);

nObsPerClassArray   = nFilesPerClassArray * nObsPerFile;
nObs                = sum(nObsPerClassArray);

MatFileStruct       = whos('-file', dataSetRPath);
nCaracteristics     = length(MatFileStruct);

nCaracteristicsKept = length(carToKeepIdx);



%% Load data

if loadRealDataBoo,
    
%     SSH_extract_stat; % Execute script that extract all data into the mat-file
    load(dataSetRPath);
    featureNameCArray = select_pertinent_data(dataSetRPath, eValThresh, plotCarSelBoo, nObsPerFile, fileIdxPerClassCAr);
    
else
    
    c1 = repmat(muFakeArr(1, :), [nObsPerClassArray(1), 1]) + randn(nObsPerClassArray(1), 2)*chol(sigmaFakeCAr{1});
    c2 = repmat(muFakeArr(2, :), [nObsPerClassArray(2), 1]) + randn(nObsPerClassArray(2), 2)*chol(sigmaFakeCAr{2};

    allObsCellArray2 = cat(1, c1, c2);
    % plot(c1(:,1), c1(:,2), '*b');hold on
    % plot(c2(:,1), c2(:,2), '*r');

    allObsCellArray = rand(nFiles, nObs, nFeats);
    for iFiles = 1 : nFiles,
        allObsCellArray(i, :, :) = allObsCellArray2( (iFile-1)*nObsPerFile + (1 : nObsPerFile), :);
    end
    
    nFeatsKept = 2;
end



%% Build dataset

%%% Load all observations 
if 1,






%%% Define class
% Build two matrix (nFiles x nTocs x nFeats) with all files, tocs and features. One for the
% without default class and the other for the with all default class.



%%% Generate dataset

allObsCellArray = nan(nFiles, nObsPerFile, nFeatsKept);

for iFeat = 1 : nFeatsKept,

    featValArray = eval([caracteristicNamesArr{iFeat}])'; % load caracteristic values

    for iFile = 1 : nFiles,
        for iObs = 1 : nObsPerFile,
            obsIdx2                      = (iFile-1)*nObsPerFile + iObs;
            allObsCellArray(iFile, iObs, iFeat) = featValArray(obsIdx2);
        end
    end

end
else
    % close all; clear all
    
end



%% Plot feature space

for iFile = 1 : nFiles,
    
    
end




%% Start cross-validation loop (leave-one-out scheme)


%%% Init loop

nLoops = nFiles;

fileLabelVector             = ones(nFiles, 1);
fileLabelVector(classE0x)   = 2;
obsLabelArray               = repmat(fileLabelVector, 1, nObsPerFile);
obsLabelVector              = obsLabelArray(:);

nFilesPerClassArray = nan(1, nClasses); % Prealloc.
for iClass = 1 : nClasses,
    nFilesPerClassArray(iClass) = length(find(fileLabelVector == iClass));
end

priorProbaArray = nFilesPerClassArray / nFiles;

nTFiles = 1;
nLFiles = nFiles - nTFiles;

nTObs   = nTFiles * nObsPerFile;
nLObs   = nLFiles * nObsPerFile;

fileELabelVector = nan(nLoops, 1);


%%% Start cross-validation loop

for iLoop = 1 : nLoops,
    
    fprintf('Start cross-validation loop : %d/%d\n', iLoop, nLoops);
    
    
    
    %% Create the learning and testing sets and their corresponding labels
    % Select one file to be used as the testing file for this cross-validation loop. Then all the
    % other files are used for the learning process.
    
    
    %%% Determine training and learning file and observation indexes
    
    tFileId         = iLoop;
    lFileId         = [1 : (iLoop-1), (iLoop+1) : nFiles]';

    repmatTFileId   = ((tFileId-1)*nObsPerFile) * ones(1, nObsPerFile);
    repmatLFileId   = ((lFileId-1)*nObsPerFile) * ones(1, nObsPerFile);
    tObsId          = bsxfun(@plus, repmatTFileId, 1:nObsPerFile);
    lObsId          = bsxfun(@plus, repmatLFileId, 1:nObsPerFile);
    
    
    %%% Build training and learning file and observation label vectors
    
    tFileLabel      = fileLabelVector(tFileId);
    lFileLabel      = fileLabelVector(lFileId);

    tObsLabelVector = obsLabelVector(tObsId, :);
    lObsLabelVector = obsLabelVector(lObsId, :); 

    
    %%% Create training and testing observation array
    
    tObsArray       = reshape(allObsCellArray(tFileId, :, :), nTFiles*nObsPerFile, nFeatsKept);
    lObsArray       = reshape(allObsCellArray(lFileId, :, :), nLFiles*nObsPerFile, nFeatsKept);
       
    
    
    %% Put learning and testing sets (and toc labels) in vector format and normalize them.
    % Normalization is done to avoid numerical anomalies when computing covariance matrix and its
    % inverse.
    
    
    %%% Put observation of all classes together
    
%     allLObsArray = nan(nLObs, nAllFeats); % Prealloc.
%     stopIdx      = 0;                     % Init.
%     
%     for iClass = 1 : nClasses,
%         
%         startIdx    = stopIdx + 1;
%         stopIdx     = startIdx + size(lObsCellArray{iClass}, 1) - 1;
%         
%         allLObsArray(startIdx:stopIdx, :) = lObsCellArray{iClass};
%         
%     end
    
    
    %%% Normalize learning features cloud
        
    lFeatMeanVector         = nanmean(lObsArray, 1);
    lFeatCovMatrix          = nancov( lObsArray);
    lFeatStdVector          = sqrt(diag(lFeatCovMatrix))';

    lObsMeanNormArray    = bsxfun(@minus,   lObsArray,         lFeatMeanVector);
    lObsNormArray        = bsxfun(@rdivide, lObsMeanNormArray, lFeatStdVector);
    
    
    
    %% Apply some space transformation and space reduction on feature vectors
    % In this case a simple PCA is applied and only 2 or 3 most important dimensions are kept.
    
    
    %%% Proceed to learning mapping
    
    [pcaMapping, lObsNormMapArray]  = pca(lObsNormArray);
    lObsNormMapRedArray             = lObsNormMapArray(:, 1:nFeats);
    
    
    %%% Regroup observations of same class
    
    lObsRedMapNormCellArray         = cell(1, nClasses); % Prealloc
    
    for iClass = 1 : nClasses,
        lObsRedMapNormCellArray{iClass} = lObsNormMapRedArray(lObsLabelVector == iClass);
    end
    
    
    
    %% Proceed to learning process (Bayes model)
    % For all learning files of the without default class, compute the means for each dimensions.
    % Then compute the covariance matrix. Do the same things to the learning files of the with
    % defautl class. meansClass1Vector, covClass1Array, meansClass2Vector and covClass2Array are the
    % Bayesian model.
    
    preallocMuVect      = nan(nFeats, 1);
    preallocSigmaArray  = nan(nFeats, nFeats);
    model               = struct('muVector',      {preallocMuVect,     preallocMuVect}, ...
                                 'sigmaArray',    {preallocSigmaArray, preallocSigmaArray});
    
    for iClass = 1 : nClasses,
        model(iClass).muVector      = nanmean(lObsRedMapNormCellArray{iClass});
        model(iClass).sigmaArray    = nancov( lObsRedMapNormCellArray{iClass}); 
    end
    

    
    %% Proceed to testing process
    % For each toc of the testing file, compute the discriminant function (Mahalanobis distance). 
    % Then the decision rule is to attribute the toc to the class in which it has the maximum 
    % discriminant value.
    % Do that for all toc of the testing file and then, choose to attribute the file to the class
    % where most of the tocs belong. If there is as many tocs in one class and the other, then
    % choose with the cumulative belonging probability of each toc.

    
    %%% Normalize and apply maping on testing observations
    
    tObsMeanNormArray       = bsxfun(@minus,   tObsArray,         lFeatMeanVector);
    tObsNormArray           = bsxfun(@rdivide, tObsMeanNormArray, lFeatStdVector);
    
    tObsNormMapArray        = tObsNormArray * pcaMapping';
    tObsNormMapRedArray     = tObsNormMapArray(:, 1:nFeats);
    
    
    if 1,
    %%% Determine the discriminant value for each toc of the testing file
    
    mahalanobisDistArray    = nan(nObsPerFile, nClasses); % Preallocation
    discriminantValueArray  = nan(nObsPerFile, nClasses); % Preallocation
    
    for iClass = 1 : nClasses,
        
        muVector     = model(iClass).muVector;
        sigmaArray   = model(iClass).sigmaArray;
        
        discriminantValueClassTerm = -1/2 * log(det(sigmaArray)) + log(priorProbaArray(iClass));
        
        for iObs = 1 : nObsPerFile,
            tObsMinusMeanArray                  = tObsArray(iObs, :)' - muVector;
            mahalanobisDistArray(iObs, iClass)  = tObsMinusMeanArray' * (sigmaArray \ tObsMinusMeanArray);
        end
       
        discriminantValueClassTermVector = repmat(discriminantValueClassTerm, nObsPerFile, 1);
        discriminantValueArray(:, iClass) = -1/2 * mahalanobisDistArray(:, iClass) + discriminantValueClassTermVector;
        
    end
    
    else
    %%% Determine the discriminant value for each toc of the testing file
    
    discriminantValueArray = nan(nTocsPerFile, nClasses); % Preallocation
    
    for iClass = 1 : nClasses,
        discriminantValueArray(:, iClass) = mvnpdf(tocFeatureVector, model(1).mu, model(1).sigma); 
    end
    end
    
    %%% Deduce toc estimate belonging
    
    [tocBelongingProbaVector, tocEstimateBelongingVector] = max(discriminantValueArray, [], 2);
    
    
    %%% Deduce belonging probability for the testing file
    
    nTocsBelongingToClassX = nan(1, nClasses); % Preallocation
    
    for iClass = 1 : nClasses,
        nTocsBelongingToClassX = sum(tocEstimateBelongingVector == iClass);
    end
    
    [nTocsMaxBelongingToOneClass, fileEstimateBelonging] = max(nTocsBelongingToClassX);
    if sum(nTocsBelongingToClassX == nTocsMaxBelongingToOneClass) == 1,
    % If there is no ambiguity about file class belonging
        fileELabelVector(iLoop) = fileEstimateBelonging;
    else
    % If there is an ambiguity about file class belonging, i.e. there is as many tocs belonging to
    % a class than another. In this case, it's the cumulative probability of all tocs belonging to
    % each that is used to determine the file class belonging.
        classBelongingCumProba = nan(1, nClasses); % Preallocation
        for iClass = 1 : nClasses,
            belongingProbaForThisClassVector    = ...
                                      tocBelongingProbaVector(tocEstimateBelongingVector == iClass);
            classBelongingCumProba(iClass)      = sum(belongingProbaForThisClassVector);
            [~, fileEstimateBelonging]          = max(classBelongingCumProba);
            fileELabelVector(iLoop)  = fileEstimateBelonging;
        end
    end
    
     
end % iLoop = 1 : nLoops,
    


%% Compute and display the confusion matrix
% Lines     = real class
% Columns   = estimate class belonging 

confusionMatrix = zeros(nClasses+1, nClasses+1); % Preallocation

for iFile = 1 : nFiles,

    newValue = confusionMatrix(fileLabelVector(iFile)+1, fileELabelVector(iFile)) + 1;
	confusionMatrix(fileLabelVector(iFile)+1, fileELabelVector(iFile)) = newValue;
    
end

confusionMatrix(:, end) = sum(confusionMatrix, 2);
confusionMatrix(end, :) = sum(confusionMatrix, 1);

fprintf('\nConfusion matrix:\n');
disp(confusionMatrix);



%% Compute and display accuracy estimation 

confusionMatrixNorm = confusionMatrix ./ nFiles;

% Preallocation
overallVector   = nan(1, nClasses + 1); 
kappaVector     = nan(1, nClasses + 1);
shortVector     = nan(1, nClasses + 1);
helldenVector   = nan(1, nClasses + 1);

for iClass = 1 : nClasses,
    
    pkk = confusionMatrixNorm(iClass, iClass);
    rk = sum(confusionMatrixNorm(iClass, :));
    ck = sum(confusionMatrixNorm(:, iClass));

    
    %%% Overall method
    % 
    
    overallVector(iClass) = pkk / rk;
    
    
    %%% Cohen method (Kappa value)
    % the proportion of agreement after chance agreement is removed from consideration
    % K = 0 when obtained agreement equals chance agreement. 
    % K = 1 for perfect agreement. 
    % K < 0 if obtained agreement is less than chance agreement.
    
    kappaVector(iClass) =  (pkk - rk*ck) / (ck -rk*ck);
    
    
    %%% Short method
    % Not affected by sample size
    % S = 0 for no positive matches; 
    % S = 1 for perfect agreement. 
    
    shortVector(iClass) =  pkk / (rk + ck - pkk);
    
    
    %%% Hellden method
    % Estimate of the "mean accuracy" -- the probability that a randomly chosen pixel of a 
    % specific class (k) will be properly classified    
    
    helldenVector(iClass) = 2*pkk / (rk + ck);
    
end


p0 = sum(diag(confusionMatrixNorm));
c0 = sum(confusionMatrixNorm, 1);
r0 = sum(confusionMatrixNorm, 2);
pc = c0 * r0; 

overallVector(end) = p0;
shortVector(end)   = p0 / (2 - p0);
helldenVector(end) = p0;
kappaVector(end)   = (p0 - pc) / (1 - pc);


%%% Display accuracy critera

accuracyCriteriaNameVector          = {''; 'Overall'; 'Hellden'; 'Short'; 'Kappa'};
accuracyTableHeader                 = {'', 'Without default', 'With default', 'Overall'};
nAccuracyCriterias                  = length(accuracyCriteriaNameVector);
accuracyCellMatrix                  = cell(nAccuracyCriterias, nClasses+2);

accuracyMatrix = nan(nAccuracyCriterias, nClasses + 1); % Prealloc.
for iAccuracyCriteria = 2 : nAccuracyCriterias,
    accuracyVarString                    = lower(accuracyCriteriaNameVector{iAccuracyCriteria});
    accuracyVarName                      = [accuracyVarString, 'Vector'];
    accuracyMatrix(iAccuracyCriteria, :) = eval([accuracyVarName, '(iClass)']);
end

accuracyCellMatrix(1, :)            = accuracyTableHeader;
accuracyCellMatrix(:, 1)            = accuracyCriteriaNameVector;
accuracyCellMatrix(2:end, 2:end)    = num2cell(accuracyMatrix(2:end, :));

disp(accuracyCellMatrix);



%% Compute chance level as PB showed it

for iLoop = 1 : nLoopsToComputeChanceLevel,

    
    
    %% Shuffle labels
    
    
    
    %% Test all files with shuffled labels
    
    for iFile = 1 : nFiles,
        
        
    end
    
    
    
    %% Here comes some magics
    % ??????????????????????
    
    
    
    %% Plot chance level distribution and evaluate ability of this classificator to classify 
    % correctly but not by chance
    
    
    
end



%% Save this validation process
% Save feature selection, bayesian model, confusion matrix and kappa values.



%% Clean environment

%%% Remove library path
rmpath('./lib/');   % project lib
rmpath('./elib/');  % external lib



% eof
