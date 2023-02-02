% ----------------------------------- FUNCTION -------------------------------------------
% 
% Ipsum lorem
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
% 
% Outputs : 
%   -
% 
%   -
% 
% ----------------------------------------------------------------------------------------

% -------------------------------------------------------------------------------------- %
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% -------------------------------------------------------------------------------------- %



function [modelParameter, reductionMatrix] = ...
             trainingBayes(trainingFilePath, trainingSNR, featureType, reductionParameter)

    
    % ------------------------------------------------------------------------------------
    % Features extraction
    % ------------------------------------------------------------------------------------
    
    %%% Extraction of raw features
    [feature, target, nbTokenPerClass] = ...
                            featureExtraction(trainingFilePath, trainingSNR, featureType);
    
    %%% Feature normalization
    featureNormalized = featureNormalization(feature);
    
    %%% Token's size reduction
    [featureReduced, reductionMatrix] = ...
                                    reduceTokenDim(featureNormalized, reductionParameter);
    
    
    % ------------------------------------------------------------------------------------
    % Features PDF modeling : compute model parameters
    % ------------------------------------------------------------------------------------
    
    modelParameter = featurePDFModeling(featureReduced, target, nbTokenPerClass);
    
    
end




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
%                                  NESTED FUNCTION                                       %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %



% ----------------------------------- FUNCTION ----------------------------------------- %
% 
% Function : 
% 
% -------------------------------------------------------------------------------------- %

function [feature, reductionMatrix] = reduceTokenDim(feature, reductionParameter)


    % ------------------------------------------------------------------------------------
    % Reduce tokens' dimension by a Principal Component Analysis (PCA)
    % ------------------------------------------------------------------------------------
    
    if reductionParameter(1) ~= 0,
        
        % Compute the transformation matrix
        reducedPCAMatrix = computeReducedPCAMatrix(feature, reductionParameter(1));
        % Apply the transformation matrix on features
        feature = reducedPCAMatrix * feature;
        
    else
        
        reducedPCAMatrix = [];
        
    end
    
    
    % ------------------------------------------------------------------------------------
    % Reduce tokens' dimension by a Linear Discriminant Analysis (LDA)
    % ------------------------------------------------------------------------------------
    
    if reductionParameter(2) ~= 0,
        
        % Compute the transformation matrix
        reducedLDAMatrix = computeReducedLDAMatrix(featureReduced, reductionParameter(2));
        % Apply the transformation matrix on features
        feature = reducedLDAMatrix * feature;
        
    else
        
        reducedLDAMatrix = [];
        
    end
    

    % ------------------------------------------------------------------------------------
    % Transformation matrix are put in a cell to facilitated data manipulation
    % ------------------------------------------------------------------------------------
    
    reductionMatrix{1} = reducedPCAMatrix;
    reductionMatrix{2} = reducedLDAMatrix;

end



% ----------------------------------- FUNCTION ----------------------------------------- %
% 
% Function : 
% 
% -------------------------------------------------------------------------------------- %

function reducedPCAMatrix = computeReducedPCAMatrix(feature, nbDimToKeep)

    nbToken = size(feature, 2);
    
    
    % ------------------------------------------------------------------------------------
    % Compute covariance matrix of the feature matrix
    % ------------------------------------------------------------------------------------
    
    covF = feature*feature'/(nbToken-1); 
    
    
    % ------------------------------------------------------------------------------------
    % Eigen analysis of feature covariance matrix
    % ------------------------------------------------------------------------------------
    
    [eigenVector, eigenValue] = eig(covF);  
    
    
    % ------------------------------------------------------------------------------------
    % Normalize basis matrix
    % ------------------------------------------------------------------------------------
    
    eigenValue = diag(eigenValue);
    norm = diag(1./sqrt(eigenValue(end:-1:end-nbDimToKeep+1))); 
%     norm = 1; % No normalization
    

    % ------------------------------------------------------------------------------------
    % Compute reduced PCA transformation matrix
    % ------------------------------------------------------------------------------------
    
    reducedPCAMatrix = norm*eigenVector(:, end:-1:end-nbDimToKeep+1)';

end



% ----------------------------------- FUNCTION ----------------------------------------- %
% 
% Function : 
% 
% -------------------------------------------------------------------------------------- %

function reducedLDAMatrix = computeReducedLDAMatrix(feature, nbDimToKeep)

    reducedLDAMatrix = 0;

end



% ----------------------------------- FUNCTION ----------------------------------------- %
% 
% Estimate features' means and covariances from supervised labelling.
% 
% -------------------------------------------------------------------------------------- %

function modelParameter = featurePDFModeling(feature, target, nbTokenPerClass)
    

    nbClass             = max(target);
    tokenDim            = size(feature, 1);
    meanMatrixPerClass  = zeros(tokenDim, nbClass); % Preallocation
    covMatrixPerClass   = cell(nbClass, 1);         % Preallocation
    

    for i = 1 : nbClass,
       
        % --------------------------------------------------------------------------------
        % Extract features linked to the actual class
        % --------------------------------------------------------------------------------
        
        classFeature = feature(:,target==i);
        
        
        % --------------------------------------------------------------------------------
        % Compute mean for each dimension of the feature
        % --------------------------------------------------------------------------------
        
        meanMatrixPerClass(:,i) = mean(classFeature, 2);
        
        
        % --------------------------------------------------------------------------------
        % Compute covariance matrix for each feature dimension (reshape is just to easily 
        % store covMatrix)
        % --------------------------------------------------------------------------------
        
        % Mean shifted to 0
        normClassFeature = bsxfun(@minus, classFeature, meanMatrixPerClass(:,i));
        % Compute covariance matrix
        covMatrixPerClass{i} = normClassFeature * normClassFeature' / (nbTokenPerClass(i)-1);
        
    end
    
    
    % ------------------------------------------------------------------------------------
    % Mean and covariance matrix are put in a cell to facilitated data manipulation
    % ------------------------------------------------------------------------------------
    
    modelParameter{1} = meanMatrixPerClass;
    modelParameter{2} = covMatrixPerClass;
    
end

% --------------------------------- End of file ------------------------------------------
