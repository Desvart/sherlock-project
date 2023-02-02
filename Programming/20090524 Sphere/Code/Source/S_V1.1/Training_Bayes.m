% ----------------------------------------------------------------------------------------
% Function : Training_Bayes.m
% 
% Purpose  : This function does the training part of a sound recognition process. The
%            probability density functions (PDF) of the features extracted are modelized 
%            by single gaussians (Bayes modelization).
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
% Date      : 10.06.2010
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------


function [meanMatrix, covMatrix, PCABasis, LDABasis] = Training_Bayes(trainingFile, ...
                                               trainingSNR, featureType, PCA_dim, LDA_dim)


    % ------------------------------------------------------------------------------------
    % Function initialization
    % ------------------------------------------------------------------------------------
    
    % First line of 'trainingFile' contains the number of file per class used for training
    nbTrainingFile    = trainingFile{1};
    nbClass           = length(nbTrainingFile);
    nbFrameByClass    = zeros(1, nbClass); % Preallocation
    
    
    % ------------------------------------------------------------------------------------
    % Features extraction
    % ------------------------------------------------------------------------------------
    
    [feature, nbFrameByFile] = featureExtraction(trainingFile, trainingSNR, featureType);
    
    
    % ------------------------------------------------------------------------------------
    % Determine target class for each frame
    % ------------------------------------------------------------------------------------
    
    totNbFrame = sum(nbFrameByFile);
    target     = zeros(1, totNbFrame); % Preallocation
    
    for i = 1 : nbClass,
        % Number of frame by class
        firstId           = sum(nbTrainingFile(1:i-1)) + 1;
        lastId            = sum(nbTrainingFile(1:i));
        nbFrameByClass(i) = sum(nbFrameByFile(firstId:lastId));
        
        % Target class for each frame
        firstId                = sum(nbFrameByClass(1:i-1)) + 1;
        lastId                 = sum(nbFrameByClass(1:i));
        target(firstId:lastId) = i*ones(1, nbFrameByClass(i));
    end
    
    
    % ------------------------------------------------------------------------------------
    % Features normalization (mean = 0; std = 1)
    % ------------------------------------------------------------------------------------
    
    feature = featureNormalization(feature);
   
    
    % ------------------------------------------------------------------------------------
    % Reduction of features dimension (PCA + LDA)
    % ------------------------------------------------------------------------------------
    
    [feature, featureDim, PCABasis, LDABasis] = ...
                                              featureReduction(feature, PCA_dim, LDA_dim);

    
    % ------------------------------------------------------------------------------------
    % Features modelization
    % ------------------------------------------------------------------------------------
    % Estimate Mean and Covariance from Supervised labelling, 
    
    meanMatrix = zeros(nbClass, featureDim);   % Preallocation
    covMatrix  = zeros(nbClass, featureDim^2); % Preallocation
    
    for i = 1 : nbClass,
        %%% Extract features linked to the actual class
        featurePerClass = feature(:, target==i);
        
        %%% Compute mean for each dimension of the feature
        meanMatrix(i,:) = mean(featurePerClass, 2)';
        
        %%% Compute covariance matrix for each feature dimension (reshape is just to easily 
        % store covMatrix)
        featurePerClass = bsxfun(@minus, featurePerClass, meanMatrix(i,:)'); % Mean shifted to 0
        covF = featurePerClass*featurePerClass'/(nbFrameByClass(i)-1);
        covMatrix(i,:) = reshape(covF, 1, featureDim^2 );
    end
    
    
end %function


% --------------------------------- End of file ------------------------------------------
