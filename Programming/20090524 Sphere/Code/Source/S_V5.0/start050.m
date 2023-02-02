% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% 
%
% Author    : Pitch Corp.
% Date      : 2011.01.07
% Version   : 0.5.0
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
% - ICA (cf. AD)
% - SVM
% - AdaBoost
% - R�seau de Neurones
%
% - Autre type de mod�lisation
% - Autoregressive model
% - ARMA
%
% - rejection class and rejection methods
%
% - M�ler le GMM(1) avec Bayes et supprimer Bayes dans les options initiales
% - R�f�rences concernant les fonction bas niveaux
% - Commentaires
% - Documentation
% ------------------------------------------------------------------------------------------------ %


% ------------------------------------------------------------------------------------------------ %
% Workspace initialization
% ------------------------------------------------------------------------------------------------ %

close all; clear all; clc;
h_tic = tic;
libPath = initWorkspace('./Lib/');


% ------------------------------------------------------------------------------------------------ %
% Create feature structure
% ------------------------------------------------------------------------------------------------ %

%%% Generate feature create from gaussian models
% featParam.mu = [0 9 18];
featParam.mu = [[0 0]' [9 0]' [0 9]'];
% featParam.mu = [[0 0 0]' [9 0 0]' [0 0 9]'];
featParam.nbFileC = [20 30 10];
featParam.nbFeatF = 50;
rawFeat = generateFeat(featParam);

%%% Extract features from sound file coming from database
% dbProp.path         = '../../Database/db_Duf_2C_Small/';
% % dbProp.path         = '../../Database/db_Duf_5C/';
% dbProp.snr          = [120,121]; % [training SRN, testing SNR]
% 
% featParam.h_extract = @extract_STDFT;
% featParam.window    = sqrt(hann(1024, 'periodic'));
% featParam.shift     = 1/4;
% featParam.powThr    = 25; % dB
% featParam.channel   = channelSelection('Bark');
% 
% rawFeat = extractDBFeat(dbProp, featParam);

% Rearrange features
% feat = typeA(rawFeat);
feat = typeM(rawFeat);

%%% Plot raw features if their dimension is lower than 4 and display them in a pcolor plot
% plotSTDFT(feat);
% plotFeat(feat);

% Dispay some statistics about raw features 
%(distance interclass, intraclass, mat de cov des class, vecteur propre et valeur propre des class)
% displayRawFeatureStatistics(feat);


% ------------------------------------------------------------------------------------------------ %
% Training and testing loop - GMM
% ------------------------------------------------------------------------------------------------ %

%%% Learning parameters
%   1  : training over all minus 1 files, testing over the last file
%   0  : same as strategy 1 but this time all the crossvalidation are done
% 0<x<1: training over x% of the database and testing over the (1-x)% remaining
learningParam.nbIt     = 10;
learningParam.strategy = .5;
learningParam.randFlag = false;

%%% Reduction parameters
modelParam.pca = 10;
modelParam.lda = 5;

%%% Model parameters GMM
modelParam.h_training = @trainingGMM;
modelParam.h_testing  = @testingGMM;
modelParam.nbGMM      = 1;
modelParam.emTol      = 1e-6;

%%% Model parameters HMM
% modelParam.h_training = @trainingHMM;
% modelParam.h_testing  = @testingHMM;
% modelParam.nbState    = 3;
% modelParam.nbGMM      = 1;
% modelParam.emTol      = 1e-6;


[loopLog,learningParam] = trainingAndTestingLoop(feat, learningParam, modelParam);


% ------------------------------------------------------------------------------------------------ %
% Analyse learning statistics
% ------------------------------------------------------------------------------------------------ %

% Compute learning statistics
% stat = computeLearningStat(loopLog);
stat.toc = 0;

% Display learning statistics
% plotLearningStat(stat);

% ------------------------------------------------------------------------------------------------ %
% Save logs
% ------------------------------------------------------------------------------------------------ %

deleteLogFile(1, 0);

if ~exist('dbProp', 'var'),
    dbProp = [];
end

saveLogFile(dbProp, featParam, feat, learningParam, modelParam, loopLog, stat, h_tic);


% ------------------------------------------------------------------------------------------------ %
% Clean workspace
% ------------------------------------------------------------------------------------------------ %

rmpath(genpath(libPath));



% EoF -------------------------------------------------------------------------------------------- %
