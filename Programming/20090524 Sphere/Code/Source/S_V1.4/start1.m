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



% ------------------------------------------------------------------------------------------------ %
% Workspace initialization
% ------------------------------------------------------------------------------------------------ %

close all;
clear all;
clc;


% ------------------------------------------------------------------------------------------------ %
% User settings
% ------------------------------------------------------------------------------------------------ %

%%% Database and toolboxes path  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

databasePath = '../database/small_database_AD/';
% databasePath  = '../database/test_database/';
% databasePath  = '../database/tiny_database/';
toolboxPath  = './toolbox/';

%%% Number of signals for training and testing in each class - - - - - - - - - - - - - - - - - - - -
%   0 : training over all minus 1 files, testing over the remaining file
%   1 : same as strategy 0 but this time all the crossvalidation are done
%   2 : training over 50% of the database and testing over the 50% remaining
%   3 : training over 75% of the database and testing over the 25% remaining
%   4 : training over 25% of the database and testing over the 75% remaining

trainingStrategy  = 2;
nbCrossvalidation = 3; % Number of crossvalidation loop to do
global randomSorting;
randomSorting = 1;

%%% Probability Density Function (PDF) model - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   0 : Bayes
%   1 : GMM
%   2 : HMM + Bayes
%   3 : HMM + GMM
%   4 : NN

model = 0;

%%% Add noise to signal during the training and testing steps  - - - - - - - - - - - - - - - - - - -

trainingSNR = 220; %dB
testingSNR  = trainingSNR; %dB

%%% Feature to extract - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%   0 : spectrogram
%   1 : MFCC

featureType = 0;

%%% Feature reduction  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

reductionParameter(1) = 10; % PCA remaining dimension
reductionParameter(2) = 0;  % LDA remaining dimension - FUNCTION NOT IMPLEMENTED !


% ------------------------------------------------------------------------------------------------ %
% Script initialization
% ------------------------------------------------------------------------------------------------ %

%%% Load path  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

addpath(genpath(toolboxPath));

%%% Extract relevant informations of the database  - - - - - - - - - - - - - - - - - - - - - - - - -

[className, filePath] = extractDatabaseInformation(databasePath);

                                             
% ------------------------------------------------------------------------------------------------ %
% Start crossvalidation loops
% ------------------------------------------------------------------------------------------------ %

%%% Initialize loop

displayMessage(1);

if trainingStrategy == 1, % Do all crossvalidation
    nbFile = length(filePath) - 1;
    nbCrossvalidation = nbFile;
end

h = waitbarCreation(nbCrossvalidation);


%%% Crossvalidation loop
for crossvalIndex = 1 : nbCrossvalidation,
    
    tic;
    
    %%% If "Cancel" button from the waitbar is pushed, then exit from crossvalidation loop
    if waitbarCanceling(h, crossvalIndex, nbCrossvalidation),
        break;
    end

    displayMessage(2);


    % -------------------------------------------------------------------------------------------- %
    % Files selection
    % -------------------------------------------------------------------------------------------- %
    
    [trainingFilePath, testingFilePath] = generateFileList(trainingStrategy, filePath);


    % -------------------------------------------------------------------------------------------- %
    % Training and testing
    % -------------------------------------------------------------------------------------------- %

    switch model,
        case 0, % Bayes  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
            
            %%% Training
            [modelParameter, reductionMatrix] = trainingBayes(trainingFilePath, ...
                                            trainingSNR, featureType, reductionParameter);
                                                       
            %%% Testing                                        
            [membership, certainties] = testingBayes(testingFilePath, testingSNR, ...
                                            featureType, reductionMatrix, modelParameter);
                                           
        case 1, % GMM  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            
            
        case 2, % HMM+bayes  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            
            
        case 3, %HMM+GMM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
            
            
        otherwise,
            error('Unknown model type.');
    end

    
    % -------------------------------------------------------------------------------------------- %
    % Compute recognition performance
    % -------------------------------------------------------------------------------------------- %
    
    nbTestingFilePerClass = testingFilePath{1};
    
    [confusionMatrix, globalPerformance, stepPerformance] = ...
                                              computePerformance(nbTestingFilePerClass, membership);
    
                                          
    % -------------------------------------------------------------------------------------------- %
    % Display performance
    % -------------------------------------------------------------------------------------------- %
    
    displayMessage(3, confusionMatrix, globalPerformance, stepPerformance, className);


% ------------------------------------------------------------------------------------------------ %
% End crossvalidation loops
% ------------------------------------------------------------------------------------------------ %

%%% Update waitbar
    waitbarUpdate(h, crossvalIndex, nbCrossvalidation, toc);
    
    
end % for - End of crossvalidation loop


% ------------------------------------------------------------------------------------------------ %
% Clear workspace
% ------------------------------------------------------------------------------------------------ %

delete(h); % Deleted waitbar
rmpath(genpath(toolboxPath));


% --------------------------------- End of file -------------------------------------------------- %
