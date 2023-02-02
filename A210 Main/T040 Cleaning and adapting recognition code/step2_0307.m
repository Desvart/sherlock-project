% Project : Sherlock Holmes - SPHERE (System for a Perfect and Honest Element Recognition and Evaluation)
%
%   Build   : Matlab R2012b (8.0.0.783) x64 - Windows 7 x64
%             Matlab R2013a (8.1.0.604) x64 - Windows 7 x64

% History
% 1.1.b0.0307	Rewrite from scratch for readability
% 1.0.b0.0103	First functionnal version
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
nFeats          = 8;


%%% Index of files belonging to class 'x'

classE00        = [1,2, 9,10, 17,18, 25:30];
classE01        = [3:4, 11:12, 19:20];
classE02        = [5:6, 13:14, 21:22];
classE03        = [7:8, 15:16, 23:24];
classE0x        = sort([classE01, classE02, classE03]);

 
%%% Select data source
 
loadRealDataBoo = true;

% Real data
dataSetRPath    = './data/datasetCorr5.mat';

% "Fake" data
muFakeArr       = [1, 2;...
                   6, 4];
sigmaFakeCAr    = {[1.0, 0.5;  ...
                    0.5, 2.0], ...
                   [3.0, 0.5;  ...
                    0.5, 1.0]}; 

                
%%% Chance level computation
    
evaluateChanceLevelBoo      = true;
% nLoopsToComputeChanceLevel  = 25000;
nLoopsToComputeChanceLevel  = 1000;


%%% Select stistically pertinent caracteristics
 
% E-Value analysis
eValThresh      = 1/1000;

% Characteristics to keep
plotBoo         = true;
plotCarSelBoo   = true;
% charIdxToKeep   = [7, 9, 10, 11, 12, 13, 21, 25, 26, 27, 28, 29, 34, 37, 38];
charIdxToKeep   = [1, 4, 5, 7, 9, 10, 11, 12, 13, 21, 25, 26, 27, 28, 29, 34, 37, 38];
% charIdxToKeep       = [1, 4, 5, 6, 7, 11, 12, 13, 14, 18];

% eBestResultsIdVec   = [5931;17223;17227;18219;20811;21319;29135;50987;59211;62279;68427;82763;86283;86343;86347;86349;86471;86855;91469;104265;110575;112719;119623];
% eBestResultsIdVec   = 5931;
% eBestResultsIdVec   = 262143;
% eBestResultsIdVec   = [9035;20811;25419;94283;94539;254283;];
% eBestResultsIdVec   = [258;275;387;403;643;667;675;701;731;747;759;767;771;1021;];
% eBestResultsIdVec   = [9035,20811,25419,94283,94539,254283;];
eBestResultsIdVec   = [9035,20811,25419];
nEBestResults       = length(eBestResultsIdVec);

confusionMatrixArr          = nan(2, 2, nEBestResults);
confusionMatrixEstimatorVec = nan(1, nEBestResults);
probaTrueSensitivityVec     = nan(1, nEBestResults);
probaTrueSpecificityVec     = nan(1, nEBestResults);
nFeatsVec                   = nan(1, nEBestResults);



%%% Plot properties

screenSize              = get(0, 'ScreenSize');
plotPosition            = [screenSize(3), 1, screenSize(3:4)];


%%% Various number of elements

fileIdxPerClassCAr      = {classE00; classE0x};
nClasses                = length(fileIdxPerClassCAr);

nFilesPerClassArr       = cellfun('length', fileIdxPerClassCAr);
nFiles                  = sum(nFilesPerClassArr);

nObsPerClassArr         = nFilesPerClassArr * nObsPerFile;
nObs                    = sum(nObsPerClassArr);

fileLabelVec            = ones(nFiles, 1);
fileLabelVec(classE0x)  = 2;

MatFileStruct           = whos('-file', dataSetRPath);
nCaracteristics         = length(MatFileStruct);

nCharIdxToKeep          = length(charIdxToKeep);
    
    
    

for iEBestResult = 1 : nEBestResults,
    
   
    %%% Init this learning
    
    eBestResult                 = eBestResultsIdVec(iEBestResult);
    binArr                      = dec2binArr(eBestResult, nCharIdxToKeep);
    charIdxToKeep1              = charIdxToKeep(logical(binArr));
    nCharKept                   = length(charIdxToKeep1);
    nFeats                      = nCharKept;
    nFeatsVec(iEBestResult)     = nFeats;

    

    %% Load data and build dataset

    
    %%% If user want to load real data

    if loadRealDataBoo == true, 

        
        %%% Load characteristic names
        
        load(dataSetRPath);
        charNameCAr     = select_pertinent_characteristics(dataSetRPath, eValThresh, ...
                                                    plotCarSelBoo, nObsPerFile, fileIdxPerClassCAr);
        charKeptNameCAr = charNameCAr(charIdxToKeep1); 

        
        %%% Load all characteristic values and store them into allObsArr(nFiles, nObsPerFile,
        % nCharKept) variable.
        
        allObsArr = nan(nFiles, nObsPerFile, nCharKept); % Prealloc.
        for iChar = 1 : nCharKept,

            featValArr = eval([charKeptNameCAr{iChar}])'; % Load characteristic values

            for iFile = 1 : nFiles,
                for iObs = 1 : nObsPerFile,
                    featValArrObsIdx              = ( (iFile-1) * nObsPerFile ) + iObs;
                    allObsArr(iFile, iObs, iChar) = featValArr(featValArrObsIdx);
                end
            end

        end
    
    
    %%% If user want to load gaussian distributed data
        
    else 

        
        %%% Generate all fake data
        
        % Init.
        nCharKept       = 2;
        nFeats          = nCharKept;
        charKeptNameCAr = {'fakeChar1', 'fakeChar2'};
        % Prealloc.
        fakeData        = cell(1, nFeats); 
        
        for iFeat = 1 : nFeats,
            fakeDataTmp     = randn( nObsPerClassArr(iFeat), 2 ) * chol( sigmaFakeCAr{iFeat} );
            fakeData{iFeat} = repmat( muFakeArr(iFeat, :), [nObsPerClassArr(iFeat), 1] ) + fakeDataTmp;
        end
        
        
        %%% Order generated fake data into allObsArr variable
        
        allObsArr = rand(nFiles, nObsPerFile, nFeats); % Init.
        for iClass = 1 : nClasses,

            iEBestResult  = 0; %#ok<FXSET>

            for iFile = fileIdxPerClassCAr{iClass},

                iEBestResult            = iEBestResult + 1; %#ok<FXSET>
                fakeDataIdx             = (iEBestResult-1)*nObsPerFile + (1 : nObsPerFile);
                allObsArr(iFile, :, :)  = fakeData{iClass}(fakeDataIdx, :);

            end

        end

    end



    %% Plot feature space


    if plotBoo,
        
        
        
        %% Plot inner diversity for each characteristic
        
        
        %%% Init. plot
        
        figure('Color',         'white', ...
               'OuterPosition', plotPosition); %#ok<UNRCH>

        classTagStr     = 'xx';
        colArr          = 'rb';
        histMarkerStr   = 'os';

        
        %%% Plot characteristics values
        
        for iChar = 1 : nCharKept,     

            
            %%% Build axes

            axesXPos = ((iChar-1)*(100/nCharKept) + 1.5 ) / 100;
            axesYPos = (40-1.5) / 100;
            axesW    = (100/nCharKept - 1.5) / 100; 
            axesH    = 60 / 100;
            
            axes('Position', [axesXPos, axesYPos, axesW, axesH]); 
            hold on;


            %%% For each caracteristic plot them. Each class have a different color and each file a
            %   different line.

            for iClass = 1 : nClasses,
                for iFile = fileIdxPerClassCAr{iClass},    
                    plotOptsStr = [colArr(iClass), classTagStr(iClass)];
                    plot(allObsArr(iFile, :, iChar), iFile*ones(1, nObsPerFile), plotOptsStr);
                end
            end

            axis tight;
            ylim([0, nFiles + 1]);

        end


        %%% Plot characteristics gaussian fitting for each class.

        for iChar = 1 : nCharKept,


            %%% Build axes

            axesXPos = ((iChar-1)*(100/nCharKept) + 1.5 ) / 100;
            axesYPos = (20) / 100;
            axesW    = (100/nCharKept - 2) / 100; 
            axesH    = 12 / 100;

            axes('Position', [axesXPos, axesYPos, axesW, axesH]); 
            hold on;


            %%% Compute usefull data for gaussian estimation of each class

            charRange = [min(min(min(allObsArr(:, :, iChar)))), ...
                         max(max(max(allObsArr(:, :, iChar))))];
            nGauss   = charRange(1) : (charRange(2)-charRange(1))/10000 : charRange(2);


            %%% Bloc all caracteristics. One different line for each class. Plot the gaussian estimation of
            %   each class over each data class.

            for iClass = 1 : nClasses,

                % Extract caracteristcs for this class
                charForThisClassArr = allObsArr(fileIdxPerClassCAr{iClass}, :, iChar);
                charForThisClassVec = charForThisClassArr(:);

                % Compute gaussian parameters estimation
                mean1Vec = nanmean(charForThisClassVec);
                std1  = nanstd(charForThisClassVec);

                % Build gaussian estimation
                pdf1 = normpdf(nGauss, mean1Vec, std1);
                pdf1 = pdf1/max(pdf1);

                % Plot
                plotOptsStr = [colArr(iClass), classTagStr(iClass)];
                plot(charForThisClassVec, iClass*ones(1, nObsPerClassArr(iClass)), plotOptsStr);
                plot(nGauss, pdf1 + iClass, colArr(iClass));

            end

            axis tight;
            ylim([0, nClasses + 1.1]);
            title(charKeptNameCAr{iChar});

        end



        %%% Plot characteristics histogram for each class.

        for iChar = 1 : nCharKept,


            %%% Build axes

            axesXPos = ((iChar-1)*(100/nCharKept) + 1.5 ) / 100;
            axesYPos = (2) / 100;
            axesW    = (100/nCharKept - 2) / 100; 
            axesH    = 12 / 100;

            axes('Position', [axesXPos, axesYPos, axesW, axesH]);
            hold on;


            %%% Compute usefull data for gaussian estimation of each class

            charRange = [min(min(min(allObsArr(:, :, iChar)))), ...
                         max(max(max(allObsArr(:, :, iChar))))];
            nGauss    = charRange(1) : (charRange(2)-charRange(1))/10000 : charRange(2);


            %%% Bloc all characteristics. One different line for each class. Plot the gaussian 
            %   estimation of each class over each data class.

            maxHistY = 0;
            histBinWidth = 0;
            for iClass = 1 : nClasses,

                % Extract caracteristcs for this class
                charForThisClassArr = allObsArr(fileIdxPerClassCAr{iClass}, :, iChar);
                charForThisClassVec = charForThisClassArr(:);

                % Compute nBins
                carDyn = max(charForThisClassVec) - min(charForThisClassVec);
                if iClass == 1,
                    histBinWidth = carDyn / 30;
                end
                nHistBin = carDyn / histBinWidth;

                % Compute histogram
                [histY, histX] = hist(charForThisClassVec, nHistBin);
                histX(histY == 0) = [];
                histY(histY == 0) = [];

                % Plot
                h = stem(histX, histY, colArr(iClass), 'MarkerFaceColor', colArr(iClass), 'Marker', histMarkerStr(iClass));
                maxHistY = max([histY, maxHistY]);
            end

            axis tight;
            ylim([0, maxHistY]);
            title('Histogram')

        end

        
        
        %% Plot class diversity for pair of characteristics

        
        %%% Init. plot
        
        figure('Color',         'white', ...
               'OuterPosition', plotPosition);
        col = 'rb';
        classTag = '..';
        
        
        %%% Go through all pairs
        
        for iChar1 = 2 : nCharKept,
            for iChar2 = 1 : iChar1-1,

                
                %%% Build axes
                
                axesW    = (100/(nCharKept-1) - 2) / 100; 
                axesH    = 10 / 100;
                axesXPos = ((iChar1-2)*(100/(nCharKept-1)) + 1.5 ) / 100;
                axesYPos = (100 - (iChar2-1)*(100/(nCharKept-1)) - (axesH*100 + 2.5)) / 100;

                axes('Position', [axesXPos, axesYPos, axesW, axesH]); %#ok<LAXES>
                hold on;

                
                %%% For each class
                
                for iClass = 1 : nClasses,
                    
                    char1ForThisClassArr = allObsArr(fileIdxPerClassCAr{iClass}, :, iChar1);
                    char1ForThisClassVec = char1ForThisClassArr(:);
                    char2ForThisClassArr = allObsArr(fileIdxPerClassCAr{iClass}, :, iChar2);
                    char2ForThisClassVec = char2ForThisClassArr(:);

                    cloudArr = [char1ForThisClassVec, char2ForThisClassVec];

                    meanVec = nanmean(cloudArr);
                    covArr  = nancov(cloudArr);

                    % Plot observation cloud
                    plot(cloudArr(:, 1), cloudArr(:, 2), [col(iClass), classTag(iClass)]);
                    % Mark mean of each cloud
                    plot(meanVec(1), meanVec(2), ['g', classTag(iClass)]);
                    % Plot std ellipse for each cloud
                    hEll = plot_gaussian_ellipsoid(meanVec, covArr);
                    set(hEll, 'Color', 'red');
                    
                end
                
                
                %%% Finalize axe appareance
                
                axis tight;
                titleStr = sprintf('%s - %s (%d-%d)', charKeptNameCAr{iChar1}, ...
                                                           charKeptNameCAr{iChar2}, iChar1, iChar2);
                title(titleStr);

            end
        end
        
    end % if plotBoo,


    
    %% Cross-validation process
    
    
    confusionMatArr     = cross_validation_loop(allObsArr, fileLabelVec, nFeats);
    confusionMatNormArr = confusionMatArr / nFiles; % Normalize confusion matrix

    
    %%% Compute estimator of confusion matrix
    % " GS method "

    % Compute positive and negative predictive values (adapted version)
    gsSensitivity = ( confusionMatNormArr(1, 1) / sum(confusionMatNormArr(:, 1)) - 1 )^2;
    gsSpecificity = ( confusionMatNormArr(2, 2) / sum(confusionMatNormArr(:, 2)) - 1 )^2;
    % Compute the confusion matrix estimator
    gsAccuracy    = gsSensitivity + gsSpecificity;
    
    
    %%% Display cross-validation results
    
    fprintf('\nConfusion matrix:\n');
    disp(confusionMatArr);
    fprintf('\nConfusion matrix estimator:\n');
    disp(gsAccuracy);
    
    
    
    %% Estimate chance level distribution 
    % " PB method "
    
    
    if evaluateChanceLevelBoo,
            
        
        %%% Check if matlabpool is open.    
        
        if matlabpool('size') == 0,
            matlabpool('open', 4);
        end
        
        
        %%% To compute chance level, one must do a high number of trainings
        
        confusionMatrix  = nan(2, 2, nLoopsToComputeChanceLevel); % Preallocation
        parfor iChanceLevelLoop = 1 : nLoopsToComputeChanceLevel,

            str = '#%d/%d - Chance-level evaluation : %d/%d\n';
            fprintf(str, iEBestResult, nEBestResults, iChanceLevelLoop, nLoopsToComputeChanceLevel);

            
            %%% Start cross-validation loop (leave-one-out scheme)

            randomLabelFlg  = true;
            confusionMatrix(:, :, iChanceLevelLoop) = cross_validation_loop(allObsArr, fileLabelVec, nFeats, randomLabelFlg);

        end % parfor iChanceLevelLoop = 1 : nLoopsToComputeChanceLevel,
        
            
        %%% Compute estimator of confusion matrix
        % " GS method "
    
        % Param
        nBins       = 100;
        binPosDelta = 0.2;
        
        
        %%% Estimate probability that sensitivity results are correct
        
        truePositiveVec                          = squeeze(confusionMatrix(1, 1, :));
        [truePositiveBinVal, truePositiveBinPos] = hist(truePositiveVec, nBins);
        truePositiveBinVal                       = truePositiveBinVal / nFiles / nLoopsToComputeChanceLevel;

        truePositiveMean    = mean(truePositiveVec);
        truePositiveStd     = std(truePositiveVec);
        dx1                 = ( max(truePositiveBinPos) + binPosDelta ) - ( min(truePositiveBinPos) - binPosDelta );
        x1                  = min(truePositiveBinPos)-binPosDelta : dx1/1e3 : max(truePositiveBinPos)+binPosDelta;
        y1                  = normpdf(x1, truePositiveMean, truePositiveStd);
        y1                  = y1 / max(y1) * max(truePositiveBinVal);

        probaTrueSensitivity = 1 - ...
                             normpdf(confusionMatArr(1, 1), truePositiveMean, truePositiveStd) / ...
                             ( 2 * normpdf(truePositiveMean, truePositiveMean, truePositiveStd) );
        
        
        %%% Estimate probability that specificity results are correct
        
        falseNegativeVec                            = squeeze(confusionMatrix(2, 2, :));
        [falseNegativeBinVal, falseNegativeBinPos]  = hist(falseNegativeVec, nBins);
        falseNegativeBinVal                         = falseNegativeBinVal / nFiles / nLoopsToComputeChanceLevel;

        falseNegativeMean   = mean(falseNegativeVec);
        falseNegativeStd    = std(falseNegativeVec);
%         dx2                 = ( max(falseNegativeBinPos) + binPosDelta ) - ( min(falseNegativeBinPos) - binPosDelta );
        x2                  = min(falseNegativeBinPos)-binPosDelta : dx1/1e3 : max(falseNegativeBinPos)+binPosDelta;
        y2                  = normpdf(x2, falseNegativeMean, falseNegativeStd);
        y2                  = y2 / max(y2) * max(falseNegativeBinVal);

        probaTrueSpecificity = 1 - ...
                           normpdf(confusionMatArr(2, 2), falseNegativeMean, falseNegativeStd) / ...
                           ( 2 * normpdf(falseNegativeMean, falseNegativeMean, falseNegativeStd) );
        

        %%% Weighted sensitivity and specificity values by probability that those values could be
        % random. 0.5^2 is the value found to equilibrate the way the weighting is done so that a
        % sensitivity or a specificity of 50 % with a 100 % of probability to be correct has the 
        % same impact as one of 100 % with a 50 % of probability to be correct.
        
        gsSensitivityWeighted = gsSensitivity + 0.5^2 * ( 1 - probaTrueSensitivity );
        gsSpecificityWeighted = gsSpecificity + 0.5^2 * ( 1 - probaTrueSpecificity );
        % Evaluate the confusion matrix estimator
        confMatrixEstimator   = gsSensitivityWeighted + gsSpecificityWeighted;

        
        %%% Save process values
        
        confusionMatrixArr(:, :, iEBestResult)      = confusionMatArr(1:2,1:2);
        confusionMatrixEstimatorVec(iEBestResult)   = confMatrixEstimator;
        probaTrueSensitivityVec(iEBestResult)       = probaTrueSensitivity * 100;
        probaTrueSpecificityVec(iEBestResult)       = probaTrueSpecificity * 100;
        
    end % if evaluateChanceLevelBoo,
    
    
    
    %% Plot final results

    
    figure('Color', 'white'); 

    
    %%% Plot sensitivity probability
    
    subplot(2, 1, 1);
    hold on;

    bar(truePositiveBinPos, truePositiveBinVal);
    stem(confusionMatArr(1, 1), max(truePositiveBinVal), '*r');
    stem(confusionMatArr(1, 1), max(truePositiveBinVal), 'r');

    % stem(confusionMatrix1(1, 1)/nFilesPerClassArr(1), max(a1), '*r');
    % stem(confusionMatrix1(1, 1)/nFilesPerClassArr(1), max(a1), 'r');

    plot(x1, y1, 'r');

    titleStr = sprintf('Proba true sensitivity : %4.2f %%', probaTrueSensitivity*100);
    title(titleStr);
    
    
    %%% Plot specificity probability

    subplot(2, 1, 2);
    hold on;

    bar(falseNegativeBinPos, falseNegativeBinVal);
    stem(confusionMatArr(2, 2), max(falseNegativeBinVal), '*r');
    stem(confusionMatArr(2, 2), max(falseNegativeBinVal), 'r');

    % stem(confusionMatrix1(2, 2)/nFilesPerClassArr(2), max(a2), '*r');
    % stem(confusionMatrix1(2, 2)/nFilesPerClassArr(2), max(a2), 'r');

    plot(x2, y2, 'r');

    titleStr = sprintf('Proba true specifity: %4.2f %%', probaTrueSpecificity*100);
    title(titleStr);

    fprintf('\nConfusion matrix:\n');
    disp(confusionMatArr);



end % for iEBestResult = 1:nEBestResults,



%% Clean environment


%%% Remove library path

rmpath('./lib/');   % project lib
rmpath('./elib/');  % external lib



% eof


