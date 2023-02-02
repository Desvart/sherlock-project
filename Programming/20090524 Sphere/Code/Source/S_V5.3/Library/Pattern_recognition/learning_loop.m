% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Inputs : []  
%
% Outputs
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


function [learningLog, chrono] = learning_loop()
% LEARNING_LOOP  
%
% Synopsis:     generate_raw_feature_from_math_model()

% Notes: 

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.09.06  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %   
    
    % --- Display process status and launch function chronometer
    chronoTic = tic;
    process_status();
    
    
    % --- Init
    nTraining               = config_('nTraining');
    nDimPca                 = config_('nDimPca');
    nDimLda                 = config_('nDimLda');
    
    nClass                  = database_('nClass');
    nTrainingFile           = database_('nTrainingFile');
    nTestingFile            = database_('nTestingFile');
    trainingFileId          = database_('trainingFileId');
    testingFileId           = database_('testingFileId');
    
    nTrainingFeature        = feature_('nTrainingFeature');
    nTestingFeature         = feature_('nTestingFeature');
    nTrainingFeaturePerFile = feature_('nTrainingFeaturePerFile');
    nTrainingFeaturePerClass = feature_('nTrainingFeaturePerClass');
    nTestingFeaturePerFile  = feature_('nTestingFeaturePerFile');
    allTrainingFeature      = feature_('trainingFeature');
    allTrainingLabel        = feature_('trainingFeatureLabel');
    allTestingFeature       = feature_('testingFeature');
    allTestingLabel         = feature_('testingFeatureLabel');
    featureDim              = feature_('featureDim');
    mappedFeatureDim        = feature_('mappedFeatureDim');

    modelType = config_('modelType');
    training_ = str2func([modelType, '_training']);
    testing_  = str2func([modelType, '_testing']);

    
    % --- Preallocation
    mapping = zeros(nTraining, mappedFeatureDim+2, featureDim);
    if strcmp(modelType, 'gmm') || strcmp(modelType, 'bayes'),
        model = zeros(nTraining, nClass, config_('gmmNGmm'), mappedFeatureDim, mappedFeatureDim+1);
    end
%     if strcmp(modelType, 'hmm'),
%         model   = zeros(nTraining, config_('gmmNGmm')*(feature_('featureDim')+1), feature_('featureDim'));
%     end
%     membership  = zeros(nTraining, feature_('nTestingFeature'));
%     certainty   = zeros(nTraining, feature_('nTestingFeature'));
%     confusionMatrix = zeros(nTraining, database_('nClass'), database_('nClass'));
    tocHist = zeros(1, nTraining);
    

    % --- Build waitbar
    h = waitbar(0, ['Iteration : 1/', int2str(nTraining)], 'Name', 'Progression');
    
    
    % --- Crossvalidation loop
    for iTraining = 1 : nTraining,
        
        tic;
        
        % --- Training
        
        
        %%% Select feature sets
        trainingFeatureId   = convert_fileId_to_featureId(trainingFileId(iTraining,:), nTrainingFile, nTrainingFeaturePerFile);
        trainingFeature   	= allTrainingFeature(:, trainingFeatureId);
        trainingLabel      	= allTrainingLabel(trainingFeatureId);

        
        %%% Normalize and reduce dimension
        [trainingFeature, mapping(iTraining,:,:)] = build_mapping(trainingFeature, trainingLabel, nTrainingFeature, nDimPca, nDimLda);
%         feature_analysis(trainingFeature, testingFeature);        
        

        %%% Training
        if iTraining > 1,
            model(iTraining,:,:,:,:) = training_(trainingFeature, trainingLabel, nClass, mappedFeatureDim, nTrainingFeaturePerClass, model(iTraining-1,:,:,:,:));
        else
            model(iTraining,:,:,:,:) = training_(trainingFeature, trainingLabel, nClass, mappedFeatureDim, nTrainingFeaturePerClass);
        end

        
        % --- Testing
        
        
        %%% Select feature sets
        testingFeatureId    = convert_fileId_to_featureId(testingFileId(iTraining,:), nTestingFile, nTestingFeaturePerFile);
        testingFeature      = allTestingFeature(:, testingFeatureId);
        testingLabel        = allTestingLabel(testingFeatureId);
        
        
        %%% Normalize and reduce dimension
        testingFeature = apply_mapping(testingFeature, reshape(mapping(iTraining,:,:), mappedFeatureDim+2, featureDim));
        
%         dbstop in learning_loop at 133
        %%% Testing
        [membership(iTraining, :), certainty(iTraining, :)] = testing_(testingFeature, model(iTraining,:,:,:,:), nClass, nTestingFeature, mappedFeatureDim);
        
        
        % --- Compute and display confusion matrix
%         confusionMatrix(iTraining, :, :) = compute_confusion_matrix((iTraining, :));
%         display_loop_result(confusionMatrix(), certainty(iTraining, :));


        % --- Update waitbar
        tocHist = waitbar_update(h, iTraining, nTraining, tocHist);
        
    end
    
    
    % --- Export data
    learningLog.mapping     = mapping;
    learningLog.model       = model;
%     learningLog.membership  = membership;
%     learningLog.certainty   = certainty;
%     learningLog.confusionMatrix   = confusionMatrix;

    
    % --- Close waitbar
    delete(h);
    
    
    % --- Display process status 
    process_status(toc(chronoTic));

end




function featureId = convert_fileId_to_featureId(fileId, nFile, nFeaturePerFile)

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.09.02  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %  

    featureAId = [0, cumsum(nFeaturePerFile)];

    nFeature = sum(nFeaturePerFile(fileId));
    featureId = zeros(1, nFeature); % Preallocation
    stop = 0;
    for iFile = 1 : nFile,
        start = stop + 1;
        stop = start + nFeaturePerFile(fileId(iFile)) - 1;
        featureId(start:stop) = featureAId(fileId(iFile)) + (1:nFeaturePerFile(fileId(iFile)));
    end
end










% EoF -------------------------------------------------------------------------------------------- %
