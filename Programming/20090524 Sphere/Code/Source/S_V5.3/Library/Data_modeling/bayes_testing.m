function [membership, certainty] = bayes_testing(feature, model, nClass, nFeature, featureDim)

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.09.06  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %   

    %%% Compute Bayes distance
    pseudoBayesDist = zeros(nClass, nFeature); % Preallocation
    for iClass = 1 : nClass,
        
        dbstop in bayes_testing at 13
        % Extract PDF parameters (mean and cov) for actual class
        model = reshape(model(1, iClass, 1, :, :), featureDim, featureDim+1);
        meanVector = model(:, 1);
        covMatrix  = model(:, 2:end);
        
%         centeredFeature = feature - meanVector*ones(1, totNbFrame);
        featureM = bsxfun(@minus, feature, meanVector);
        
        pseudoBayesDist(iClass, :) = log(det(covMatrix)) + diag(featureM'*(covMatrix\featureM))';
    end
    
    [dummy, frame_membership] = min([pseudoBayesDist; Inf*ones(1, totNbFrame)]);

end