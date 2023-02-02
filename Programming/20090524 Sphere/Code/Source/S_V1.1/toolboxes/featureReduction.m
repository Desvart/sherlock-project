% ----------------------------------------------------------------------------------------
% Function : featureReduction.m
% 
% Purpose  : This function normalizes extracted feature
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


function [feature, featureDim, PCABasis, LDABasis] = ...
                                               featureReduction(feature, PCA_dim, LDA_dim)

    %%% PCA compression
    % "For Hermitian matrices MATLAB returns eigenvalues sorted in increasing order and 
    % the matrix of eigenvectors is unitary to working precision" ("MATLAB Guide" from 
    % D.J.Higham, p.132). This is due to the specific Cholesky decomposition implemented 
    % in Matlab for hermitian matrices.
    % Covariance matrix of a real matrix is a symetric real matrix and so on it is an 
    % hermitian matrix.
    %
    % The new basis matrix can be scaled by the inverse square root of the eigenvalues, 
    % yielding to reduced features which have a spherical distribution with unit variance.
    
    totNbFrame = size(feature, 2);
    featureDim = size(feature, 1);
        
    if isscalar(PCA_dim),
        
        if PCA_dim ~= 0,
            covF = feature*feature'/(totNbFrame-1); % Compute covariance matrix of the feature matrix
            [eigenVector, eigenValue] = eig(covF);  % Eigen analysis of feature covariance matrix
            eigenValue = diag(eigenValue);
            norm = diag(1./sqrt(eigenValue(end:-1:end-PCA_dim+1))); % Normalize basis matrix
%             norm = 1; % No normalization
            PCABasis = norm*eigenVector(:, end:-1:end-PCA_dim+1)'; % Compute basis matrix
            feature = PCABasis*feature; % Feature projection on new basis
            featureDim = PCA_dim;
        else
            PCABasis = 0;
        end
        
    else
        
        PCABasis = PCA_dim;
        featureDim  = size(PCABasis, 1);
        feature  = PCABasis*feature; % Feature projection on new basis
        
    end

    
    %%% LDA compression
    if isscalar(PCA_dim),
        if LDA_dim ~= 0,
            LDABasis = eye(featureDim);
            featureDim = LDA_dim;
        else
            LDABasis = 0;
        end
    else
        LDABasis = LDA_dim;
        feature  = LDABasis*feature; % Feature projection on new basis
    end
    
end %function


% --------------------------------- End of file ------------------------------------------
