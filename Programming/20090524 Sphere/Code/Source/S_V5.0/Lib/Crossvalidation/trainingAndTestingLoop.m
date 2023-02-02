% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Crossvalidation loop. This loop consists in 4 steps : 
% 1. Selecte features for training and testing process (step 2 and 3)
% 2. Buil model by training operations
% 3. Testing model
% 4. Compute learning performance
%
% Input
%   - feat [struct] Contains data, label and somes data properties.
%                   .nbClass     [int 1x1] number of class in database
%                   .className   [cell 1xc, str] Name of each class
%                   .nbFile      [int 1x1] number of file in all database
%                   .fileLabel   [int 1xf] file labels
%                   .nbFileC     [int 1xc] number of file per class
%                   .dim         [int 1x1] dimension of features
%                   .classFiId   [int 1xc] classes indexes view from file indexes
%                   .classTrFeId [int 1xc] classes indexes view from training feature indexes
%                   .classTeFeId [int 1xc] classes indexes view from testing feature indexes
%                   .fileTrFeId  [int 1xf] files indexes view from training feature indexes
%                   .fileTeFeId  [int 1xf] files indexes view from testing feature indexes
%
%                   .trFeat      [featl dxn] training feature data
%                   .trLabel     [int 1xn] label for each training feature
%                   .nbTrFeat    [int 1x1] number of training feature in all database
%                   .nbTrFeatC   [int 1xc] number of training feature per class
%                   .nbTrFeatF   [int 1xf] number of training feature per file
%
%                   .teFeat      [featl dxn] testing feature data
%                   .teLabel     [int 1xn] label for each testing feature
%                   .nbTeFeat    [int 1x1] number of testing feature in all database
%                   .nbTeFeatC   [int 1xc] number of testing feature per class
%                   .nbTeFeatF   [int 1xf] number of testing feature per file
%
%                   .toc         [dbl 1x1] features extraction time
%                   .type        [str 1x5] structure of the feature (typeA, typeM)
% 
%   - learningParam [struct] Contains all informations needed to define learning strategy
%                            .nbIt     [int 1x1]  Number of iterations for training and testing loop
%                            .strategy [dbl 1x1]  This number defines the strategy to adopt for 
%                                                 dividing between features which should be used for
%                                                 training and those used for testing.
%                                                   1  : training over all minus 1 files, testing 
%                                                        over the last file
%                                                   0  : same as strategy 1 but this time all the 
%                                                        crossvalidation are done
%                                                 0<x<1: training over x% of the database and 
%                                                        testing over the (1-x)% remaining
%                            .randFlag [bool 1x1] if true, features are randomly selected else not.
% 
%   - modelParam    [struct]  Feature extraction parameters
%                             .pca        [int 1x1] number of dimensions to keep in PCA reduction
%                             .lda        [int 1x1] number of dimensions to keep in LCA reduction
%                             .h_training [function handel] training function handel
%                             .h_testing  [function handel] testing function handel
%                             . ...       Other parameters are inputs for training fonction and
%                                         depend on the choise of this function, so they vary.   
%
% Output
%   - loopLog [array 1xit, struct] Contains all relevant data computed during each crossvalidation
%                                  loop. Each array element contains the data related to one
%                                  crossvalidation.
%                       .trFileId    [int 1xn] Training file id
%                       .teFileId    [int 1xm] Testing file id
%                       .model       [struct] Depend of selected model. See training related
%                                             function for more details.
%                       .membership  [int 1xm] Membership of testing feature after testing process.
%                       .certainties [dbl 1xm] Membership certainties of testing feature after
%                                              testing process.
%                       .stepConfMat [int cxc] Confusion matrix of a given crossvalidation loop
%                       .globConfMat [int cxc] Global confusion matrix of learning process.
%                       .stepPerf    [dbl 1x1] Performance of a given crossvalidation loop.
%                       .globPerf    [dbl 1x1] Global performance of learning process.
%                       .toc         [dbl 1x1] Time for each crossvalidation loop since beginning of
%                                              learning process.
%
%
% Author    : Pitch Corp.
% Date      : 2011.01.09
% Version   : 0.5.0
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function [loopLog,learningParam] = trainingAndTestingLoop(feat, learningParam, modelParam)

    iTic = tic;
    
    [learningParam, nbIt] = computeAdvancedLearningParam(feat, learningParam);

%     displayParamSummary(feat, learningParam);


    % -------------------------------------------------------------------------------------------- %
    % Preallocation
    % -------------------------------------------------------------------------------------------- %
    
    loopLog.trFileId    = zeros(1, learningParam.nbTrFile);
    loopLog.teFileId    = zeros(1, learningParam.nbTeFile);
    loopLog.model       = modelParam.h_training(feat, modelParam, 1);
    loopLog.membership  = zeros(1, learningParam.nbTrFile);
    loopLog.certainties = zeros(1, learningParam.nbTrFile);
    loopLog.stepConfMat = zeros(feat.nbClass, feat.nbClass);
    loopLog.globConfMat = zeros(feat.nbClass, feat.nbClass);
    loopLog.stepPerf    = 0;
    loopLog.globPerf    = 0;
    loopLog.toc         = 0;
    loopLog = repmat(loopLog, 1, nbIt);
    
    tocHist = zeros(1, nbIt);
    
    
    % -------------------------------------------------------------------------------------------- %
    % Initialization
    % -------------------------------------------------------------------------------------------- %
    
    globConfMat = zeros(feat.nbClass, feat.nbClass);
    
    % Build waitbar
    h = waitbar(0, ['Iteration : 1/',int2str(nbIt)], 'Name', 'Progression');
    
    
    % -------------------------------------------------------------------------------------------- %
    % Crossvalidation loop
    % -------------------------------------------------------------------------------------------- %
    
    for i = 1:nbIt,
        
        tic;
        
        % Select training and testing features
        [trFeat,teFeat,trFileId,teFileId] = selectFeatureSets(feat, learningParam);
       
        % Build training model with training features
%         model = modelParam.h_training(trFeat, modelParam);
        
        % Test model on testing features
%         [membership,certainties] = modelParam.h_testing(teFeat, model);
        
        %%% Compute and display learning performance
%         [stepConfMat,globConfMat] = computeConfusionMatrix(membership, certainties, globConfMat);
%         [stepPerf, globPerf] = displayPerformance(stepConfMat,globConfMat);

        %%% Save loop logs
%         loopLog(i).trFileId    = trFileId;
%         loopLog(i).teFileId    = teFileId;
%         loopLog(i).model       = model;
%         loopLog(i).membership  = membership;
%         loopLog(i).certainties = certainties;
%         loopLog(i).stepConfMat = stepConfMat;
%         loopLog(i).globConfMat = globConfMat;
%         loopLog(i).stepPerf    = stepPerf;
%         loopLog(i).globPerf    = globPerf;
        loopLog(i).toc         = toc(iTic);
        
        %%% TMP
        loopLog(i).globPerf = 98.4;
        %%%

        % Update waitbar
        waitbarUpdate(h, i, nbIt, tocHist);
        
    end
    
    % Close waitbar
    delete(h);
    

end


% EoF -------------------------------------------------------------------------------------------- %
