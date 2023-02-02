% ------------------------------------------------------------------------------------------------ %
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


% ------------------------------------------------------------------------------------------------ %
% Workspace initialization
% ------------------------------------------------------------------------------------------------ %

%%% Clear workspace
close all;
clear all;
clc;

%%% Add script path
functionPath  = './Functions/';
addpath(genpath(functionPath));


% ------------------------------------------------------------------------------------------------ %
% User settings
% ------------------------------------------------------------------------------------------------ %

%%% Input selection
input.inputFlag = 0; % 0 : features input - 1 : database input
input.inputMode = 2;
global plotFlag; plotFlag = 0;

%%% Database and toolboxes path
% databasePath = '../database/small_database_AD/';
databasePath = '../database/test_database/';
% databasePath = '../database/db_Duf/';

%%% True if files are randomly selected
reco.randomFlag = 1;

%%% Number of signals for training and testing in each class
%  1  : training over all minus 1 files, testing over the remaining file
%  0  : same as strategy 1 but this time all the crossvalidation are done
%0<x<1: training over x% of the database and testing over the (1-x)% remaining
reco.strategy = 1;

%%% Number of crossvalidation
nbCrossvalidation = 50;

%%% Probability Density Function (PDF) model
% model.type = 'Bayes'; % Bayes - GMM - HMM
model.type  = 'GMM'; % Bayes - GMM - HMM
model.nbGMM = 2;

%%% Add noise to signal during the training and testing steps
reco.trainingSNR = 220; %dB
reco.testingSNR  = reco.trainingSNR; %dB

%%% Feature to extract
model.featureType = 'spectrogram'; % spectrogram - MFCC

%%% Feature reduction
reductionParam.PCAdim = 0; % PCA remaining dimension
reductionParam.LDAdim = 0; % LDA remaining dimension - FUNCTION NOT IMPLEMENTED !


% ------------------------------------------------------------------------------------------------ %
% Script initialization
% ------------------------------------------------------------------------------------------------ %

[database, nbCrossvalidation, h] = initScript(input.inputFlag, databasePath, reco.strategy, nbCrossvalidation);


% ------------------------------------------------------------------------------------------------ %
% Start crossvalidation loops
% ------------------------------------------------------------------------------------------------ %

nbSkipedLoop = 0;
crossvalIndex = 1;
while crossvalIndex <= nbCrossvalidation,
    
    %%% Start loop
    tic;    % Start chrono
    crossvalIndex = crossvalIndex + 1; % Increment loop index
    
    %%% If "Cancel" button from the waitbar is pushed, then exit from crossvalidation loop
%     if waitbarCanceling(h, crossvalIndex, nbCrossvalidation),
%         break;
%     end

    %%% Display iteration header
    displayMessage(2);
    
    %%% Extract features
    [trainingFeature, testingFeature, perfprop] = featureAccess(input, reco, database, model);
    
    %%% Training
    [modelParam, trainingErr] = training(trainingFeature, reductionParam, model);
    
    %%% Testing
    [membership, certainties] = testing(testingFeature, modelParam);
    
    %%% Compute recognition performance
    performance = computePerformance(perfprop, membership);

    %%% Display performance
    displayMessage(3, performance, database.className);

    %%% Update waitbar
    waitbarUpdate(h, crossvalIndex, nbCrossvalidation, toc);
    
end % for - End of crossvalidation loop
