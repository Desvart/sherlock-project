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

confMatEstimator = nan(1, 2^15);
confMat          = nan(2,2, 2^15);

% a = nan(1, 2^15);

% for iL = 1 : 2^15,
% tic
% fprintf('Start main loop : %d/%d\n', iL, 2^15);
    
% maskVec = logical(dec2binArr(iL, 15));


%% Define script variables


%%% Files and observations useful values

nObsPerFile     = 10;
nFeats          =  8;


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
dataSetRPath    = './data/datasetWAP.mat';

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
carIdxToKeep          = [7, 9, 10, 12, 13, 21, 27, 29];
carIdxToKeep          = [7, 9, 11, 12, 21, 25, 26, 27, 37];
carIdxToKeep          = [7, 9, 10, 11, 12, 21, 25, 26, 27, 29, 37, 38];
carIdxToKeep          = [7, 9, 10, 11, 12, 13, 21, 25, 26, 27, 28, 29, 34, 37, 38];
% carIdxToKeep          = [7,    10, 11,     13,     25,     27,     29,           ];
carIdxToKeep          = [1, 4, 5, 7, 10, 11, 12, 13, 25, 27, 29, 37];
carIdxToKeep          = [1, 4, 5, 7, 9, 10, 11, 12, 13, 21, 25, 26, 27, 28, 29, 34, 37, 38];
carIdxToKeep          = 1 : 19;


idVec = [173, 175, 229, 237, 2605, 10797, 10925, 2089, 2169, 2171, 2297, 2733, 6183, 6317, 6829, 10413, 10415, 10921, 11941, 15015, 15017];
idVec = [1707,3723,3755,3757,955,1181,1195,1197,1243,1453,1455,3245,3547,3725,3819,4011,3751];
idVec = [16731,20811,20827,24859,86299,94557,160071,1837,16667,16671,18219,18221,20763,20765,24923,29135,50987,51007,53599,86283,86301,86347,86349,86365,94541,94555,111931,112733,113183,113757,113759,115037,119071,180575];
idVec = [119193, 119705, 120089, 336345];

% idVec = [2^15];
% idVec = [10925];
% idVec = [1707];
idVec = [120089];
n = length(idVec);

z =  nan(2,2,n);
d = nan(1, n);
e = nan(1, n);
c = nan(1, n);
f   = nan(1, n);



for i = 1:n,
id = idVec(i);
binArr = dec2binArr(id, 15);
carIdxToKeep1          = carIdxToKeep(logical(binArr));

nFeats          = length(carIdxToKeep1);
nFeats = nFeats;
f(i) = nFeats;

%%% Chance level computation
evaluateChanceLevelBoo      = true;
nLoopsToComputeChanceLevel  = 25000;


plotBoo = true;



%% Extract global informations


%%% Plot properties

screenSize          = get(0, 'ScreenSize');
plotPosition        = [screenSize(3), 1, screenSize(3:4)];


%%% Various number of elements

fileIdxPerClassCAr  = {classE00; classE0x};
nClasses            = length(fileIdxPerClassCAr);

nFilesPerClassArr   = cellfun('length', fileIdxPerClassCAr);
nFiles              = sum(nFilesPerClassArr);

nObsPerClassArr     = nFilesPerClassArr * nObsPerFile;
nObs                = sum(nObsPerClassArr);

MatFileStruct       = whos('-file', dataSetRPath);
nCaracteristics     = length(MatFileStruct);

nCarKept            = length(carIdxToKeep1);



%% Load data and build dataset

if loadRealDataBoo == true,
    
%     SSH_extract_stat; % Execute script that extract all data into the mat-file
    load(dataSetRPath);
    carNameCAr = select_pertinent_caracteristics(dataSetRPath, eValThresh, plotCarSelBoo, nObsPerFile, fileIdxPerClassCAr);
    carKeptNameCAr = carNameCAr(carIdxToKeep1); 
    
    allObsArr = nan(nFiles, nObsPerFile, nCarKept);

    for iCar = 1 : nCarKept,

        featValArray = eval([carKeptNameCAr{iCar}])'; % load caracteristic values

        for iFile = 1 : nFiles,
            for iObs = 1 : nObsPerFile,
                obsIdx2                      = (iFile-1)*nObsPerFile + iObs;
                allObsArr(iFile, iObs, iCar) = featValArray(obsIdx2);
            end
        end

    end
    
else
nFeats = 2;
    g{1} = repmat(muFakeArr(1, :), [nObsPerClassArr(1), 1]) + randn(nObsPerClassArr(1), 2)*chol(sigmaFakeCAr{1});
    g{2} = repmat(muFakeArr(2, :), [nObsPerClassArr(2), 1]) + randn(nObsPerClassArr(2), 2)*chol(sigmaFakeCAr{2});

%     allObsArr2 = cat(1, c1, c2);
    % plot(c1(:,1), c1(:,2), '*b');hold on
    % plot(c2(:,1), c2(:,2), '*r');

    allObsArr = rand(nFiles, nObsPerFile, nFeats);
    for iClass = 1 : nClasses,
        i  = 0;
        for iFile = fileIdxPerClassCAr{iClass},
            i = i + 1;
%             allObsCAr(iFile, :, :) = allObsArr2( (iFile-1)*nObsPerFile + (1 : nObsPerFile), :);
            allObsArr(iFile, :, :) = g{iClass}( (i-1)*nObsPerFile + (1 : nObsPerFile), :);
        end
    end
    
    nCarKept = 2;
    carKeptNameCAr = {'fakeCar1', 'fakeCar2'};
end



%% Plot feature space
if plotBoo, 
screenSize          = get(0, 'ScreenSize');
plotPosition        = [screenSize(3), 1, screenSize(3:4)];
figure('Color',         'white', ...
       'OuterPosition', plotPosition);



classTag= 'xx';
col='rb';
for iCar = 1 : nCarKept,     

%     axesXPos = 1.5/100;
%     axesYPos = ((iCar-1)*(100/nCarKept) + 1.5 ) / 100;
%     axesW    = 80 / 100; 
%     axesH    = (100/nCarKept - 1.5) / 100;
%     axes('Position', [axesXPos, axesYPos, axesW, axesH]);
%     hold on;
    
    axesXPos = ((iCar-1)*(100/nCarKept) + 1.5 ) / 100;
    axesYPos = (20-1.5) / 100;
    axesW    = (100/nCarKept - 1.5) / 100; 
    axesH    = 80 / 100;
    axes('Position', [axesXPos, axesYPos, axesW, axesH]); %#ok<LAXES>
    hold on;
            
    for iClass = 1 : nClasses,
        for iFile = fileIdxPerClassCAr{iClass},    
            
%             plot(iFile*ones(1, nObsPerFile), allObsCAr(iFile, :, iCar), [col(iClass), classTag(iClass)]);
            plot(allObsArr(iFile, :, iCar), iFile*ones(1, nObsPerFile), [col(iClass), classTag(iClass)]);
            
        end
    end
    
    axis tight;
    ylim([0, nFiles + 1]);
    
end

for iCar = 1 : nCarKept,
   
    axesXPos = ((iCar-1)*(100/nCarKept) + 1.5 ) / 100;
    axesYPos = (2) / 100;
    axesW    = (100/nCarKept - 2) / 100; 
    axesH    = 10 / 100;
    axes('Position', [axesXPos, axesYPos, axesW, axesH]); %#ok<LAXES>
    hold on;
    
    carRange = [min(min(min(allObsArr(:, :, iCar)))), ...
                    max(max(max(allObsArr(:, :, iCar))))];
    nGauss   = carRange(1) : (carRange(2)-carRange(1))/10000 : carRange(2);
                
    for iClass = 1 : nClasses,
        carForThisClassArr = allObsArr(fileIdxPerClassCAr{iClass}, :, iCar);
        carForThisClassVec = carForThisClassArr(:);
        
        mean1Vec = nanmean(carForThisClassVec);
        std1  = nanstd(carForThisClassVec);
        
        pdf1 = normpdf(nGauss, mean1Vec, std1);
        pdf1 = pdf1/max(pdf1);
        
        plot(carForThisClassVec, iClass*ones(1, nObsPerClassArr(iClass)), [col(iClass), classTag(iClass)]);
        plot(nGauss, pdf1 + iClass, col(iClass));
    end
    
    axis tight;
    ylim([0, nClasses + 1.1]);
    title(carKeptNameCAr{iCar});

end



screenSize          = get(0, 'ScreenSize');
plotPosition        = [screenSize(3), 1, screenSize(3:4)];
figure('Color',         'white', ...
       'OuterPosition', plotPosition);

col = 'rb';
   
for iCar1 = 2 : nCarKept,
    for iCar2 = 1 : iCar1-1,
    
        axesW    = (100/(nCarKept-1) - 2) / 100; 
        axesH    = 10 / 100;
        
        axesXPos = ((iCar1-2)*(100/(nCarKept-1)) + 1.5 ) / 100;
        axesYPos = (100 - (iCar2-1)*(100/(nCarKept-1)) - (axesH*100 + 2.5)) / 100;
%         ((nCarKept-1-(iCar2-1))*(100/(nCarKept-1)) + 1.5 ) / 100;
        
        axes('Position', [axesXPos, axesYPos, axesW, axesH]); %#ok<LAXES>
        hold on;

%         carRange = [min(min(min(allObsArr(:, :, iCar)))), ...
%                         max(max(max(allObsArr(:, :, iCar))))];
%         nGauss   = carRange(1) : (carRange(2)-carRange(1))/10000 : carRange(2);

        for iClass = 1 : nClasses,
            car1ForThisClassArr = allObsArr(fileIdxPerClassCAr{iClass}, :, iCar1);
            car1ForThisClassVec = car1ForThisClassArr(:);
            car2ForThisClassArr = allObsArr(fileIdxPerClassCAr{iClass}, :, iCar2);
            car2ForThisClassVec = car2ForThisClassArr(:);
            
            cloudArr = [car1ForThisClassVec, car2ForThisClassVec];
            
            meanVec = nanmean(cloudArr);
            covArr  = nancov(cloudArr);

            plot(cloudArr(:, 1), cloudArr(:, 2), [col(iClass), classTag(iClass)]);
            plot(meanVec(1), meanVec(2), ['g', classTag(iClass)]);
            hEll = plot_gaussian_ellipsoid(meanVec, covArr);
            set(hEll, 'Color', 'red');
        end

        axis tight;
%         ylim([0, nClasses + 1.1]);
        titleStr = sprintf('%s - %s (%d-%d)', carKeptNameCAr{iCar1}, carKeptNameCAr{iCar2}, iCar1, iCar2);
        title(titleStr);
        
    end
end



% 
% figure;
% hold on;
% a = allObsArr(fileIdxPerClassCAr{1}, :, 1);
% b = allObsArr(fileIdxPerClassCAr{1}, :, 2);
% plot(a(:), b(:), '*r');
% 
% a = allObsArr(fileIdxPerClassCAr{2}, :, 1);
% b = allObsArr(fileIdxPerClassCAr{2}, :, 2);
% plot(a(:), b(:), 'ob');

end

%% Start cross-validation loop (leave-one-out scheme)


%%% Init loop

nLoops = nFiles;

fileLabelVector             = ones(nFiles, 1);
fileLabelVector(classE0x)   = 2;
obsLabelArray               = repmat(fileLabelVector, 1, nObsPerFile)';
obsLabelVector              = obsLabelArray(:);

nFilesPerClassArr = nan(1, nClasses); % Prealloc.
for iClass = 1 : nClasses,
    nFilesPerClassArr(iClass) = length(find(fileLabelVector == iClass));
end

priorProbaArray = nFilesPerClassArr / nFiles;

nTFiles = 1;
nLFiles = nFiles - nTFiles;

nTObs   = nTFiles * nObsPerFile;
nLObs   = nLFiles * nObsPerFile;

fileELabelVector = nan(nLoops, 1);


%%% Start cross-validation loop
fprintf('Start cross-validation loop (#%d) :\n', nLoops);
for iLoop = 1 : nLoops,
    
    if iLoop ~= nLoops,
        fprintf('%2.0d - ', iLoop);
        if ~mod(iLoop , 10),
            fprintf('\n');
        end
    else
        fprintf('%2.0d\n ', iLoop);
    end
    
    
    
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
    
    tObsArray       = reshape(allObsArr(tFileId, :, :), nTFiles*nObsPerFile, nCarKept);
    lObsArray       = reshape(allObsArr(lFileId, :, :), nLFiles*nObsPerFile, nCarKept);
       
    
    
    %% Put learning and testing sets (and toc labels) in vector format and normalize them.
    % Normalization is done to avoid numerical anomalies when computing covariance matrix and its
    % inverse.
    
    %%% Normalize learning features cloud
        
    lFeatMeanVector         = nanmean(lObsArray, 1);
    lFeatCovMatrix          = nancov( lObsArray);
    lFeatStdVector          = sqrt(diag(lFeatCovMatrix))';

    lObsMeanNormArray       = bsxfun(@minus,   lObsArray,         lFeatMeanVector);
    lObsNormArray           = bsxfun(@rdivide, lObsMeanNormArray, lFeatStdVector);
    
    
    
    %% Apply some space transformation and space reduction on feature vectors
    % In this case a simple PCA is applied and only 2 or 3 most important dimensions are kept.
    
    
    %%% Proceed to learning mapping
    
%     [pcaMapping, lObsNormMapArray]  = pca(lObsNormArray);
    
%     covMat = lObsNormArray'*lObsNormArray/(nLObs-1); % Compute covariance matrix of the feature matrix
    covMat = nancov(lObsNormArray);
    [eigenVec, eigenVal] = eig(covMat);  % Eigen analysis of feature covariance matrix
    eigenVal = diag(eigenVal);
    norm = diag(1./sqrt(eigenVal(end : -1 : end-nFeats+1))); % Normalize basis matrix
    pcaMappingMat = norm*eigenVec(:, end : -1 : end-nFeats+1)'; % Compute basis matrix

    lObsNormMapRedArray = lObsNormArray * pcaMappingMat'; % Feature projection on new basis
    
    
    
%     lObsNormMapRedArray             = lObsNormMapArray(:, 1:nFeats);
    
    
    %%% Regroup observations of same class
    
    lObsRedMapNormCellArray         = cell(1, nClasses); % Prealloc
    
    for iClass = 1 : nClasses,
        lObsRedMapNormCellArray{iClass} = lObsNormMapRedArray(lObsLabelVector == iClass, :);
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
    
    tObsNormMapArray        = tObsNormArray * pcaMappingMat';
    tObsNormMapRedArray     = tObsNormMapArray(:, 1:nFeats);
    
    
    
    %% Determine the discriminant value for each toc of the testing file
    
    mahalanobisDistArray    = nan(nObsPerFile, nClasses); % Preallocation
    discriminantValueArray  = nan(nObsPerFile, nClasses); % Preallocation
    
    for iClass = 1 : nClasses,
        
        muVector     = model(iClass).muVector;
        sigmaArray   = model(iClass).sigmaArray;
        
        discriminantValueClassTerm = -1/2 * log(det(sigmaArray)) + log(priorProbaArray(iClass));
        
        tObsMinusMeanArray = bsxfun(@minus, tObsNormMapRedArray, muVector);
        for iObs = 1 : nObsPerFile,
%             tObsMinusMeanArray                  = tObsArray(iObs, :)' - muVector;
            tObsMinusMean = tObsMinusMeanArray(iObs, :);
            mahalanobisDistArray(iObs, iClass)  = tObsMinusMean * (sigmaArray \ tObsMinusMean');
        end
       
        discriminantValueClassTermVector = repmat(discriminantValueClassTerm, nObsPerFile, 1);
        discriminantValueArray(:, iClass) = -1/2 * mahalanobisDistArray(:, iClass) + discriminantValueClassTermVector;
        
    end
    
    
    %%% Deduce toc estimate belonging
    
    [tocBelongingProbaVector, tocEstimateBelongingVector] = max(discriminantValueArray, [], 2);
    
    
    %%% Deduce belonging probability for the testing file
    
    nTocsBelongingToClassX = nan(1, nClasses); % Preallocation
    
    for iClass = 1 : nClasses,
        nTocsBelongingToClassX(iClass) = sum(tocEstimateBelongingVector == iClass);
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

confusionMatrix1 = zeros(nClasses+1, nClasses+1); % Preallocation

for iFile = 1 : nFiles,

    newValue = confusionMatrix1(fileLabelVector(iFile), fileELabelVector(iFile)) + 1;
	confusionMatrix1(fileLabelVector(iFile), fileELabelVector(iFile)) = newValue;
    
end

confusionMatrix1(:, end) = sum(confusionMatrix1, 2);
confusionMatrix1(end, :) = sum(confusionMatrix1, 1);

%%% Compute estimator of confusion matrix performance
% Cf. GS methods

a1 = (confusionMatrix1(1, 1) / sum(confusionMatrix1(:, 1)) * nObsPerClassArr(2) / nObs - 1/nClasses)^2;
a2 = (confusionMatrix1(2, 2) / sum(confusionMatrix1(:, 2)) * nObsPerClassArr(1) / nObs - 1/nClasses)^2;

confMatEstimator = a1 + a2;

fprintf('\nConfusion matrix:\n');
disp(confusionMatrix1);
fprintf('\nConfusion matrix estimator:\n');
disp(confMatEstimator);

% fprintf('\nLoop %d/%d:\n', iL, 2^15);





% 
% %%% Compute estimator of confusion matrix performance
%     % Cf. GS methods
%     
%     % Virtualy equilibrate confusion matrix
%     confusionMatEquilArr = bsxfun(@times, confusionMatArr,  nObsPerClassArr(end:-1:1)');
%         
%     % Normalize confusion matrix
%     confusionMatEquilNormArr = confusionMatEquilArr / ( 2*prod(nObsPerClassArr) );
% 
%     % Compute positive and negative predictive values
%     positivePredictVal = (confusionMatEquilNormArr(1, 1) / sum(confusionMatEquilNormArr(:, 1)) - 1)^2;
%     negativePredictVal = (confusionMatEquilNormArr(2, 2) / sum(confusionMatEquilNormArr(:, 2)) - 1)^2;
% 
%     % Weighted positive and negative predictive values by probability that those value could be
%     % random
%     positivePredictValWeighted = positivePredictVal + 0.5^2*(garbageProba(1));
%     negativePredictValWeighted = negativePredictVal + 0.5^2*(garbageProba(2));
%     
%     % Evaluate the confusion matrix estimator
%     confMatEstimator(iBruteForceLoop)    = positivePredictValWeighted + negativePredictValWeighted;
%     allConfMatArr(:,:,iBruteForceLoop)   = confusionMatArr(1:2, 1:2);
% 






%% Compute and display accuracy estimation 

confusionMatrixNorm = confusionMatrix1 ./ nFiles;

% Preallocation
overallVector   = nan(1, nClasses + 1); 
kappaVector     = nan(1, nClasses + 1);
shortVector     = nan(1, nClasses + 1);
helldenVector   = nan(1, nClasses + 1);

for iClass = 1 : nClasses,
    
    pkk = confusionMatrixNorm(iClass, iClass);
    rk = sum(confusionMatrixNorm(iClass, 1:nClasses));
    ck = sum(confusionMatrixNorm(1:nClasses, iClass));

    
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


p0 = sum(diag(confusionMatrixNorm(1:end-1, 1:end-1)));
c0 = sum(confusionMatrixNorm(1:end-1, 1:end-1), 1);
r0 = sum(confusionMatrixNorm(1:end-1, 1:end-1), 2);
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
accuracyVec = nan(1, nLoopsToComputeChanceLevel);
accuracyC1 = nan(1, nLoopsToComputeChanceLevel);
accuracyC2 = nan(1, nLoopsToComputeChanceLevel);
if evaluateChanceLevelBoo,
% matlabpool
parfor iChanceLevelLoop = 1 : nLoopsToComputeChanceLevel,
    
fprintf('Start chance-level evaluation : %d/%d\n', iChanceLevelLoop, nLoopsToComputeChanceLevel);

    %%% Start cross-validation loop (leave-one-out scheme)


    %%% Init loop

    nLoops = nFiles;

    fileLabelVector             = ones(nFiles, 1);
    fileLabelVector(classE0x)   = 2;
    obsLabelArray               = repmat(fileLabelVector, 1, nObsPerFile)';
    obsLabelVector              = obsLabelArray(:);
    
    %%% Randomly permute labels
    obsRandIdxVec               = randperm(nObs);
    obsLabelVector              = obsLabelVector(obsRandIdxVec);

    nFilesPerClassArr = nan(1, nClasses); % Prealloc.
    for iClass = 1 : nClasses,
        nFilesPerClassArr(iClass) = length(find(fileLabelVector == iClass));
    end

    priorProbaArray = nFilesPerClassArr / nFiles;

    nTFiles = 1;
    nLFiles = nFiles - nTFiles;

    nTObs   = nTFiles * nObsPerFile;
    nLObs   = nLFiles * nObsPerFile;

    fileELabelVector = nan(nLoops, 1);


    %%% Start cross-validation loop
    fprintf('Start cross-validation loop (#%d) :\n', nLoops);
    for iLoop = 1 : nLoops,
        
%         if iLoop ~= nLoops,
%             fprintf('%2.0d - ', iLoop);
%             if ~mod(iLoop , 10),
%                 fprintf('\n');
%             end
%         else
%             fprintf('%2.0d\n ', iLoop);
%         end


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

        tObsArray       = reshape(allObsArr(tFileId, :, :), nTFiles*nObsPerFile, nCarKept);
        lObsArray       = reshape(allObsArr(lFileId, :, :), nLFiles*nObsPerFile, nCarKept);



        %% Put learning and testing sets (and toc labels) in vector format and normalize them.
        % Normalization is done to avoid numerical anomalies when computing covariance matrix and its
        % inverse.

        %%% Normalize learning features cloud

        lFeatMeanVector         = nanmean(lObsArray, 1);
        lFeatCovMatrix          = nancov( lObsArray);
        lFeatStdVector          = sqrt(diag(lFeatCovMatrix))';

        lObsMeanNormArray       = bsxfun(@minus,   lObsArray,         lFeatMeanVector);
        lObsNormArray           = bsxfun(@rdivide, lObsMeanNormArray, lFeatStdVector);



        %% Apply some space transformation and space reduction on feature vectors
        % In this case a simple PCA is applied and only 2 or 3 most important dimensions are kept.


        %%% Proceed to learning mapping

%         [pcaMapping, lObsNormMapArray]  = pca(lObsNormArray);
%         lObsNormMapRedArray             = lObsNormMapArray(:, 1:nFeats);
        
        covMat = nancov(lObsNormArray);
        [eigenVec, eigenVal] = eig(covMat);  % Eigen analysis of feature covariance matrix
        eigenVal = diag(eigenVal);
        norm = diag(1./sqrt(eigenVal(end : -1 : end-nFeats+1))); % Normalize basis matrix
        pcaMappingMat = norm*eigenVec(:, end : -1 : end-nFeats+1)'; % Compute basis matrix


        %%% Regroup observations of same class

        lObsRedMapNormCellArray         = cell(1, nClasses); % Prealloc

        for iClass = 1 : nClasses,
            lObsRedMapNormCellArray{iClass} = lObsNormMapRedArray(lObsLabelVector == iClass, :);
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

        tObsNormMapArray        = tObsNormArray * pcaMappingMat';
        tObsNormMapRedArray     = tObsNormMapArray(:, 1:nFeats);


        %% Determine the discriminant value for each toc of the testing file

        mahalanobisDistArray    = nan(nObsPerFile, nClasses); % Preallocation
        discriminantValueArray  = nan(nObsPerFile, nClasses); % Preallocation

        for iClass = 1 : nClasses,

            muVector     = model(iClass).muVector;
            sigmaArray   = model(iClass).sigmaArray;

            discriminantValueClassTerm = -1/2 * log(det(sigmaArray)) + log(priorProbaArray(iClass));

            tObsMinusMeanArray = bsxfun(@minus, tObsNormMapRedArray, muVector);
            for iObs = 1 : nObsPerFile,
    %             tObsMinusMeanArray                  = tObsArray(iObs, :)' - muVector;
                tObsMinusMean = tObsMinusMeanArray(iObs, :);
                mahalanobisDistArray(iObs, iClass)  = tObsMinusMean * (sigmaArray \ tObsMinusMean');
            end

            discriminantValueClassTermVector = repmat(discriminantValueClassTerm, nObsPerFile, 1);
            discriminantValueArray(:, iClass) = -1/2 * mahalanobisDistArray(:, iClass) + discriminantValueClassTermVector;

        end


        %%% Deduce toc estimate belonging

        [tocBelongingProbaVector, tocEstimateBelongingVector] = max(discriminantValueArray, [], 2);


        %%% Deduce belonging probability for the testing file

        nTocsBelongingToClassX = nan(1, nClasses); % Preallocation

        for iClass = 1 : nClasses,
            nTocsBelongingToClassX(iClass) = sum(tocEstimateBelongingVector == iClass);
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

        newValue = confusionMatrix(fileLabelVector(iFile), fileELabelVector(iFile)) + 1;
        confusionMatrix(fileLabelVector(iFile), fileELabelVector(iFile)) = newValue;

    end

    confusionMatrix(:, end) = sum(confusionMatrix, 2);
    confusionMatrix(end, :) = sum(confusionMatrix, 1);
    
    accuracyVec(iChanceLevelLoop) = sum(diag(confusionMatrix(1:end-1, 1:end-1)));
%     accuracyC1(iChanceLevelLoop) = confusionMatrix(1, 1) / sum(confusionMatrix(1, :));
%     accuracyC2(iChanceLevelLoop) = confusionMatrix(2, 2) / sum(confusionMatrix(2, :));
    accuracyC1(iChanceLevelLoop) = confusionMatrix(1, 1);
    accuracyC2(iChanceLevelLoop) = confusionMatrix(2, 2);

end

[a, b] = hist(accuracyVec, 100);
a = a / nFiles / nLoopsToComputeChanceLevel;

[a1, b1] = hist(accuracyC1, 100);
a1 = a1 / nFiles / nLoopsToComputeChanceLevel;

m1 = mean(accuracyC1);
s1 = std(accuracyC1);
dx1 = max(b1)+0.2 - (min(b1)-0.2);
x1 = min(b1)-0.2 : dx1/1e3 : max(b1)+0.2;
y1 = normpdf(x1, m1, s1);
y1 = y1 / max(y1) * max(a1);

probaTrueSensitivity = 1 - normpdf(confusionMatrix1(1, 1), m1, s1) / (2*normpdf(m1, m1, s1));


[a2, b2] = hist(accuracyC2, 100);
a2 = a2 / nFiles / nLoopsToComputeChanceLevel;

m2 = mean(accuracyC2);
s2 = std(accuracyC2);
dx2 = max(b2)+0.2 - (min(b2)-0.2);
x2 = min(b2)-0.2 : dx1/1e3 : max(b2)+0.2;
y2 = normpdf(x2, m2, s2);
y2 = y2 / max(y2) * max(a2);

probaTrueSpecificity = 1 - normpdf(confusionMatrix1(2, 2), m2, s2) / (2*normpdf(m2, m2, s2));




  % Virtualy equilibrate confusion matrix
%     confusionMatEquilArr = bsxfun(@times, confusionMatrixArr(:,:,i),  nObsPerClassArr(end:-1:1)');
    confusionMatEquilArr = bsxfun(@times, confusionMatrix1(1:2,1:2),  [1,1]);
        
    % Normalize confusion matrix
%     confusionMatEquilNormArr = confusionMatEquilArr / ( 2*prod(nObsPerClassArr) );
    confusionMatEquilNormArr = confusionMatEquilArr / ( sum(nObsPerClassArr) );

    % Compute positive and negative predictive values
%     positivePredictVal = (confusionMatEquilNormArr(1, 1) / sum(confusionMatEquilNormArr(:, 1)) - 1)^2;
%     negativePredictVal = (confusionMatEquilNormArr(2, 2) / sum(confusionMatEquilNormArr(:, 2)) - 1)^2;
    
    sensitivityVal = (confusionMatEquilNormArr(1, 1) / sum(confusionMatEquilNormArr(1, :)) - 1)^2;
    specificityVal = (confusionMatEquilNormArr(2, 2) / sum(confusionMatEquilNormArr(2, :)) - 1)^2;

    % Weighted positive and negative predictive values by probability that those value could be
    % random
%     positivePredictValWeighted = positivePredictVal + 0.5^2*(garbageProba(1));
%     negativePredictValWeighted = negativePredictVal + 0.5^2*(garbageProba(2));

    positivePredictValWeighted = sensitivityVal + 0.5^2*(1-probaTrueSensitivity);
    negativePredictValWeighted = specificityVal + 0.5^2*(1-probaTrueSpecificity);

    % Evaluate the confusion matrix estimator
    confMatEstimator    = positivePredictValWeighted + negativePredictValWeighted;
    confMatEstimatorS    = sensitivityVal + specificityVal;
%     confMatEstimatorVec(i)    = sensitivityVal + specificityVal;

z(:,:,i) =  confusionMatrix1(1:2,1:2);
d(i) = confMatEstimator;
e(i) = probaTrueSensitivity*100;
c(i) = probaTrueSpecificity*100;
end
end

figure; 

subplot(3, 1, 1);
hold on;

bar(b, a);
stem(p0*nFiles, max(a), '*r');
stem(p0*nFiles, max(a), 'r');

titleStr = sprintf('Confusion Matrix Estimator Value : %f (%f)', confMatEstimator, confMatEstimatorS);
title(titleStr);

subplot(3, 1, 2);
hold on;

bar(b1, a1);
stem(confusionMatrix1(1, 1), max(a1), '*r');
stem(confusionMatrix1(1, 1), max(a1), 'r');

% stem(confusionMatrix1(1, 1)/nFilesPerClassArr(1), max(a1), '*r');
% stem(confusionMatrix1(1, 1)/nFilesPerClassArr(1), max(a1), 'r');

plot(x1, y1, 'r');

titleStr = sprintf('Proba true sensitivity : %4.2f%%', probaTrueSensitivity*100);
title(titleStr);

subplot(3, 1, 3);
hold on;

bar(b2, a2);
stem(confusionMatrix1(2, 2), max(a2), '*r');
stem(confusionMatrix1(2, 2), max(a2), 'r');

% stem(confusionMatrix1(2, 2)/nFilesPerClassArr(2), max(a2), '*r');
% stem(confusionMatrix1(2, 2)/nFilesPerClassArr(2), max(a2), 'r');

plot(x2, y2, 'r');

titleStr = sprintf('Proba true specifity: %4.2f%%', probaTrueSpecificity*100);
title(titleStr);

fprintf('\nConfusion matrix:\n');
disp(confusionMatrix1);

% a(iL) = toc;
% end

%% Save this validation process
% Save feature selection, bayesian model, confusion matrix and kappa values.



%% Clean environment

%%% Remove library path
rmpath('./lib/');   % project lib
rmpath('./elib/');  % external lib



% eof
