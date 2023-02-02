function extract_raw_feature_from_database()
% EXTRACT_RAW_FEATURE_FROM_DATABASE Extract raw features from a sound database and stores them in 
%                                   the feature strucure.
%
% Synopsis:     generate_raw_feature_from_math_model()
%
% Inputs  : []
% Outputs : []

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.04  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % --- Extract some usefull values for extraction process
    filePath = database_('filePath');
    nClass = database_('nClass');
    nFile = database_('nFile');
    nFilePerClass = database_('nFilePerClass');
    trainingSnr  = config_('trainingSnr');
    testingSnr   = config_('testingSnr');
    extract_feature_from_signal = config_('extract_feature_from_signal');
    
              
    % --- Create waitbar
    waitbarHandle = waitbar(0, ['File being processed: : 1/',int2str(nFile)], ...
                    'Name', 'Feature extraction in progress...');
                
                
	% --- 
    trainingFeature = []; % Preallocations
    testingFeature  = []; % Preallocations
    nTrainingFeaturePerFile = zeros(1, nFile); % Preallocations
    nTestingFeaturePerFile  = zeros(1, nFile); % Preallocations
    for iFile = 1:nFile,
        
        % --- Extract signal from file
        [signal, fs] = extract_signal_from_file(filePath{iFile}); 
        
        % --- For training set
        noisedSignal = add_noise(signal, trainingSnr); % Add noise to signal
        [trainingFeatureForThisFile, nTrainingFeaturePerFile(iFile)] = ...
                            extract_feature_from_signal(noisedSignal, fs); % Extract feature vectors for this file
        trainingFeature = [trainingFeature, trainingFeatureForThisFile]; %#ok<AGROW>
        
        % --- For testing set
        if trainingSnr ~= testingSnr,
            noisedSignal = add_noise(signal, testingSnr); % Add noise to signal
            [testingFeatureForThisFile, nTestingFeaturePerFile(iFile)] = ...
                                extract_feature_from_signal(noisedSignal, fs); % Extract feature vectors for this file
            testingFeature = [testingFeature, testingFeatureForThisFile]; %#ok<AGROW>
        end
        
        % --- Update waitbar
        waitbarLabel = sprintf('File being processed : %d/%d', min(iFile+1, nFile), nFile);
        waitbar(iFile/nFile, waitbarHandle, waitbarLabel);
        
    end
    
    % --- 
    if trainingSnr == testingSnr,
        nTestingFeaturePerFile = nTrainingFeaturePerFile;
        testingFeature = trainingFeature;
    end
    
    % --- Compute total number of feature
    nTrainingFeature = sum(nTrainingFeaturePerFile);
    nTestingFeature  = sum(nTestingFeaturePerFile);
    
    % --- Determine real label for each feature (Compute number of feature per class)
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
