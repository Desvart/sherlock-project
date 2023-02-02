% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% 
%
% Author    : Pitch Corp.
% Date      : 2010.12.11
% Version   : 0.4.2
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

initConfig;


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
