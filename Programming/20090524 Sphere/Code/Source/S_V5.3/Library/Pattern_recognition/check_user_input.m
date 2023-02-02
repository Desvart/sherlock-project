function chrono = check_user_input()
% CHECK_USER_INPUT
%
% Synopsis:     check_user_input();
%
% Inputs  :
% Outputs : 

% Notes: 

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.08.22  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %
% dbstop in check_user_input at 15
    if config_('shouldCheckUserInput'),

        % --- Check validity and coherency for script flags and previously saved configuration
        
        
        % --- Check validity and coherency for path definition
        if ~exist(config_('outputPath'), 'dir'),
            mkdir(config_('outputPath'));
        end
        
        
        % --- Check validity and coherency for database configuration (SNR > 0, meanDim == covDim, etc.)
        if isempty(config_('databaseName')),            
            [nDim, nClass] = size(config_('classMean'));
            classCov = config_('classCov');
            classCovSize = size(classCov);
            if length(classCovSize) ~= 3 || classCovSize(3) ~= nClass || ...
               classCovSize(1) ~= nDim || classCovSize(2) ~= nDim,
                error('ERROR in classCov definition. Size or type inappropriated.')
                
            end
            
            for iClass = 1 : nClass,
                if ~is_cov_matrix(classCov(:, :, iClass)),
                    error('ERROR in classCov definition. Covariance matrix of class %d is not a positive-semidefinite matrix.');
                    
                end
            end
            
            nFilePerClass = config_('nFilePerClass');
            if ~is_real_vector(nFilePerClass) && length(nFilePerClass) ~= nClass,
                error('ERROR in nFilePerClass definition.');
                
            end
            
            nFeaturePerFile = config_('nFeaturePerFile');
            
            if ~is_real_scalar(nFeaturePerFile) && ~is_real_vector(nFeaturePerFile),
                error('ERROR in nFeaturePerFile definition.');
                
            elseif any(nFeaturePerFile <= 0),
                error('ERROR in nFeaturePerFile definition. Some values are smaller or egale to 0.');
                
            end       
            
        else
            trainingSnr = config_('trainingSnr');
            if ~is_real_scalar(trainingSnr) || trainingSnr <= 0 || trainingSnr > 200,
                error('config.trainingSnr should be a real scalar value between 0 and 200 dB.');
            end
            
            testingSnr = config_('testingSnr');
            if ~is_real_scalar(testingSnr) || testingSnr <= 0 || testingSnr > 200,
                error('config.testingSnr should be a real scalar value between 0 and 200 dB.');
            end
            
        end
        
        
        % --- Check validity and coherency for feature extraction parameters
        %%% extractionType
        extractionType = config_('extractionType');
        if ~is_string(extractionType),
            error('ERROR in extractionType definition. ''extractionType'' should be a string.');
        end
        
        if ~exist([extractionType, '_extraction'], 'file') || ~exist([extractionType, '_extraction0'], 'file'),
            error('ERROR in extractionType definition. ''%s'' extraction type does not exist.', extractionType);
        end
        
        %%% stdftWindow
        stdftWindow = config_('stdftWindow');
        if ~is_real_vector(config_('stdftWindow')),
            error('ERROR in stdftWindow definition. ''stdftWindow'' should be a real vector.'); 
        end
        
        if ~is_pow2(length(stdftWindow)),
            error('ERROR in stdftWindow definition. ''stdftWindow'' size should be a power of 2.');
        end
        
        %%% stdftShift
        stdftShift = config_('stdftShift');
        if ~is_real_scalar(stdftShift),
            error('ERROR in stdftShift definition. ''stdftShift'' should be a real scalar.'); 
        end
        
        if stdftShift < 0 || stdftShift >= 1,
            error('ERROR in stdftShift definition. ''stdftShift'' should be between [0, 1[.'); 
        end
        
        if ~is_pow2(inv(stdftShift)),
            error('ERROR in stdftShift definition. ''stdftShift'' should be a power of 2 (inv).');
        end
        
        %%% stdftPoweThreshold
        stdftPowerThreshold = config_('stdftPowerThreshold');
        if ~is_real_scalar(stdftPowerThreshold),
            error('ERROR in stdftPowerThreshold definition. ''stdftPowerThreshold'' should be a real scalar.'); 
        end
        
        if stdftPowerThreshold < 0,
            error('ERROR in stdftPowerThreshold definition. ''stdftPowerThreshold'' should be >= 0.');
        end
        
        %%% stdftChannelName
        stdftChannelName = config_('stdftChannelName');
        if ~is_string(stdftChannelName),
            error('ERROR in stdftChannelName definition. ''stdftChannelName'' should be a string.');
        end
        
        if ~isempty(stdftChannelName),
            if ~any(strcmpi(stdftChannelName, channel_selection())),
                error('ERROR in stdftChannelName definition. ''%s'' channel name does not exist.', stdftChannelName);
                
            end
        end
        
        %%% Dimensionality reduction
        nDimPca = config_('nDimPca');
        if ~is_real_scalar(nDimPca),
            error('ERROR in nDimPca definition. ''nDimPca'' should be a real scalar.'); 
        end
        
        featureDim = stdft_extraction0();
        if nDimPca < 0 || nDimPca >= featureDim,
            error('ERROR in nDimPca definition. nDimPca should be between [0, %d[ (%s feature type)', featureDim, extractionType);
        end
        
        nDimLda = config_('nDimLda');
        if ~is_real_scalar(nDimLda),
            error('ERROR in nDimLda definition. ''nDimLda'' should be a real scalar.'); 
        end
        
        if nDimLda < 0 || nDimLda >= nDimPca,
            error('ERROR in nDimLda definition. nDimLda should be between [0, nDimPca=%d[', nDimPca);
        end
        
        
        % --- Check validity and coherency for learning parameters
        %%% learningStrategy
        learningStrategy = config_('learningStrategy');
        if ~is_real_scalar(learningStrategy) || learningStrategy < 0 || learningStrategy > 1,
            error('config.learningStrategy should be a real scalar value between 0 and 1.');
        end
        
        %%% isRandom
        isRandom = config_('isRandom');
        if isRandom ~= true && isRandom ~= false,
            error('config.isRandom should be a boolean (only true or false values are accepted).');
        end
        
        %%% nTraining
        nTraining = config_('nTraining');
        if ~is_real_scalar(nTraining),
            error('ERROR in nTraining definition. nTraining should be a real scalar.');
        end
        
        nFile = database_('nFile');
        switch learningStrategy,
            case 0,
                if nTraining ~= nFile,
                    config_('nTraining', nFile);
                    
                end
                
            case 1,
                if nTraining <= 0 || nTraining > nFile,
                    config_('nTraining', nFile);
                    warning('PatRec:ReformatedUserInput', 'config.nTraining has an inapproriated value. According to selected learning strategy (1), its value has been set to database.nFile.');
                    
                end
                
            otherwise,
                % Combinatory with no repetition and no order: (x,y) = x!/(y!*(x-y)!)
                nFilePerClass = database_('nFilePerClass');
                nTestingFilePerClass = database_('nTestingFilePerClass');
                nTrainingMin = factorial(min(nFilePerClass))/(factorial(min(nTestingFilePerClass))*factorial(min(nFilePerClass)-min(nTestingFilePerClass)));
                if  nTraining <= 0 || nTraining > nTrainingMin,
                    config_('nTraining', nTrainingMin);
                    warning('PatRec:ReformatedUserInput', 'config.nTraining has an inapproriated value. According to selected learning strategy (]0,1[), its value has been set to nTrainingMin = %d.', nTrainingMin);
                    
                end
        end
           
        
        % --- Check validity and coherency for model parameters
        %%% modelType
        modelType = config_('modelType');
        if ~is_string(modelType),
            error('ERROR in modelType definition. ''modelType'' should be a string.');
        end
        
        if ~exist([modelType, '_training'], 'file') || ~exist([modelType, '_testing'], 'file'),
            error('ERROR in modelType definition. ''%s'' model type does not exist.', modelType);            
        end
        
        %%% GMM model parameters
        gmmNGmm = config_('gmmNGmm');
        if ~is_real_scalar(gmmNGmm) || gmmNGmm < 0,
            error('ERROR in gmmNGmm definition. ''gmmNGmm'' should be a real scalar > 0.');
        end
        
        gmmEmTolerance = config_('gmmEmTolerance');
        if ~is_real_scalar(gmmEmTolerance) || gmmEmTolerance < 0,
            error('ERROR in gmmEmTolerance definition. ''gmmEmTolerance'' should be a real scalar > 0.');
        end
        
        %%% HMM model parameters
        hmmNState = config_('hmmNState');
        if ~is_real_scalar(hmmNState) || hmmNState < 0,
            error('ERROR in hmmNState definition. ''hmmNState'' should be a real scalar > 0.');
        end
        
        hmmNGmm = config_('hmmNGmm');
        if ~is_real_scalar(hmmNGmm) || hmmNGmm < 0,
            error('ERROR in hmmNGmm definition. ''hmmNGmm'' should be a real scalar > 0.');
        end
        
        hmmEmTolerance = config_('hmmEmTolerance');
        if ~is_real_scalar(hmmEmTolerance) || hmmEmTolerance < 0,
            error('ERROR in hmmEmTolerance definition. ''hmmEmTolerance'' should be a real scalar > 0.');
        end
    end
end %%% End of main function

% EoF -------------------------------------------------------------------------------------------- %
