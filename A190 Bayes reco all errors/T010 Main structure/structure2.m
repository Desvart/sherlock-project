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
% obs               observation
% L{File; Obs}      Learning file (a.k. training file) or observation
% T{File; Obs}      Testing file or observation
% n{Feat; Obs}      number of features or observations


%% Init. environment


%%% Clean workspace

close all;
clear all;
clc;


%%% Add library path

addpath('./lib/');  % project lib
addpath('./elib/'); % external lib


%%% Script variables

    dataSetRPath    = './data/dataset.mat';

    % Files and observations useful values
    nObsPerFile     = 10;
    nFeats          = 2;

    % Index of files belonging to class 'x'
    classE00        = [1,2, 9,10, 17,18, 25:30];
    classE01        = [3:4, 11:12, 19:20];
    classE02        = [5:6, 13:14, 21:22];
    classE03        = [7:8, 15:16, 23:24];
    classE0x        = sort([classE01, classE02, classE03]);

    % Caracteristics names
    caracteristicNamesArray    = ...
        {'dist221', 'dist222', 'dist27', 'dist25', 'dist78', 'dist56', 'dist24', 'dist45', 'maxR27', ...
         'maxR57', 'max2', 'max5', 'max7', 'maxR45', 'maxR65', 'max4', 'max6', 'std2', 'std4', ...
         'std5', 'std6', 'std7', 'e0', 'e2', 'e4', 'e5', 'e6', 'e7', 'e8', 'e78', 'eR20', 'eR40', ...
         'eR50', 'eR60', 'eR70', 'eR80', 'eR780', 'pit', 'nBounces'};

    % E-Value analysis
    eValueThreshold = 1/1000;

    % Caracteristics to keep
    caracteristicsToKeepIdx = [19, 20, 23, 24, 26, 27, 35, 39];

    % Chance level computation
    nLoopsToComputeChanceLevel = 200;



%% Build dataset


%%% Compute some usefull variables

% Plot properties
screenSize          = get(0, 'ScreenSize');
plotPosition        = [screenSize(3), 1, screenSize(3:4)];

% Various number of elements
fileIdxCellArray    = {classE00; classE0x};
nClasses            = length(fileIdxCellArray);
nFilesArray         = cellfun('length', fileIdxCellArray);
nFiles              = sum(nFilesArray);
nCaracteristics     = length(caracteristicNamesArray);
nCaracteristicsKept = length(caracteristicsToKeepIdx);


%%% Load all observations 

if 0,
    % Script  
    SSH_extract_stat; %#ok<UNRCH>       
end
load(dataSetRPath);


%%% Select only pertinent features (a.k. *** criterion) => statistical analysis Welch + T-test

% Prealloc. loop
obsCellArray        = cell(nClasses, 1);
nObsWNanArray       = nan(nClasses, nCaracteristics);

% Init. loop
obs2FileIdxArray    = ( 1 : 5 : (nObsPerFile/2 * nFiles) )' * ones(1, nObsPerFile/2);
obs2ObsIdxArray     = 0 : ( nObsPerFile/2 - 1 );
obs2IdxArray        = bsxfun(@plus, obs2FileIdxArray, obs2ObsIdxArray);

for iClass = 1 : nClasses,
    
    % Prealloc. loop
    obsCellArray{iClass}    = nan(nFiles*nObsPerFile, nCaracteristics);
    
    % Init. loop
    obsIdx2                 = obs2IdxArray(fileIdxCellArray{iClass}, :)';
    obsIdx2                 = obsIdx2(:);
    nObs                    = length(obsIdx2) * 2;
    
    for iCaracteristic = 1 : nCaracteristics,
        caracteristicArray                      = eval(caracteristicNamesArray{iCaracteristic});
        classCaracteristicArray                 = caracteristicArray(obsIdx2, :)';
        obsCellArray{iClass}(1:nObs, iCaracteristic) = classCaracteristicArray(:);
    end

    nObsWNanArray(iClass, :) = size(obsCellArray{iClass}, 1) - sum(isnan(obsCellArray{iClass}));
    
end

muObsArray              = cell2mat(cellfun(@nanmean, obsCellArray, 'UniformOutput', false));
sigmaObsArray           = cell2mat(cellfun(@nanstd,  obsCellArray, 'UniformOutput', false));

% Compute welch test
welchNumerator          = abs( muObsArray(1, :) - muObsArray(2, :) );
welchS1                 = ( sigmaObsArray(1, :).^2 ) ./ nObsWNanArray(1, :);
welchS2                 = ( sigmaObsArray(2, :).^2 ) ./ nObsWNanArray(2, :);
welchTest               = welchNumerator ./ sqrt( welchS1 + welchS2 );

% Compute welch degree of freedom
welchDofNumerator       = (welchS1 + welchS2).^2;
welchDofDenominator1    = (welchS1.^2) ./ (nObsWNanArray(1, :) - 1);
welchDofDenominator2    = (welchS2.^2) ./ (nObsWNanArray(2, :) - 1);
welchDof                = welchDofNumerator ./ ( welchDofDenominator1 + welchDofDenominator2 );

% Compute p-value and e-value
pValue                  = 1 - tcdf(welchTest, welchDof-1);
bonferroniFact          = max(nObsWNanArray);
eValue                  = bonferroniFact .* pValue;

% Threshold e-value for ** and *** criteria
eValueStarredIdx        = find(eValue < eValueThreshold);
eValueStarred           = eValue(eValueStarredIdx);
eValueStarredIdx2       = find(eValue < eValueThreshold*10);
eValueStarred2          = eValue(eValueStarredIdx2);


%%% Plot e-values

figure('Color',         'white', ...
       'OuterPosition', plotPosition);
hold on;
 
plot(eValueStarredIdx2, eValueStarred2*100, '*g'); 
plot(eValueStarredIdx, eValueStarred*100, '*r'); 

xLim = [1, nCaracteristics];
line(xLim, eValueThreshold*100*ones(1,2), 'Color', 'red');
line(xLim, eValueThreshold*100*10*ones(1,2), 'Color', 'green');

tickNames = caracteristicNamesArray;
for iCaracteristic = eValueStarredIdx2,
    if any(iCaracteristic == eValueStarredIdx),
        tickNames{iCaracteristic} = ['\color{red}', caracteristicNamesArray{iCaracteristic}];
    else
        tickNames{iCaracteristic} = ['\color{green}', caracteristicNamesArray{iCaracteristic}];
    end
end

xTickIdx = 1:nCaracteristics;
set(gca,'XTick', xTickIdx, 'XLim', xLim);
t = text(xTickIdx, -0.015*ones(1, length(xTickIdx)), tickNames);
set(t,  'HorizontalAlignment',  'right',    ...
        'VerticalAlignment',    'top',      ...
        'Rotation', 45);
    
ylabel('E-value [%]');

% X label (the complex way due to sub-tick label adjunction.
ext = nan(length(t), 4);
for i = 1 : length(t),
    ext(i, :) = get(t(i), 'Extent');
end
lowYPoint = min(ext(:,2));
xMidPoint = xLim(1) + abs(diff(xLim)) / 2;
tl = text(xMidPoint, lowYPoint/1.5, 'Caracteristics', ...
            'VerticalAlignment',    'top', ...
            'HorizontalAlignment',  'center');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Define features to keep
% Use statistical pertinent analysis to determine the better alone features and plot histogram of 
% each of those features. Then choose the ones which have a "gaussian" like shape.

nCaracteristicsToKeep = length(eValueStarredIdx2);
    
obsCellArray = cell(2, 1);
for iClass = 1 : nClasses,
    
    % Prealloc. & init. loop
%     prealloc = nan(nFiles*nObsPerFile, nCaracteristics);
%     classObsArray = {prealloc; prealloc};
    obsCellArray{iClass} = nan(nFilesArray(1), nCaracteristicsToKeep);
    obsIdx2 = obs2IdxArray(fileIdxCellArray{iClass}, :)';
    obsIdx2 = obsIdx2(:);
    nObs    = length(obsIdx2) * 2;
    
    for iSubCaracteristic = 1 : nCaracteristicsToKeep,
        caracteristicName = caracteristicNamesArray{eValueStarredIdx2(iSubCaracteristic)};
        caracteristicArray                      = eval(caracteristicName);
        classCaracteristicArray                 = caracteristicArray(obsIdx2, :)';
        obsCellArray{iClass}(1:nObs, iSubCaracteristic)   = classCaracteristicArray(:);
    end

end


figure('Color',         'white', ...
       'OuterPosition', plotPosition);

for iSubCaracteristic = 1 : nCaracteristicsToKeep,
    
    subplot(3, 5, iSubCaracteristic);
    hold on;
    
    [a, b] = hist(obsCellArray{1}(:, iSubCaracteristic), 20);
    [c, d] = hist(obsCellArray{2}(:, iSubCaracteristic), 20);
    
    bar(b, a, 'b', 'EdgeColor', 'none', 'BarWidth', 1);
    bar(d, c, 'r', 'EdgeColor', 'none', 'BarWidth', 0.3);
    
    title(caracteristicNamesArray{eValueStarredIdx2(iSubCaracteristic)});

end


featureNameArray = caracteristicNamesArray(caracteristicsToKeepIdx);


%%% Define class
% Build two matrix (nFiles x nTocs x nFeats) with all files, tocs and features. One for the
% without default class and the other for the with all default class.



%%% Generate dataset

allObsCellArray = nan(nFiles, nObsPerFile, nFeatsKept);

for iFeat = 1 : nFeatsKept,

    featValArray = eval([caracteristicNamesArray{iFeat}])'; % load caracteristic values

    for iFile = 1 : nFiles,
        for iObs = 1 : nObsPerFile,
            obsIdx2                      = (iFile-1)*nObsPerFile + iObs;
            allObsCellArray(iFile, iObs, iFeat) = featValArray(obsIdx2);
        end
    end

end



%% Start cross-validation loop (leave-one-out scheme)


%%% Init loop

nLoops = nFiles;

fileLabelVector             = ones(nFiles, 1);
fileLabelVector(classE00)   = 0;
obsLabelArray               = repmat(fileLabelVector, 1, nObsPerFile);
obsLabelVector              = obsLabelArray(:);

nFilesPerClassArray = nan(1, nClasses); % Prealloc.
for iClass = 1 : nClasses,
    nFilesPerClassArray(iClass) = length(find(fileLabelVector == iClass-1));
end

priorProbaArray = nFilesPerClassArray / nFiles;

nTFiles = 1;
nLFiles = nFiles - nTFiles;

nTObs   = nTFiles * nObsPerFile;
nLObs   = nLFiles * nObsPerFile;

fileEstimateBelongingVector = nan(nLoops, 1);


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
        lObsRedMapNormCellArray{iClass} = lObsNormMapRedArray(lObsLabelVector == iClass-1);
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
        nTocsBelongingToClassX = sum(tocEstimateBelongingVector == iClass-1);
    end
    
    [nTocsMaxBelongingToOneClass, fileEstimateBelonging] = max(nTocsBelongingToClassX);
    if sum(nTocsBelongingToClassX == nTocsMaxBelongingToOneClass) == 1,
    % If there is no ambiguity about file class belonging
        fileEstimateBelongingVector(iLoop) = fileEstimateBelonging;
    else
    % If there is an ambiguity about file class belonging, i.e. there is as many tocs belonging to
    % a class than another. In this case, it's the cumulative probability of all tocs belonging to
    % each that is used to determine the file class belonging.
        classBelongingCumProba = nan(1, nClasses); % Preallocation
        for iClass = 1 : nClasses,
            belongingProbaForThisClassVector    = ...
                                      tocBelongingProbaVector(tocEstimateBelongingVector == iClass-1);
            classBelongingCumProba(iClass)      = sum(belongingProbaForThisClassVector);
            [~, fileEstimateBelonging]          = max(classBelongingCumProba);
            fileEstimateBelongingVector(iLoop)  = fileEstimateBelonging;
        end
    end
    
     
end % iLoop = 1 : nLoops,
    


%% Compute and display the confusion matrix
% Lines     = real class
% Columns   = estimate class belonging 

confusionMatrix = zeros(nClasses+1, nClasses+1); % Preallocation

for iFile = 1 : nFiles,

    newValue = confusionMatrix(fileLabelVector(iFile)+1, fileEstimateBelongingVector(iFile)) + 1;
	confusionMatrix(fileLabelVector(iFile)+1, fileEstimateBelongingVector(iFile)) = newValue;
    
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
