% ----------------------------------------------------------------------------------------
% Impulsive sound recognition (Detection + Training + Testing)
% ----------------------------------------------------------------------------------------
% 
% Purpose : This script performs a statistical sound recognition algorithm for impulsive
%           sounds. It is an development interface to find the best methods and parameters
%           to perform the better recognition between given classes.
%
%
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------


% ----------------------------------------------------------------------------------------
% Currently used variables
%
% GENERIC VARIABLES
% ------------------
% nbClass        : Number of classes that exist in the database.
% PCA_dim        : Final dimension of the features after applying a PCA algorithm on them.
% LDA_dim        : Final dimension of the features after applying a LDA algorithm on them.
% PCABasis       : Matrix used to apply the PCA transform on feature vectors.
% LDABasis       : Matrix used to apply the LDA transform on feature vectors.
% nbTrainingFile : Number of files used for the training operation.
% nbTestingFile  : Number of files used for the testing operation.
% nbTrainingFilePerClass : Array containing the number of training files in each class.
% nbTestingFilePerClass  : Array containing the number of testing files in each class.
% trainingFiles  : Cell containing the path of each training files.
% testingFiles   : Cell containing the path of each testing files.
% membership     : Membership of the testing files to a class.
% certainties    : Certainties of the testing files to belong to a given class.
%
% BAYES VARIABLES 
% ----------------
% meanMatrix     : Each column contains the mean vector of the feature vectors for a 
%                  specific class.
% covMatrix      : Each column contains the covariance matrix of the feature vectors for a
%                  specific class. The covariance matrix is reshapped to fit in a column.
% ----------------------------------------------------------------------------------------


% ----------------------------------------------------------------------------------------
% TODO
% ----------------------------------------------------------------------------------------

% - Oneleft training strategy
% - LDA implementation
% - Save model parameters
% - R�activer l'ajout de bruit � l'entrainement
% - R�activer le "random generation" pour le choix des fichiers de l'entrainement
% - Ajout du disp pour le start iteration et l'intro
% - GMM, HMM+Bayes, HMM+GMM, (NN)


% ----------------------------------------------------------------------------------------
% Workspace initialization
% ----------------------------------------------------------------------------------------

%%% Clean workspace
close all;
clear all;
clc;


% ----------------------------------------------------------------------------------------
% User settings
% ----------------------------------------------------------------------------------------

%%% Database and toolboxes path
database_Path = './small_database_AD/';
% database_Path = '../tiny_database/';
toolbox_Path  = './toolboxes/';

%%% Number of signals for training and testing in each class 
% trainingStrategy = 'oneLeft';    % All signals minus one are used for training, the last one for testing
trainingStrategy = 'fiftyFifty'; % Half the signals are used for training, the other half for testing

%%% Crossvalidation settings
nbCrossvalidation       = 1; % Number of crossvalidation loop to do
allCrossvalidation_Flag = 1; % Do all possible crossvalidation when oneLeft_Flag = 1;

%%% Probability Density Function (PDF) model
model = 'Bayes';
% model = 'GMM';
% model = 'HMM+bayes';
% model = 'HMM+GMM';
% model = 'NN';

%%% Add noise to signal during the training and testing steps
trainingSNR = 220; %dB
testingSNR  = trainingSNR; %dB

%%% Feature to extract
featureType = 'spectrogram';
% featureType = 'MFCC';

%%% Feature reduction
PCA_dim = 10;
LDA_dim = 0;


% ----------------------------------------------------------------------------------------
% Script initialization
% ----------------------------------------------------------------------------------------

%%% Internal parameters
fileExtension_Size = 7; % className001.wav, 001.wav = 7 characters

%%% Load path
addpath(genpath(toolbox_Path));

%%% Extract relevant informations of the database
[className, nbClass, nbFilePerClass, fileRootPathPerClass] = ...
                            extractDatabaseInformation(database_Path, fileExtension_Size);

%%% Extract relevant informations of the database
[nbTrainingFilePerClass, nbTestingFilePerClass] = ...
                   extractTrainingAndTestingInformation(nbFilePerClass, trainingStrategy);


% ----------------------------------------------------------------------------------------
% Start crossvalidation loops
% ----------------------------------------------------------------------------------------

% h = waitbar(0, ['Iteration : 1/', int2str(nbCrossvalidation)], ...
%             'Name', 'Progression',...
%             'CreateCancelBtn', 'setappdata(gcbf, ''canceling'', 1)');
% setappdata(h, 'canceling', 0);

for crossId = 1 : nbCrossvalidation,
    
    %%% If "Cancel" button from the waitbar is pushed, then exit from crossvalidation loop
%     if getappdata(h, 'canceling'),
%         waitbarCancelWarning(crossId, nbCrossvalidation);
%         break;
%     end
    
    
    % ------------------------------------------------------------------------------------
    % Training files selection
    % ------------------------------------------------------------------------------------
    
    [trainingFile, testingFile] = ...
            generateTrainingAndTestingFileList(trainingStrategy, fileRootPathPerClass, ...
                       nbFilePerClass, nbTrainingFilePerClass, nbTestingFilePerClass, fileExtension_Size);

    
    % ------------------------------------------------------------------------------------
    % Training and testing
    % ------------------------------------------------------------------------------------

    switch model,
        case 'Bayes',
            
            %%% Training
            [meanMatrix, covMatrix, PCAEigenVectors, LDAEigenVectors] = ...
                Training_Bayes(trainingFile, trainingSNR, featureType, PCA_dim, LDA_dim);
                                                       
            %%% Testing                                        
            [membership, certainties] = ...
                Testing_Bayes(testingFile, testingSNR, featureType, ...
                                 PCAEigenVectors, LDAEigenVectors, meanMatrix, covMatrix);
                                           
        case 'GMM',
            
        case 'HMM+bayes',
            
        case 'HMM+GMM',
            
        otherwise,
            error('Unknown model type.');
    end
    
    
    % ------------------------------------------------------------------------------------
    % Compute and display performance
    % ------------------------------------------------------------------------------------
    
    [confusionMatrix, globalPerformance, stepPerformance] = ...
                                    computePerformance(nbTestingFilePerClass, membership);
               
    %%% Display Results
    display(confusionMatrix);
    display(stepPerformance);
    display(globalPerformance);
    
    
    
    %%% Update waitbar
%     waitbar_Update(h, crossID, nbCrossvalidation);
    
    
end % for - End of crossvalidation loop


% ----------------------------------------------------------------------------------------
% Clear workspace
% ----------------------------------------------------------------------------------------

% delete(h); % Deleted waitbar
rmpath(genpath(toolbox_Path));


% --------------------------------- End of file ------------------------------------------
