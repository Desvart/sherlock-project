% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% 
%
% Author    : Pitch Corp.
% Date      : 2010.11.15
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


% TODO ------------------------------------------------------------------------------------------- %
% - Detection
%
% - Autre m�thodes de r�ductions de dimension
% - LDA
% - Kernel LDA / PCA
%
% - 20 EM iterations
% - Split & Merge EM
%
% - Autre techniques de classification
% - HMM
%
% - rejection class and rejection methods
%
% - R�f�rences concernant les fonction bas niveaux
% - Commentaires
% - Documentation
% ------------------------------------------------------------------------------------------------ %


% ------------------------------------------------------------------------------------------------ %
% Workspace initialization
% ------------------------------------------------------------------------------------------------ %

clear all;
libPath = initWorkspace('./Lib/');


% ------------------------------------------------------------------------------------------------ %
% User settings
% ------------------------------------------------------------------------------------------------ %

%%% Database selection
dbPath = 3; % dim
% dbPath = '../database/db_Duf_5C/';
% dbPath = '../database/db_Duf_2C_Small/';

%%% Add noise to signal (snr(1) = training noise, snr(2) = testing noise)
snr(1) = 120;    %dB
snr(2) = 120;%snr(1); %dB

%%% Feature to extract
% spectrogram
featExtractParam = [1,2048,1/2]; % [Feature type, Window size, shift, file2plot];
% MFCC
% featExtractParam = [2,?]; % [Feature type, ?];

% file features to plot
% file2plot = {1:2,1:2,1:2};
file2plot = true;

%%% Learning parameter definition
%  1  : training over all minus 1 files, testing over the last file
%  0  : same as strategy 1 but this time all the crossvalidation are done
%0<x<1: training over x% of the database and testing over the (1-x)% remaining
learningParam = [0.1,false,2]; % [learning strategy, random flag, #crossvalidation]

% Feature reduction
reductionParam = [10,5]; % [PCA remaining dimension, LDA remaining dimension] - LDA NOT IMPLEMENTED

%%% Probability Density Function (PDF) model
% Bayes
model = 1;
% GMM
% model = [2,3,1e-6]; % [model type, #GMM, EM tolerance]


% ------------------------------------------------------------------------------------------------ %
% Script initialization
% ------------------------------------------------------------------------------------------------ %

% Extract features and statistics from database
db = databaseQuery(dbPath, snr, featExtractParam, file2plot);

% % Init script
[learningParam,h] = initScript(db, learningParam, featExtractParam, reductionParam, model, snr);


% ------------------------------------------------------------------------------------------------ %
% Start crossvalidation loops
% ------------------------------------------------------------------------------------------------ %

% nbMissedTraining = 0;
nbCval = learningParam(3);
cvalId = 0;
while cvalId < nbCval,
    
    % Update loop
    cvalId = loopUpdate(h, cvalId, nbCval);
 
    % Extract features
    [trFeat,teFeat] = featureQuery(db, learningParam, reductionParam, file2plot);
    
    %%% Training
%     modelParam = training(trainingFeature, reductionParam, model);
%     if ischar(modelParam) && strcmp(modelParam, 'stats:mvnpdf:BadCovariance'),
%         if reco.strategy ~= 0,
%             crossvalIndex = crossvalIndex - 1;
%         end
%         nbMissedTraining = nbMissedTraining + 1;
%         continue;
%     end
    
    % Testing
%     [membership, certainties] = testing(testingFeature, modelParam);
    
    % Compute recognition performance
%     performance = computePerformance(perfprop, membership);
    
    % Display performance
%     displayMessage(3, performance, database.className);
    
end % for - End of crossvalidation loop

% displayMessage(4, performance, database.className, nbCrossvalidation, nbMissedTraining);


% ------------------------------------------------------------------------------------------------ %
% Clear workspace
% ------------------------------------------------------------------------------------------------ %

% Remove waitbar
delete(h); 

% Delete added path
rmpath(genpath(libPath));


% EoF -------------------------------------------------------------------------------------------- %
