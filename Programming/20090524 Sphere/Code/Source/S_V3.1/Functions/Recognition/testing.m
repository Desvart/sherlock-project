% ------------------------------------------------------------------------------------------------ %
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function [membership, certainties] = testing(testingFeature, modelParam)
            

    % ----------------------------------------------------------------------------------------------
    % Features dimension reduction
    % ----------------------------------------------------------------------------------------------
    
    testingFeature.data = reduceTokenDim(testingFeature.data, modelParam);
  
    
    % ----------------------------------------------------------------------------------------------
    % Features normalization (mean = 0; std = 1)
    % ----------------------------------------------------------------------------------------------
    
    testingFeature.data = featureNormalization(testingFeature.data, modelParam);
    
    global plotFlag;
    if plotFlag,
        plot(testingFeature.data(1,:), testingFeature.data(2,:), '+r');
    end
    
    % ----------------------------------------------------------------------------------------------
    % Bayes Classification
    % ----------------------------------------------------------------------------------------------
    
	switch modelParam.model.type,
        
        %%% Bayes
        case 'Bayes',
             membershipPerFrame = classification_Bayes(testingFeature, modelParam);
        
        %%% GMM
        case 'GMM', 
             membershipPerFrame = classification_GMM(testingFeature, modelParam);
             
        otherwise,
            error('Unknown model type.');
	end
   

    % ----------------------------------------------------------------------------------------------
    % Determine class membership for each sound
    % ----------------------------------------------------------------------------------------------
    
    [membership,certainties] = fileClassification(membershipPerFrame, testingFeature.nbFile, testingFeature.nbFeaturePerFile, testingFeature.nbClass);

    
               
end %function




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
%                                  NESTED FUNCTION                                       %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %



% ----------------------------------- FUNCTION ----------------------------------------- %
% 
% Function : 
% 
% -------------------------------------------------------------------------------------- %

function feature = reduceTokenDim(feature, modelParam)

    % ------------------------------------------------------------------------------------
    % Reduce tokens' dimension by a Principal Component Analysis (PCA)
    % ------------------------------------------------------------------------------------
    
    PCAMat = modelParam.PCAMatrix;
    if ~isempty(PCAMat),
        
        % Apply the transformation matrix on features
        feature = PCAMat * feature;
        
    end
    
    
    % ------------------------------------------------------------------------------------
    % Reduce tokens' dimension by a Linear Discriminant Analysis (LDA)
    % ------------------------------------------------------------------------------------
    
    LDAMat = modelParam.LDAMatrix;
    if ~isempty(modelParam.LDAMatrix),

        % Apply the transformation matrix on features
        feature = LDAMat * feature;

    end
    
end


% ----------------------------------- FUNCTION ----------------------------------------- %
% 
% Function : 
% 
% -------------------------------------------------------------------------------------- %

function feature = featureNormalization(feature, modelParam)

    %%% Substract mean
    featureM = bsxfun(@minus, feature, modelParam.meanNorm);
    
    %%% Divide by std
    feature = bsxfun(@rdivide, featureM, modelParam.stdNorm);
    
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
