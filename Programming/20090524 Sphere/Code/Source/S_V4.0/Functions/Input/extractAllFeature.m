function database = extractAllFeature(databasePath, snr, featureType)

    %%% Extact the number of class and their names from the database
    [nbClass,className] = folderContents(databasePath);
    
    
    nbFilePerClass   = zeros(nbClass, 1); % Preallocation
    nbFeaturePerClass= zeros(nbClass, 1); % Preallocation
    feature          = [];                % Preallocation
    nbFeaturePerFile = [];                % Preallocation
    for i = 1:nbClass,
        
        %%% Extract the number of files and the names of those files for this class.
        [nbFile,fileName] = folderContents([databasePath,className{i}]);
        
        %%% For each file
        nbFeature    = zeros(nbFile, 1); % Preallocation
        classFeature = [];               % Preallocation
        for j = 1:nbFile,
            
            %%% Extract signal
            filePath    = [databasePath,className{i},'/',fileName{j}];
            [signal,fs] = extractSignal(filePath);

            %%% Add noise to signal
            signal = addNoise(signal, snr);
            
            %%% Extract feature vectors for this file
            switch featureType,

                %%% Spectrogram features
                case 'spectrogram', 
                    [fileFeature,nbFeature(j)] = featureExtraction_spectrogram(signal, fs);

                %%% MFCC features
                case 'MFCC', 
                    [fileFeature,nbFeature(j)] = featureExtraction_MFCC(signal, fs);

            end

            %%% Concatenate all features for this class
            classFeature = [classFeature,fileFeature]; %#ok<AGROW>

        end %for j = 1:nbFile,
        
        %%% Concatenate all features
        feature = [feature,classFeature]; %#ok<AGROW>
        
        
        nbFilePerClass(i)       = nbFile;
        nbFeaturePerClass(i)    = sum(nbFeature);
        nbFeaturePerFile        = [nbFeaturePerFile;nbFeature]; %#ok<AGROW>
        
    end %for i = 1:nbClass
    
    %%% Determine target class for each feature vector
    [target,nbFeature] = determineFeatureTarget(nbClass, nbFeaturePerClass);  
    
    
    database.feature            = feature;
    database.target             = target;
    database.nbFeaturePerFile   = nbFeaturePerFile;
    database.nbFeaturePerClass  = nbFeaturePerClass;
    database.nbFeature          = nbFeature;
    database.nbDim              = size(feature, 1);
    database.nbClass            = nbClass;
    database.nbFile             = sum(nbFilePerClass);
    database.nbFilePerClass     = nbFilePerClass;

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NESTED FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% FUNCTION --------------------------------------------------------------------------------------- %
% A folder can contain sub-folders and files. This function counts the number of elements
% (sub-folders and files) that are contained in a folder and gives their names.
% ------------------------------------------------------------------------------------------------ %

function [nbElements, elementNames] = folderContents(folderPath)

    elementNames = dir(folderPath);
    elementNames = {elementNames.name}'; % Select elements names and put them into column
    
    % Next operation find hidden files by looking the first character of the file name. If
    % this is a dot, then this is a hidden file (on Mac and linux OS).
    elementNames = elementNames(~strncmp(elementNames, '.', 1));
    
    nbElements   = length(elementNames);
    
end


% FUNCTION --------------------------------------------------------------------------------------- %
% Extract data from a wave-file. Data are in their native form but cast in double.
% Usually for wave-file the native form is 2^16 signed integer (-2^15:2^15-1 == -32768:32767)
% ------------------------------------------------------------------------------------------------ %

function [signal,fs] = extractSignal(signalPath)

    [signal,fs] = wavread(signalPath, 'native');
    signal      = double(signal');
    
end


% FUNCTION --------------------------------------------------------------------------------------- %
% This function adds white gaussian random noise to the input signal to reach specified SNR.
% ------------------------------------------------------------------------------------------------ %

function noisedSignal = addNoise(signal, snr)

    % Note : For white Gaussian noise, the level corresponds to the variance
    %        if n gaussian white noise => var(n) = sum(n.^2)/length(n)
   
    signalSize   = length(signal);
    soundLevel   = 10*log10(sum(signal.^2)/signalSize); % Sound level (in average)
    noiseLevel   = soundLevel - snr;                    % Noise level
    noiseSigma   = 10^(noiseLevel/20);                  % Standard deviation of the noise
    noise        = noiseSigma * randn(1, signalSize);   % Noise generation for specified SNR
    noisedSignal = signal + noise;                      % Add noise
    
end


% FUNCTION --------------------------------------------------------------------------------------- %
% Generate a label vector associated with each feature.
% ------------------------------------------------------------------------------------------------ %

function [target,nbFeature] = determineFeatureTarget(nbClass, nbFeaturePerClass)
    
    %%% Total number of feature
    nbFeature = sum(nbFeaturePerClass);
    
    target = zeros(1, nbFeature); % Preallocation
    stop = 0; % Initialization
    for i = 1:nbClass,
        start = stop + 1;
        stop  = start + nbFeaturePerClass(i) - 1;
        target(start:stop) = i*ones(1, nbFeaturePerClass(i));
    end
    
end



% EoF -------------------------------------------------------------------------------------------- %
