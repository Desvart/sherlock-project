% ---------------------------------------- FUNCTION ------------------------------------------------
% 
% This function extracts the desire features from a list of sound files.
%
%
% Inputs :  
% 	-
% 
%   -
% 
%   -
%   
%
% Outputs : 
%   -
% 
%   -
% 
%   -
% 
%   -
%       
% --------------------------------------------------------------------------------------------------

% ------------------------------------------------------------------------------------------------ %
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function [feature, target, nbTokenPerClass, nbTokenPerFile] = ...
                                                       featureExtraction(filePath, SNR, featureType)
    
    nbFile = length(filePath) - 1; % -1 to avoid header
    nbTokenPerFile = zeros(nbFile, 1); % Preallocation
    feature        = [];
    
    % ----------------------------------------------------------------------------------------------
    % For each training file
    % ----------------------------------------------------------------------------------------------

    for i = 1 : nbFile,
        
        % ------------------------------------------------------------------------------------------
        % Extract signal
        % ------------------------------------------------------------------------------------------
        
        [signal, fs] = extractSignal(filePath{i+1});
        
        
        % ------------------------------------------------------------------------------------------
        % Add noise to signal
        % ------------------------------------------------------------------------------------------
        
        signal = addNoise(signal, SNR);
        
        
        % ------------------------------------------------------------------------------------------
        % Extract feature tokens
        % ------------------------------------------------------------------------------------------
        
        switch featureType,
            case 0, % spectrogram
                [fileToken, nbTokenPerFile(i)] = featureExtraction_Spectrogram(signal, fs);
                
            case 1, % MFCC
                
        end
        
        %%% Concatenate all tokens
        feature = [feature, fileToken]; %#ok<AGROW>
    end
    
    
    % ----------------------------------------------------------------------------------------------
    % Determine target class for each frame
    % ----------------------------------------------------------------------------------------------
    
    nbFilePerClass = filePath{1};
    nbClass = length(nbFilePerClass);
    
    [target, nbTokenPerClass] = determineTargetPerToken(nbTokenPerFile, nbClass, nbFilePerClass);
    
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

function [target, nbTokenPerClass] = determineTargetPerToken(nbTokenPerFile, nbClass, nbFilePerClass)
    
    nbToken = sum(nbTokenPerFile);
    target  = zeros(1, nbToken); % Preallocation
    
    nbTokenPerClass = zeros(nbClass, 1);
    lastId          = 0;
    targetLastId    = 0;
    for i = 1 : nbClass,
        % Number of frame by class
        firstId            = lastId + 1;
        lastId             = firstId + nbFilePerClass(i) - 1;
        nbTokenPerClass(i) = sum(nbTokenPerFile(firstId:lastId));
        
        % Target class for each frame
        targetFirstId                      = targetLastId + 1;
        targetLastId                       = targetFirstId + nbTokenPerClass(i) - 1;
        target(targetFirstId:targetLastId) = i * ones(1, nbTokenPerClass(i));
    end
    
end


% ------------------------------------- End of file ---------------------------------------------- %
