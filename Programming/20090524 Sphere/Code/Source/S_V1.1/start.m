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
% - Path for database and toolboxes
% - Training and testing strategy (50/50 or all-1)
% - Number of crossvalidation
% - Choise of the PDF model (Bayes, GMM, HMM+Bayes, HMM+GMM)
% - SNR noise level to add to training and testing signals
% - Type of feature to extract (spectrogramm, MFCC)
% - Dimension for PCA and LDA reduction algorithms (if 0 => no reduction)
% ----------------------------------------------------------------------------------------

%%% Database and toolboxes path
% database_Path = './small_database_AD/';
database_Path = './tiny_database/';
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
% This block extracts class names, number of class, number of files per class, path of
% each files and the number of files to use for training and testing.
%
% Input :   - toolbox_Path
%           - database_Path
%           - trainingStrategy
%
% Output :  - nbClass
%           - fileRootPath
%           - nbFileForTraining
%           - nbFileForTesting
%
% Functions used :  - folderContent
%                   - fileName
% ----------------------------------------------------------------------------------------

%%% Internal parameters
fileExtension_Size = 7; % className001.wav, 001.wav = 7 characters

%%% Load path
addpath(genpath(toolbox_Path));

%%% Load class names
[className, nbClass] = folderContent(database_Path);

%%% Load file names for each class and compute the number of files available for each
%%% class
nbFilePerClass = zeros(1, nbClass); % Preallocation
fileRootPath   = cell(1, nbClass);  % Preallocation
for i = 1 : nbClass,
    [fileName, nbFilePerClass(i)] = folderContent([database_Path, className{i}]);
    fileCoreName                  = fileName{1}(1:end-fileExtension_Size);
    fileRootPath{i}               = [database_Path, className{i}, '/', fileCoreName]; % ./small_database/chiens/chien
end

%%% Number of signals for training and testing in each class
switch trainingStrategy,
    case 'oneLeft',
        nbFileForTraining = sum(nbFilePerClass) - 1;
        nbFileForTesting  = 1;

        if allCrossValidation_Flag == 1,
            nbCrossvalidation = sum(nbFilePerClass);
        end

    case 'fiftyFifty',
        nbFileForTraining = ceil(nbFilePerClass/2);
        nbFileForTesting  = nbFilePerClass - nbFileForTraining;
end


% ----------------------------------------------------------------------------------------
% Start crossvalidation loops
%
% Input :   - nbCrossvalidation
%
% Output :  - h (waitbar handle)
%
% Functions used :  - 
% ----------------------------------------------------------------------------------------

h = waitbar(0, ['Iteration : 1/', int2str(nbCrossvalidation)], ...
            'Name', 'Progression',...
            'CreateCancelBtn', 'setappdata(gcbf, ''canceling'', 1)');
setappdata(h, 'canceling', 0);

for crossId = 1 : nbCrossvalidation,
    
    %%% If "Cancel" button from the waitbar is pushed, then exit from crossvalidation loop
    if getappdata(h, 'canceling'),
        beep;
        disp(['WARNING : Sound recognition process has been stopped at iteration ', ...
              int2str(crossId), '/' int2str(nbCrossvalidation), '.']);
        break;
    end
    
    
    % ------------------------------------------------------------------------------------
    % Training files selection
    % ------------------------------------------------------------------------------------
    
    %%% Generate indexes of the files to use for training and testing
    switch trainingStrategy,
        case 'oneLeft',
            % TO BE FILLED
            
        case 'fiftyFifty',
            fileIndexPerClass = cell(1, nbClass); % Preallocation
            for i = 1 : nbClass, 
                fileIndexPerClass{i} = randperm(nbFilePerClass(i)); % Random determination
                fileIndexPerClass{i} = 1 : nbFilePerClass(i);       % No random determination
            end
            
        otherwise,
            error('Unknown training strategy.');   
    end
    
    %%% Build the file list for training
    trainingFile = cell(sum(nbFileForTraining)+1, 1); % Preallocation
    trainingFile{1} = nbFileForTraining;
    for i = 1 : nbClass,
        trainingIndex                = fileIndexPerClass{i}(1:nbFileForTraining(i));
        firstId                      = sum(nbFileForTraining(1:i-1)) + 1;
        lastId                       = firstId + nbFileForTraining(i)-1;
        trainingFile((firstId:lastId)+1) = ...
                    genereateFileList(fileRootPath{i}, trainingIndex, fileExtension_Size);
    end

    
    % ------------------------------------------------------------------------------------
    % Training
    % ------------------------------------------------------------------------------------

    switch model,
        case 'Bayes',
            [meanMatrix, covMatrix, PCABasis, LDABasis] = ...
                 Training_Bayes(trainingFile, trainingSNR, featureType, PCA_dim, LDA_dim);
            % Save trained models to file
%             save ./Draft-Test/trainingPH.mat meanMatrix covMatrix PCABasis LDABasis;
            
        case 'GMM',
            
        case 'HMM+bayes',
            
        case 'HMM+GMM',
            
        otherwise,
            error('Unknown model type.');
    end
    
    
    % ------------------------------------------------------------------------------------
    % Testing files selection
    % ------------------------------------------------------------------------------------
    
    testingFile = cell(sum(nbFileForTesting)+1, 1); % Preallocation
    testingFile{1} = nbFileForTesting;
    for i = 1 : nbClass,
        testingIndex                 = fileIndexPerClass{i}(nbFileForTraining(i)+1:end);
        firstId                      = sum(nbFileForTesting(1:i-1)) + 1;
        lastId                       = firstId + nbFileForTesting(i)-1;
        testingFile((firstId:lastId)+1) = ...
                    genereateFileList(fileRootPath{i}, testingIndex, fileExtension_Size);
    end
    
    
    % ------------------------------------------------------------------------------------
    % Test the model parameters
    % ------------------------------------------------------------------------------------

    % Load trained models from file
    % load training;

    % Start Testing
    switch model,
        case 'Bayes',
            [membership, cert] = Testing_Bayes(testingFile, testingSNR, featureType, ...
                                               PCABasis, LDABasis, meanMatrix, covMatrix);
            
        case 'GMM',
            
        case 'HMM+bayes',
            
        case 'HMM+GMM',
            
        otherwise,
            error('Unknown model type.');
    end
    
    
    % ------------------------------------------------------------------------------------
    % Compute performance
    % ------------------------------------------------------------------------------------
    
%     % Determine Target Classification
%     target = [];
%     for j = 1:Class_Nbr, 
%         target = [target j*ones(1,Test_Sig_Nbr(j))]; 
%     end;
%   
%     % Calculate Confusion Matrix
%     New_Conf_mat = score(membership(1:sum(Test_Sig_Nbr(1:Class_Nbr))), target(1:sum(Test_Sig_Nbr(1:Class_Nbr))));
%     Conf_mat = Conf_mat + New_Conf_mat;
%     res(i) = sum(diag(New_Conf_mat))/sum(sum(New_Conf_mat));
%     perfo = sum(diag(Conf_mat))/sum(sum(Conf_mat));
%   
%     % Display Results
%     display(Conf_mat);
%     display(perfo);
    
    
    
    %%% Update waitbar
    waitbar_Label = ['Iteration : ', int2str(crossId), '/', int2str(nbCrossvalidation)];
    waitbar(crossId/nbCrossvalidation, h, waitbar_Label);
    
    
end % for - End of crossvalidation loop


% ----------------------------------------------------------------------------------------
% Clear workspace
% ----------------------------------------------------------------------------------------

delete(h); % Deleted waitbar
rmpath(genpath(toolbox_Path));


% --------------------------------- End of file ------------------------------------------
