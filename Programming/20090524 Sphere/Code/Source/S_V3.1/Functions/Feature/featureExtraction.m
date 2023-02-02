% inputs
% 
% - file      .nbFile
%             .path
%             .nbFilePerClass
%             .nbClass
% 
% outputs
% 
% - feature   .data
%             .target
%             .nbFeaturePerFile
%             .nbFeaturePerClass
%             .nbFeature
%             .nbClass
%             .nbDim



% ------------------------------------------------------------------------------------------------ %
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


% function [feature, target, nbTokenPerClass, nbTokenPerFile] = featureExtraction(filePath, SNR, featureType)
function feature = featureExtraction(file, snr, model)
    
    nbFile      = file.nbFile;
    filePath    = file.path;
    featureType = model.featureType;
    nbClass     = file.nbClass;
    
    nbFeaturePerFile = zeros(nbFile, 1); % Preallocation
    featureData      = [];
    
    % ----------------------------------------------------------------------------------------------
    % For each training or testing file
    % ----------------------------------------------------------------------------------------------

    for i = 1 : nbFile,
        
        % ------------------------------------------------------------------------------------------
        % Extract signal
        % ------------------------------------------------------------------------------------------
        
        [signal, fs] = extractSignal(filePath{i});
        
        
        % ------------------------------------------------------------------------------------------
        % Add noise to signal
        % ------------------------------------------------------------------------------------------
        
        signal = addNoise(signal, snr);
        
        
        % ------------------------------------------------------------------------------------------
        % Extract feature tokens
        % ------------------------------------------------------------------------------------------
        
        switch featureType,
            
            %%% spectrogram
            case 'spectrogram', 
                [fileFeature, nbFeaturePerFile(i)] = featureExtraction_spectrogram(signal, fs);
            
            %%% MFCC    
            case 'MFCC', 
                [fileFeature, nbFeaturePerFile(i)] = featureExtraction_MFCC(signal, fs);
                
        end
        
        %%% Concatenate all tokens
        featureData = [featureData, fileFeature]; %#ok<AGROW>
        
    end

    
    % ----------------------------------------------------------------------------------------------
    % Determine target class for each frame
    % ----------------------------------------------------------------------------------------------
    
    [target, nbFeaturePerClass, nbFeature] = determineTargetPerFeature(nbFeaturePerFile, nbClass, file.nbFilePerClass);
    
    
    
    
    feature.data                = featureData;
    feature.target              = target;
    feature.nbFeaturePerFile    = nbFeaturePerFile;
    feature.nbFeaturePerClass   = nbFeaturePerClass;
    feature.nbFeature           = nbFeature;
    feature.nbDim               = size(featureData, 1);
    feature.nbClass             = nbClass;
    feature.nbFile              = nbFile;
    feature.nbFilePerClass      = file.nbFilePerClass;
    
    
end %function



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
%                                       NESTED FUNCTION                                            %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %



% ---------------------------------------- FUNCTION ---------------------------------------------- %
% 
% Function : 
% 
% ------------------------------------------------------------------------------------------------ %

function [signal, fs] = extractSignal(signalPath)

    [signal, fs] = wavread(signalPath, 'native');
    signal = double(signal);
    
end



% ---------------------------------------- FUNCTION ---------------------------------------------- %
% 
% This function adds white gaussian random noise to the input signal to reach specified SNR.
% 
% ------------------------------------------------------------------------------------------------ %


function signal = addNoise(signal, snr)

    % Note : For white Gaussian noise, the level corresponds to the variance
    %        if n gaussian white noise => var(n) = sum(n.^2)/length(n)
   
    signalSize = length(signal);
    soundLevel = 10*log10(sum(signal.^2)/signalSize); % Sound level (in average)
    noiseLevel = soundLevel - snr;                    % Noise level
    noiseSigma = 10^(noiseLevel/20);                  % Standard deviation of the noise
    noise      = noiseSigma * randn(signalSize, 1);   % Noise generation for specified SNR
    signal     = signal + noise;                      % Add noise
    
end



% ---------------------------------------- FUNCTION ---------------------------------------------- %
% 
% Function : 
% 
% ------------------------------------------------------------------------------------------------ %

function [target, nbFeaturePerClass, nbFeature] = determineTargetPerFeature(nbFeaturePerFile, nbClass, nbFilePerClass)
    
    nbFeature = sum(nbFeaturePerFile);
    
    target            = zeros(1, nbFeature); % Preallocation
    nbFeaturePerClass = zeros(nbClass, 1);   % Preallocation
    lastId            = 0; % Initialization
    targetLastId      = 0; % Initialization
    for i = 1 : nbClass,
        % Number of frame by class
        firstId              = lastId + 1;
        lastId               = firstId + nbFilePerClass(i) - 1;
        nbFeaturePerClass(i) = sum(nbFeaturePerFile(firstId:lastId));
        
        % Target class for each frame
        targetFirstId                      = targetLastId + 1;
        targetLastId                       = targetFirstId + nbFeaturePerClass(i) - 1;
        target(targetFirstId:targetLastId) = i * ones(1, nbFeaturePerClass(i));
    end
    
end


% ------------------------------------- End of file ---------------------------------------------- %
