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
% Currently used structures
%
% GENERIC VARIABLES
% ------------------
% database      .path                   string
%               .fileExtension_Size     scalar
%
% class         .name                   string cell (nbClass x 1)
%               .nbClass                scalar
%               .nbFile                 scalar
%               .nbFilePerClass         scalar array (nbClass x 1)
%               .genericPathPerClass    string cell (nbClass x 1)
% 
% trainingFile  .nbFile                 scalar
%               .nbFilePerClass         scalar array (nbClass x 1)
%               .SNR                    scalar
%               .path                   string cell (nbClass x 1)
%
% testingFile   .nbFile                 scalar
%               .nbFilePerClass         scalar array (nbClass x 1)
%               .SNR                    scalar
%               .path                   string cell (nbClass x 1)
%
% dimReduction  .PCA_dim                scalar
%               .PCAEigenVectors        scalar array
%               .LDA_dim                scalar
%               .LDAEigenVectors        scalar array
%
% feature       .type                   string
%               .model                  string
%               .PCA_dim                scalar
%               .LDA_dim                scalar
%               .ICA_dim                scalar
%               .dim                    scalar
%               .vectors                scalar array (dim x )
%               
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
% database_Path = './small_database_AD/';
database.path = '../tiny_database/';
toolbox_Path  = './toolboxes/';

%%% Number of signals for training and testing in each class 
% trainingStrategy = 'oneLeft';    % All signals minus one are used for training, the last one for testing
trainingStrategy = 'fiftyFifty'; % Half the signals are used for training, the other half for testing

%%% Crossvalidation settings
nbCrossvalidation       = 1; % Number of crossvalidation loop to do
allCrossvalidation_Flag = 1; % Do all possible crossvalidation when oneLeft_Flag = 1;

%%% Feature to extract
feature.type = 'spectrogram';
% featureType = 'MFCC';

%%% Feature reduction
feature.PCA_dim = 10;
feature.LDA_dim = 0;
feature.ICA_dim = 0;

%%% Probability Density Function (PDF) model
feature.model = 'Bayes';
% feature.model = 'GMM';
% feature.model = 'HMM+bayes';
% feature.model = 'HMM+GMM';
% feature.model = 'NN';

%%% Add noise to signal during the training and testing steps
trainingFile.SNR = 220; %dB
testingFile.SNR  = trainingFile.SNR; %dB




% ----------------------------------------------------------------------------------------
% Script initialization
% ----------------------------------------------------------------------------------------

%%% Internal parameters
database.fileExtension_Size = 7; % className001.wav, 001.wav = 7 characters

%%% Load path
addpath(genpath(toolbox_Path));

%%% Extract relevant informations of the database
class = extractClassInformation(database);

%%% Extract relevant informations of the database
% [nbTrainingFilePerClass, nbTestingFilePerClass] = ...
%                    extractTrainingAndTestingInformation(nbFilePerClass, trainingStrategy);
% [nbTrainingFilePerClass, nbTestingFilePerClass] = ...
%                    extractTrainingAndTestingInformation(nbFilePerClass, trainingStrategy);


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
    
%     [trainingFile, testingFile] = ...
%             generateTrainingAndTestingFileList(trainingStrategy, fileRootPathPerClass, ...
%                        nbFilePerClass, nbTrainingFilePerClass, nbTestingFilePerClass, fileExtension_Size);
                   
    [trainingFile, testingFile] = generateFileList(trainingStrategy, class, database);

    
    % ------------------------------------------------------------------------------------
    % Training and testing
    % ------------------------------------------------------------------------------------

    switch model,
        case 'Bayes',
            
            %%% Training
            [meanMatrix, covMatrix, ...
                PCABasis, LDABasis] = Training_Bayes(trainingFile, trainingSNR, ...
                                                           featureType, PCA_dim, LDA_dim);
                                                       
            %%% Testing                                                             
            [membership, certainties] = Testing_Bayes(testingFile, testingSNR, ...
                                                      featureType, PCABasis, LDABasis, ...
                                                                   meanMatrix, covMatrix);
                                           
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
                   computePerformance(nbTestingFilePerClass, membership, confusionMatrix);
               
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
