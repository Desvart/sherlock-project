% ---------------------------------------- FUNCTION ------------------------------------------------
% 
% This function does the testing part of a sound recognition process. The probability density
% functions (PDF) of the features inputed are modelized by single gaussians (Bayes modeling).
% 
% 
% Inputs :  
%   -
% 
%   -
% 
%   -
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
% --------------------------------------------------------------------------------------------------


% ------------------------------------------------------------------------------------------------ %
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function [membership, certainties] = testing(testingFilePath, testingSNR, featureType, reductionMatrix, modelParameter, model)
            
    if ~isstruct(testingFilePath),
    % ----------------------------------------------------------------------------------------------
    % Function initialization
    % ----------------------------------------------------------------------------------------------
    
    % First line of 'testingFile' contains the number of file per class used for training
    nbTestingFilePerClass = testingFilePath{1};
    nbClass               = length(nbTestingFilePerClass);
    nbTestingFile         = sum(nbTestingFilePerClass);
    
    
    % ----------------------------------------------------------------------------------------------
    % Features extraction
    % ----------------------------------------------------------------------------------------------
    
    [feature, ~, ~, nbTokenPerFile] = featureExtraction(testingFilePath, testingSNR, featureType);
    else
        feature = testingFilePath.data;
    end
    
    % ----------------------------------------------------------------------------------------------
    % Features normalization (mean = 0; std = 1)
    % ----------------------------------------------------------------------------------------------
    
    feature = featureNormalization(feature);
   
    
    % ----------------------------------------------------------------------------------------------
    % Features dimension reduction
    % ----------------------------------------------------------------------------------------------
    
    feature = reduceTokenDim(feature, reductionMatrix);
    
    
    % ----------------------------------------------------------------------------------------------
    % Bayes Classification
    % ----------------------------------------------------------------------------------------------
    
	switch model(1),
        
        %%% Bayes
        case 0,
             membershipPerFrame = classification_Bayes(feature, modelParameter);
        
        %%% GMM
        case 1, 
             membershipPerFrame = classification_GMM(feature, modelParameter);
             
        otherwise,
            error('Unknown model type.');
	end
   

    % ----------------------------------------------------------------------------------------------
    % Determine class membership for each sound
    % ----------------------------------------------------------------------------------------------
    
    if ~isstruct(testingFilePath),
        [membership, certainties] = fileClassification(membershipPerFrame, nbTestingFile, nbTokenPerFile, nbClass);
    else
        membership = membershipPerFrame;
        certainties = 0;
    end

    
               
end %function




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
%                                  NESTED FUNCTION                                       %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %



% ----------------------------------- FUNCTION ----------------------------------------- %
% 
% Function : 
% 
% -------------------------------------------------------------------------------------- %

function feature = reduceTokenDim(feature, reductionMatrix)

    % ------------------------------------------------------------------------------------
    % Reduce tokens' dimension by a Principal Component Analysis (PCA)
    % ------------------------------------------------------------------------------------
    
    if ~isempty(reductionMatrix{1}),
        
        % Apply the transformation matrix on features
        feature = reductionMatrix{1} * feature;
        
    end
    
    
    % ------------------------------------------------------------------------------------
    % Reduce tokens' dimension by a Linear Discriminant Analysis (LDA)
    % ------------------------------------------------------------------------------------
    
    if ~isempty(reductionMatrix{2}),

        % Apply the transformation matrix on features
        feature = reductionMatrix{2} * feature;

    end
    
end



% ----------------------------------- FUNCTION ----------------------------------------- %
% 
% Function : 
% 
% -------------------------------------------------------------------------------------- %

function [membership, certainties] = fileClassification(membershipPerFrame, nbTestingFile, nbTokenPerFile, nbClass)
    
    membership  = zeros(1, nbTestingFile);       % Preallocation
    certainties = zeros(nbTestingFile, nbClass); % Preallocation
    
    % Loop for each sound
    for i = 1 : nbTestingFile, 

        start = sum(nbTokenPerFile(1:i-1))+1; % Index of first frame of current sound
        stop  = sum(nbTokenPerFile(1:i));     % Index of last frame of current sound

        % Determine number of frames belonging to each class
        nbFrameBelongingToEachClass = zeros(1, nbClass); % Preallocation
        for j = 1 : nbClass,
            nbFrameBelongingToEachClass(j) = sum(membershipPerFrame(start:stop)==j);
        end

        % See which class is the winner
        [~,membership(i)] = max(nbFrameBelongingToEachClass);

        % Calculate certainties
        certainties(i,:) = nbFrameBelongingToEachClass / sum(nbFrameBelongingToEachClass);
    end
    
end



% --------------------------------- End of file -------------------------------------------------- %
