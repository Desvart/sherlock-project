% ----------------------------------------------------------------------------------------
% Function : featureExtraction.m
% 
% Purpose  : This function extracts the desire feature from a list of sound files.
%
%
% Inputs :  
%       signal
%       
%
% Outputs : 
%       
%
%
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------


function [feature, nbFrameByFile] = ...
                                 featureExtraction(trainingFile, trainingSNR, featureType)
    
    totNbTrainingFile = length(trainingFile) - 1; % -1 to avoid first line
    
    feature           = [];
    nbFrameByFile     = zeros(1, totNbTrainingFile); % Preallocation
    
    for i = 1 : totNbTrainingFile,
        %%% Extract signal
        [signal, fs] = wavread(trainingFile{i+1}, 'native');
        signal = double(signal);
        
        %%% Add noise to signal
%         signal = addNoise(signal', trainingSNR);
        
        %%% Extract features
        switch featureType,
            case 'spectrogram',
                [fileFeature, featureDim, nbFrameByFile(i)] = ...
                                                featureExtraction_Spectrogram(signal, fs);
                
            case 'MFCC',
                
        end
        
        %%% Concatenate all features
        feature = [feature, fileFeature]; %#ok<AGROW>
    end
    
end %function


% --------------------------------- End of file ------------------------------------------
