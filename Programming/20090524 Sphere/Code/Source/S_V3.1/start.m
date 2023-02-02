% ------------------------------------------------------------------------------------------------ %
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


% G�rer le cas avec des entr�es r�elles et le mode 0 !
% Modifier la gestion de liste selon les entr�es r�elles.
% G�rer le cas o� EM ne converge pas.

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
% databasePath = '../database/test_database/';
databasePath = '../database/db_Duf_2C/';
% databasePath = '../database/db_Duf_2C_little/';

%%% True if files are randomly selected
reco.randomFlag = true;

%%% Number of signals for training and testing in each class
%  1  : training over all minus 1 files, testing over the remaining file
%  0  : same as strategy 1 but this time all the crossvalidation are done
%0<x<1: training over x% of the database and testing over the (1-x)% remaining
reco.strategy = 0;

%%% Number of crossvalidation
nbCrossvalidation = 2;

%%% Probability Density Function (PDF) model
% Bayes
% model.type  = 'Bayes';
% GMM
model.type  = 'GMM';
model.nbGMM = 3;
model.EMTol = 1e-6;
% HMM-Bayes
% model.type  = 'HMM-B';

%%% Add noise to signal during the training and testing steps
reco.trainingSNR = 120; %dB
reco.testingSNR  = reco.trainingSNR; %dB

%%% Feature to extract
model.featureType = 'spectrogram'; % spectrogram - MFCC
% model.featureType = 'MFCC'; % spectrogram - MFCC

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

nbMissedTraining = 0;
crossvalIndex = 1;
while crossvalIndex <= nbCrossvalidation,
    
    %%% Update waitbar
    waitbarUpdate(h, crossvalIndex, nbCrossvalidation, toc);
    
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
    modelParam = training(trainingFeature, reductionParam, model);
    if ischar(modelParam) && strcmp(modelParam, 'stats:mvnpdf:BadCovariance'),
        if reco.strategy ~= 0,
            crossvalIndex = crossvalIndex - 1;
        end
        nbMissedTraining = nbMissedTraining + 1;
        continue;
    end
    
    %%% Testing
    [membership, certainties] = testing(testingFeature, modelParam);
    
    %%% Compute recognition performance
    performance = computePerformance(perfprop, membership);
    
    %%% Display performance
    displayMessage(3, performance, database.className);
    
end % for - End of crossvalidation loop

displayMessage(4, performance, database.className, nbCrossvalidation, nbMissedTraining);


% ------------------------------------------------------------------------------------------------ %
% Clear workspace
% ------------------------------------------------------------------------------------------------ %

%%% Remove waitbar
delete(h); 

%%% Delete added path
rmpath(genpath(functionPath));


% --------------------------------- End of file -------------------------------------------------- %
