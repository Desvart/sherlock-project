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
% - Tenter de mieux g�rer la mani�re dont le script g�re la non-convergence de EM


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
% databasePath = '../../database/small_database_AD/';
databasePath  = '../../database/test_database/';
% databasePath  = '../../database/tiny_database/';
toolboxPath  = './../toolbox/';

%%% Number of signals for training and testing in each class
%   0 : training over all minus 1 files, testing over the remaining file
%   1 : same as strategy 0 but this time all the crossvalidation are done
%   2 : training over 50% of the database and testing over the 50% remaining
%   3 : training over 75% of the database and testing over the 25% remaining
%   4 : training over 25% of the database and testing over the 75% remaining
trainingStrategy  = 0;

%%% Number of crossvalidation
nbCrossvalidation = 20;

%%% Probability Density Function (PDF) model
model(1) = 1; % 0 : Bayes - 1 : GMM - 2 : HMM
model(2) = 1; % nbGMM

%%% Add noise to signal during the training and testing steps
trainingSNR = 220; %dB
testingSNR  = trainingSNR; %dB

%%% Feature to extract
featureType = 1; % 1 : spectrogram - 2 : MFCC

%%% Feature reduction
reductionParameter(1) = 0; % PCA remaining dimension
reductionParameter(2) = 0; % LDA remaining dimension - FUNCTION NOT IMPLEMENTED !


% ------------------------------------------------------------------------------------------------ %
% Script initialization
% ------------------------------------------------------------------------------------------------ %

[className, filePath, nbCrossvalidation, nbFile, h] = initScript(toolboxPath, databasePath, trainingStrategy, nbCrossvalidation);


% ------------------------------------------------------------------------------------------------ %
% Start crossvalidation loops
% ------------------------------------------------------------------------------------------------ %

nbSkipedLoop = 0;
crossvalIndex = 1;
while crossvalIndex <= nbCrossvalidation,
    
    %%% Update waitbar
    waitbarUpdate(h, crossvalIndex, nbCrossvalidation, toc);
    
    %%% Start chrono
    tic;
    crossvalIndex = crossvalIndex + 1;

    %%% If "Cancel" button from the waitbar is pushed, then exit from crossvalidation loop
    if waitbarCanceling(h, crossvalIndex, nbCrossvalidation),
        break;
    end

    %%% Display iteration header
    displayMessage(2);

    %%% Files selection
    [trainingFilePath, testingFilePath] = generateFileList(trainingStrategy, filePath);

    %%% Training
    [modelParameter, reductionMatrix, errorFlag] = training(trainingFilePath, trainingSNR, featureType, reductionParameter, model);
    if errorFlag,
        [crossvalIndex, nbSkipedLoop, cont] = EM_Error(trainingStrategy, crossvalIndex, nbSkipedLoop, nbFile);
        if cont,
            continue;
        end
    end

    %%% Testing                                        
    [membership, certainties] = testing(testingFilePath, testingSNR, featureType, reductionMatrix, modelParameter, model);

    %%% Compute recognition performance
    [confusionMatrix, globalPerformance, stepPerformance] = computePerformance(testingFilePath, membership);

    %%% Display performance
    displayMessage(3, confusionMatrix, globalPerformance, stepPerformance, className);

    
    
    
end % for - End of crossvalidation loop


% ------------------------------------------------------------------------------------------------ %
% Clear workspace
% ------------------------------------------------------------------------------------------------ %

%%% Remove waitbar
delete(h); 

%%% Delete added path
rmpath(genpath(toolboxPath));


% --------------------------------- End of file -------------------------------------------------- %
