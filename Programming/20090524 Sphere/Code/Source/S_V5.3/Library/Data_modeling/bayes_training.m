function model = bayes_training(feature, label, nClass, featureDim, nFeaturePerClass, previousModel)

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.09.06  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %   

    % Estimate Mean and Covariance from Supervised labelling, 
    model = zeros(nClass, 1, featureDim, featureDim+1); % Preallocation    

    for iClass = 1 : nClass,
        
        %%% Extract features linked to the actual class
        featureForThisClass = feature(:, label==iClass);
        
        
        %%% Compute mean for each dimension of the feature
        meanMatrix = mean(featureForThisClass, 2);
        
        
        %%% Compute covariance matrix for each feature dimension (reshape is just to easily 
        % store covMatrix)
        featureForThisClassN = bsxfun(@minus, featureForThisClass, meanMatrix); % Mean shifted to 0
        covMatrix = featureForThisClassN * featureForThisClassN' / (nFeaturePerClass(iClass)-1);
        
%         dbstop in gmm_training at 43
        %%% Compact model
        model(iClass, 1, :, :) = [meanMatrix, covMatrix];
        
    end
end
