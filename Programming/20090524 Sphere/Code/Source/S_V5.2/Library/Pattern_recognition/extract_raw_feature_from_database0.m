function extract_raw_feature_from_database0()
% EXTRACT_RAW_FEATURE_FROM_DATABASE Extract raw features from a sound database and stores them in 
%                                   the feature strucure.
%
% Synopsis:     generate_raw_feature_from_math_model()
%
% Inputs  : []
% Outputs : []

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.14  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % --- Extract some usefull values for extraction process
    filePath        = database_('filePath');
    nClass          = database_('nClass');
    nFile           = database_('nFile');
    nFilePerClass   = database_('nFilePerClass');
    
    trainingSnr     = config_('trainingSnr');
    testingSnr      = config_('testingSnr');
    
    extractionType              = config_('extractionType');
    extract_feature_from_signal = str2func([extractionType, '_extraction']);
    compute_nFeatureMax         = str2func([extractionType, '_extraction0']);
    
    
    % --- Preallocation - compute nFeatureMax
    [nFeatureMax, featureDim] = compute_nFeatureMax(wavread(filePath{1}, 'size'));
    for iFile = 2 : nFile,
        nFeatureMax = nFeatureMax + compute_nFeatureMax(wavread(filePath{iFile}, 'size'));
        
    end
            
    
    % --- Create waitbar
    waitbarHandle = waitbar(0, ['File being processed: : 1/',int2str(nFile)], ...
                    'Name', 'Feature extraction in progress...');

%        dbstop in extract_raw_feature_from_database0 at 48                    
	% --- 
    trainingFeature = nan(featureDim, nFeatureMax); % Preallocations
    testingFeature  = nan(featureDim, nFeatureMax); % Preallocations
    nTrainingFeaturePerFile = zeros(1, nFile);      % Preallocations
    nTestingFeaturePerFile  = zeros(1, nFile);      % Preallocations
    trainingStop = 0; % Loop init
    testingStop  = 0; % Loop init
    for iFile = 1 : nFile,
        
        %%% Extract signal from file
        [signal, fs] = extract_signal_from_file(filePath{iFile}); 
        
        %%% For training set
        noisedSignal = add_noise(signal, trainingSnr); % Add noise to signal
        [trainingFeatureForThisFile, nTrainingFeaturePerFile(iFile)] = extract_feature_from_signal(noisedSignal, fs); % Extract feature vectors for this file
                        
        trainingStart = trainingStop + 1;
        trainingStop  = trainingStart + nTrainingFeaturePerFile(iFile) - 1;
        trainingFeature(:, trainingStart:trainingStop) = trainingFeatureForThisFile;
        
        %%% For testing set
        if trainingSnr ~= testingSnr,
            noisedSignal = add_noise(signal, testingSnr); % Add noise to signal
            [testingFeatureForThisFile, nTestingFeaturePerFile(iFile)] = extract_feature_from_signal(noisedSignal, fs); % Extract feature vectors for this file
                            
            testingStart = testingStop + 1;
            testingStop  = testingStart + nTestingFeaturePerFile(iFile) - 1;
            testingFeature(:, testingStart:testingStop) = testingFeatureForThisFile;
        end
        
        %%% Update waitbar
        waitbarLabel = sprintf('File being processed : %d/%d', min(iFile+1, nFile), nFile);
        waitbar(iFile/nFile, waitbarHandle, waitbarLabel);
        
    end
    
    
    % --- Remove remaining training NaN-values due to preallocation
     trainingFeature = trainingFeature(:, ~isnan(trainingFeature(1,:)));
    
     
    % --- Depending on training and testing SNR, copy training feature to testing feature or remove
    % remaining testing NaN-values due to preallocation
    if trainingSnr == testingSnr,
        nTestingFeaturePerFile = nTrainingFeaturePerFile;
        testingFeature = trainingFeature;
        
    else
        testingFeature = testingFeature(:, ~isnan(testingFeature(1,:)));
        
    end
    
    
    % --- Compute total number of feature
    nTrainingFeature = sum(nTrainingFeaturePerFile);
    nTestingFeature  = sum(nTestingFeaturePerFile);
    
       dbstop in extract_raw_feature_from_database0 at 108  
     
       
       
       
       
       
       
    % --- Determine number of feature per class
    
    nTrainingFeaturePerClass = zeros(1, nClass); % Preallocations
    nTestingFeaturePerClass  = zeros(1, nClass); % Preallocations
    trainingFileId = cumsum([0, nFilePerClass]); % Init loop
    testingFileId  = cumsum([0, nFilePerClass]); % Init loop
    for iClass = 1 : nClass,
        nTrainingFeaturePerClass(iClass) = sum(nTrainingFeaturePerFile((trainingFileId(iClass)+1):trainingFileId(iClass+1)));
        
        if trainingSnr == testingSnr,
            nTestingFeaturePerClass(iClass) = sum(nTestingFeaturePerFile((testingFileId(iClass)+1):testingFileId(iClass+1)));
            
        else
            nTestingFeaturePerClass(iClass) = nTrainingFeaturePerClass(iClass);
            
        end
    end
       
    % --- Determine real label for each feature (Compute number of feature per class)
    for iTrainingFeature = 1 : nTrainingFeature,
        
      ;  
    end
    
    
    
    
    
    
    [trainingFeatureLabel, nTrainingFeaturePerClass,...
     testingFeatureLabel,  nTestingFeaturePerClass] = determine_feature_label(nClass, ...
          nFilePerClass, nTrainingFeature, nTestingFeature, nTrainingFeaturePerFile, ...
          nTestingFeaturePerFile, trainingSnr, testingSnr);
    
      
    % --- Save data for further computation
    config_('filePath', filePath);
    
    feature_('nClass', nClass);
    feature_('nFile', nFile);
    feature_('nFilePerClass', nFilePerClass);
    feature_('featureDim', size(trainingFeature, 1));
    
    feature_('trainingFeature', trainingFeature);
    feature_('trainingFeatureLabel', trainingFeatureLabel);
    feature_('nTrainingFeature', nTrainingFeature);
    feature_('nTrainingFeaturePerClass', nTrainingFeaturePerClass);
    feature_('nTrainingFeaturePerFile', nTrainingFeaturePerFile);
    
    feature_('testingFeature', testingFeature);
    feature_('testingFeatureLabel', testingFeatureLabel);
    feature_('nTestingFeature', nTestingFeature);
    feature_('nTestingFeaturePerClass', nTestingFeaturePerClass);
    feature_('nTestingFeaturePerFile', nTestingFeaturePerFile);
    
    
    % --- Close waitbar
    delete(waitbarHandle);
                
end



















% EoF -------------------------------------------------------------------------------------------- %