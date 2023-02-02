function [mappedFeature, mapping] = build_mapping(feature, label, nFeature, pcaDim, ldaDim)

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.09.05  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ % 

    % --- feature normalization
    [featureN, normParam] = feature_normalization(feature);

    
    % --- PCA
    if pcaDim > 0,
        covF = featureN*featureN'/(nFeature-1); % Compute covariance matrix of the feature matrix
        [eigenVector, eigenValue] = eig(covF);  % Eigen analysis of feature covariance matrix
        eigenValue = diag(eigenValue);
        norm = diag(1./sqrt(eigenValue(end : -1 : end-pcaDim+1))); % Normalize basis matrix
    %     norm = 1; % No normalization
        pcaMapping = norm*eigenVector(:, end : -1 : end-pcaDim+1)'; % Compute basis matrix
        mappedFeature = pcaMapping * featureN; % Feature projection on new basis
        mapping = pcaMapping;
    end
    
    
    % --- LDA
    if ldaDim > 0,
        ;
    end
    
    
    % --- no mapping
    if pcaDim == 0 && ldaDim == 0,
        mappedFeature = feature;
        mapping = eye(size(feature, 1));
    end
    
    % --- Compact mapping data
    mapping = [normParam'; mapping];


end


function [featureN, normParam] = feature_normalization(feature)
% This normalization is done by shifting the mean of each dimension of the feature 
% matrix to 0 and to compress or dilate the standard deviation of each dimension of 
% the feature matrix to 1. This normalization is done over all training signals all 
% classes. 
%               normFeature = (feature - meanForEachDim) ./ stdForEachDim;
%
% Note : std(f) = sqrt(1/N*sum((fi-m)^2), i=[1,N]); with m = mean(f);
%        So, if mean(f)=0 => std(f) = sqrt(mean(f.^2))
%        This implementation is twice fast than the original std.
    
% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.09.06  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ % 
    
    %%% Substract mean
    meanNorm = mean(feature, 2);
    feature0M = bsxfun(@minus, feature, meanNorm);
    
    %%% Divide by std
    stdNorm = sqrt(mean(feature0M.^2, 2));
    featureN = bsxfun(@rdivide, feature0M, stdNorm);
    
    %%% Compact param
    normParam = [meanNorm, stdNorm];
    
end %function