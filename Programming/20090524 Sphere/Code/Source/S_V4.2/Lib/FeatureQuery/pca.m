

function [feature,mapping] = pca(feature, nbDim)

    %%% Compute covariance matrix of the feature matrix
    covF = trFeature*trFeature'/(nbFeature-1);
    
    %%% Eigen analysis of feature covariance matrix
    [eigenVector, eigenValue] = eig(covF);
    
    %%% Normalize basis matrix
    eigenValue = diag(eigenValue);
    norm = diag(1./sqrt(eigenValue(end:-1:end-reductionParam(1)+1))); 
%     norm = 1; % No normalization
    
    %%% Compute reduced PCA transformation matrix
    PCAMatrix = norm*eigenVector(:,end:-1:end-reductionParam(1)+1)';
    
    %%% Apply PCA transformation on features
    redTrFeature = trFeature * PCAMatrix;
    redTeFeature = teFeature * PCAMatrix;

end


% EoF -------------------------------------------------------------------------------------------- %
