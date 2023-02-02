% --------------------------------------------------------------------------------------------------
% Impulsive sound recognition (Detection + Training + Testing)
% --------------------------------------------------------------------------------------------------
% 
% This script performs a statistical sound recognition algorithm for impulsive sounds. It is a 
% development interface for Sherlock Holmes project.
% 
% --------------------------------------------------------------------------------------------------

% ------------------------------------------------------------------------------------------------ %
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

% TODO
% - Am�liorer l'initialisation de EM � l'aide d'un algorithme fuzzy C-means (medians)
% - Am�liorer EM en DAEM (Deterministic Annealing)
% - Am�liorer EM en SMEM (Split & Merge)
% - Am�liorer EM en BYY-SMEM (Baysian Ying-Yang Split & Merge EM)
% - Quantic Annealing ?
%
% - LDA !
% - M�tode pour identifier le nbGMM de mani�re automatique
% - Autre m�thodes de mod�lisation que GMM et HMM


% ------------------------------------------------------------------------------------------------ %
% Workspace initialization
% ------------------------------------------------------------------------------------------------ %

close all;
clear all;
clc;


% ------------------------------------------------------------------------------------------------ %
% User settings
% ------------------------------------------------------------------------------------------------ %

%%% Database and toolboxes path
% databasePath = '../database/small_database_AD/';
databasePath  = '../database/test_database/';
% databasePath  = '../database/tiny_database/';
toolboxPath  = './toolbox/';

%%% Flag ON if inputs are features and not sound files
featureInputFlag = 1;

%%% Number of signals for training and testing in each class
%   0 : training over all minus 1 files, testing over the remaining file
%   1 : same as strategy 0 but this time all the crossvalidation are done
%   2 : training over 50% of the database and testing over the 50% remaining
%   3 : training over 75% of the database and testing over the 25% remaining
%   4 : training over 25% of the database and testing over the 75% remaining
trainingStrategy  = 2;
global randomSorting;
randomSorting = 1;

%%% Number of crossvalidation
nbCrossvalidation = 3;

%%% Probability Density Function (PDF) model
model(1) = 1; % 0 : Bayes - 1 : GMM - 2 : HMM
model(2) = 1; % nbGMM

%%% Add noise to signal during the training and testing steps
trainingSNR = 220; %dB
testingSNR  = trainingSNR; %dB

%%% Feature to extract
featureType = 0; % 0 : spectrogram - 1 : MFCC

%%% Feature reduction
reductionParameter(1) = 0; % PCA remaining dimension
reductionParameter(2) = 0;  % LDA remaining dimension - FUNCTION NOT IMPLEMENTED !


% ------------------------------------------------------------------------------------------------ %
% Script initialization
% ------------------------------------------------------------------------------------------------ %

%%% Load path
addpath(genpath(toolboxPath));

%%% Extract relevant informations of the database
[className, filePath] = extractDatabaseInformation(databasePath);

%%% Compute nb crossvalidation for training strategy 1
if trainingStrategy == 1, % Do all crossvalidation
    nbFile = length(filePath) - 1;
    nbCrossvalidation = nbFile;
end

%%% Display script header
displayMessage(1);

%%% Build wait bar
% h = waitbarCreation(nbCrossvalidation);


% ------------------------------------------------------------------------------------------------ %
% Start crossvalidation loops
% ------------------------------------------------------------------------------------------------ %

crossvalIndex = 0;
while crossvalIndex <= nbCrossvalidation,
    
    %%% Start chrono
    tic;
    crossvalIndex = crossvalIndex + 1;

    %%% If "Cancel" button from the waitbar is pushed, then exit from crossvalidation loop
%     if waitbarCanceling(h, crossvalIndex, nbCrossvalidation),
%         break;
%     end

    %%% Display iteration header
    displayMessage(2);

    %%% Files selection
    if ~featureInputFlag,
        [trainingFilePath, testingFilePath] = generateFileList(trainingStrategy, filePath);
    else
        [trainingFilePath, testingFilePath] = generateFeature1();
    end

    %%% Training
    [modelParameter, reductionMatrix, errorFlag] = training(trainingFilePath, trainingSNR, featureType, reductionParameter, model);
    if errorFlag,
        crossvalIndex = crossvalIndex - 1;
        disp('Missed loop.');
        continue;
    end

    %%% Testing                                        
    [membership, certainties] = testing(testingFilePath, testingSNR, featureType, reductionMatrix, modelParameter, model);

    %%% Compute recognition performance
    if featureInputFlag,
        testingFilePath2{1} = testingFilePath.target;
        [confusionMatrix, globalPerformance, stepPerformance] = computePerformance(testingFilePath2, membership);
    else
        [confusionMatrix, globalPerformance, stepPerformance] = computePerformance(testingFilePath, membership);
    end

    %%% Display performance
    displayMessage(3, confusionMatrix, globalPerformance, stepPerformance, className);

    %%% Update waitbar
%     waitbarUpdate(h, crossvalIndex, nbCrossvalidation, toc);
    
    
end % for - End of crossvalidation loop


% ------------------------------------------------------------------------------------------------ %
% Clear workspace
% ------------------------------------------------------------------------------------------------ %

%%% Remove waitbar
% delete(h); 

%%% Delete added path
rmpath(genpath(toolboxPath));


% --------------------------------- End of file -------------------------------------------------- %
