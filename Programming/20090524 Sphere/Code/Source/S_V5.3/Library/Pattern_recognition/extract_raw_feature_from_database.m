function extract_raw_feature_from_database()
% EXTRACT_RAW_FEATURE_FROM_DATABASE Extract raw features from a sound database and stores them in 
%                                   the feature strucure.
%
% Synopsis:     generate_raw_feature_from_math_model()
%
% Inputs  : []
% Outputs : []

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.09.06  -  Copyleft ;-)
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
    iTic = tic;
    [nFeatureMax, featureDim] = compute_nFeatureMax(wavread(filePath{1}, 'size'));
    for iFile = 2 : nFile,
        nFeatureMax = nFeatureMax + compute_nFeatureMax(wavread(filePath{iFile}, 'size'));
        
    end
    str0 = process_status();
    fprintf([str0, 'preallocation process: ~%0.1d ms\n'], round(toc(iTic)));
            
    
    % --- Create waitbar
    waitbarHandle = waitbar(0, ['File being processed: : 1/',int2str(nFile)], ...
                    'Name', 'Feature extraction in progress...');

                 
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
    
    
    % --- Determine total number of feature and number of feature per class
    nTrainingFeature = sum(nTrainingFeaturePerFile);
    nTestingFeature  = sum(nTestingFeaturePerFile);
    
    nTrainingFeaturePerClass = determine_number_of_feature_in_each_class(nClass, nFilePerClass, nTrainingFeaturePerFile);
    if trainingSnr ~= testingSnr,
        nTestingFeaturePerClass = determine_number_of_feature_in_each_class(nClass, nFilePerClass, nTestingFeaturePerFile);
        
    else
        nTestingFeaturePerClass = nTrainingFeaturePerClass;
        
    end
    
     
    % --- Determine real label for each feature (Compute number of feature per class)
    trainingFeatureLabel = determine_feature_label(nTrainingFeature, nClass, nTrainingFeaturePerClass);
    testingFeatureLabel  = determine_feature_label(nTestingFeature,  nClass, nTestingFeaturePerClass);
    
      
    % --- Save data for further computation
    config_('filePath', filePath);
    
    pcaDim = config_('nDimPca');
    ldaDim = config_('nDimLda');
    
    feature.featureDim = size(trainingFeature, 1);
    if pcaDim > 0 && ldaDim > 0,
        feature.mappedFeatureDim = min(pcaDim, ldaDim);
    elseif xor(pcaDim == 0, ldaDim == 0),
        feature.mappedFeatureDim = max(pcaDim, ldaDim);
    elseif pcaDim == 0 && ldaDim == 0,
        feature.mappedFeatureDim = feature.featureDim;
    end

    feature.trainingFeature = trainingFeature;
    feature.trainingFeatureLabel = trainingFeatureLabel;
    feature.nTrainingFeature = nTrainingFeature;
    feature.nTrainingFeaturePerClass = nTrainingFeaturePerClass;
    feature.nTrainingFeaturePerFile = nTrainingFeaturePerFile;
    
    feature.testingFeature = testingFeature;
    feature.testingFeatureLabel = testingFeatureLabel;
    feature.nTestingFeature = nTestingFeature;
    feature.nTestingFeaturePerClass = nTestingFeaturePerClass;
    feature.nTestingFeaturePerFile = nTestingFeaturePerFile;
    
    feature_('load', feature);
    
    
    % --- Close waitbar
    delete(waitbarHandle);
%      dbstop in extract_raw_feature_from_database at 136           
end


function nSetFeaturePerClass = determine_number_of_feature_in_each_class(nClass, nFilePerClass, nSetFeaturePerFile)
    
% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.08.26  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    nSetFeaturePerClass = zeros(1, nClass); % Preallocation
    setFileId = cumsum([0, nFilePerClass]); % Init loop
    for iClass = 1 : nClass,
        nSetFeaturePerClass(iClass) = sum(nSetFeaturePerFile((setFileId(iClass)+1):setFileId(iClass+1)));
        
    end

end




function setFeatureLabel = determine_feature_label(nSetFeature, nClass, nSetFeaturePerClass)

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.08.26  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    setFeatureLabel = zeros(1, nSetFeature); %Preallocation
    stop = 0; % Init loop
    for iClass = 1 : nClass,
        start = stop + 1;
        stop = start + nSetFeaturePerClass(iClass) - 1;
        setFeatureLabel(start:stop) = iClass*ones(1, nSetFeaturePerClass(iClass));
    end

end














% EoF -------------------------------------------------------------------------------------------- %