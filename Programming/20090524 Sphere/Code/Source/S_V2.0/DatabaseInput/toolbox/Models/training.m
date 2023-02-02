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
% --------------------------------------------------------------------------------------------------

% ------------------------------------------------------------------------------------------------ %
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %



function [modelParameter, reductionMatrix, errorFlag] = training(trainingFilePath, trainingSNR, featureType, reductionParameter, model)
    
    errorFlag = 0;
    
    % ----------------------------------------------------------------------------------------------
    % Features extraction
    % ----------------------------------------------------------------------------------------------

    %%% Extraction of raw features
    [feature, target, nbTokenPerClass] = featureExtraction(trainingFilePath, trainingSNR, featureType);

    %%% Feature normalization
    featureNormalized = featureNormalization(feature);

    %%% Token's size reduction
    [featureReduced, reductionMatrix] = reduceTokenDim(featureNormalized, reductionParameter);

   
    % ----------------------------------------------------------------------------------------------
    % Features PDF modeling : compute model parameters
    % ----------------------------------------------------------------------------------------------
    
    switch model(1),
        
        %%% Bayes
        case 0, 
            modelParameter = featurePDFModeling_Bayes(featureReduced, target, nbTokenPerClass);

        %%% GMM
        case 1,
            try
                modelParameter = featurePDFModeling_GMM(featureReduced, target, model(2));
            catch exception
                if strcmp(exception.identifier, 'stats:mvnpdf:BadCovariance'),
                    modelParameter = 0;
                    errorFlag = 1;
                else
                    error(exception.message);
                end
            end
            
        %%% HMM
        case 2,
            

        otherwise,
            error('Unknown model type.');
    end
    
    
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


    % ----------------------------------------------------------------------------------------------
    % Reduce tokens' dimension by a Principal Component Analysis (PCA)
    % ----------------------------------------------------------------------------------------------
    
    if reductionParameter(1) ~= 0,
        
        % Compute the transformation matrix
        reducedPCAMatrix = computeReducedPCAMatrix(feature, reductionParameter(1));
        % Apply the transformation matrix on features
        feature = reducedPCAMatrix * feature;
        
    else
        
        reducedPCAMatrix = [];
        
    end
    
    
    % ----------------------------------------------------------------------------------------------
    % Reduce tokens' dimension by a Linear Discriminant Analysis (LDA)
    % ----------------------------------------------------------------------------------------------
    
    if reductionParameter(2) ~= 0,
        
        % Compute the transformation matrix
        reducedLDAMatrix = computeReducedLDAMatrix(featureReduced, reductionParameter(2));
        % Apply the transformation matrix on features
        feature = reducedLDAMatrix * feature;
        
    else
        
        reducedLDAMatrix = [];
        
    end
    

    % ----------------------------------------------------------------------------------------------
    % Transformation matrix are put in a cell to facilitated data manipulation
    % ----------------------------------------------------------------------------------------------
    
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
    
    
    % ----------------------------------------------------------------------------------------------
    % Compute covariance matrix of the feature matrix
    % ----------------------------------------------------------------------------------------------
    
    covF = feature*feature'/(nbToken-1); 
    
    
    % ----------------------------------------------------------------------------------------------
    % Eigen analysis of feature covariance matrix
    % ----------------------------------------------------------------------------------------------
    
    [eigenVector, eigenValue] = eig(covF);  
    
    
    % ----------------------------------------------------------------------------------------------
    % Normalize basis matrix
    % ----------------------------------------------------------------------------------------------
    
    eigenValue = diag(eigenValue);
    norm = diag(1./sqrt(eigenValue(end:-1:end-nbDimToKeep+1))); 
%     norm = 1; % No normalization
    

    % ----------------------------------------------------------------------------------------------
    % Compute reduced PCA transformation matrix
    % ----------------------------------------------------------------------------------------------
    
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


% --------------------------------- End of file ------------------------------------------








