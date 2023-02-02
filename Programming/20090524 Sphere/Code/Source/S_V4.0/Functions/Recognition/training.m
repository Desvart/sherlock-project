function modelParam = training(trainingFeature, reductionParam, model)

    % ----------------------------------------------------------------------------------------------
    % Features reduction
    % ----------------------------------------------------------------------------------------------

    [feature, modelParam] = reduceFeatureDim(trainingFeature, reductionParam, model);

    
    % ----------------------------------------------------------------------------------------------
    % Features normalization
    % ----------------------------------------------------------------------------------------------

    [feature.data, modelParam] = featureNormalization(feature.data, modelParam);
    
    
    global plotFlag;
    if plotFlag,
        figure; hold on;
        plot(feature.data(1,:), feature.data(2,:), '.k');
    end
    
    
    % ----------------------------------------------------------------------------------------------
    % Features PDF modeling : compute model parameters
    % ----------------------------------------------------------------------------------------------
    
    switch model.type,
        
        %%% Bayes
        case 'Bayes',
            modelParam = featurePDFModeling_Bayes(feature, modelParam);
            
        %%% GMM
        case 'GMM',
            try
                modelParam = featurePDFModeling_GMM(feature, modelParam);
            catch exception
                modelParam = exception.identifier; % stats:mvnpdf:BadCovariance
            end
            
        %%% HMM + Bayes
        case 'HMMBayes',
            
            
        %%% HMM + GMM
        case 'HMMGMM',
            

        otherwise,
            error('Unknown model type.');
            
    end
    

    if plotFlag,
        plotgauss(modelParam.mu{1}, modelParam.sigma{1})
        plotgauss(modelParam.mu{2}, modelParam.sigma{2})
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

function [featureReduced, modelParam] = reduceFeatureDim(feature, reductionParam, model)

    featureReduced = feature;
    data = feature.data;
    % ----------------------------------------------------------------------------------------------
    % Reduce tokens' dimension by a Principal Component Analysis (PCA)
    % ----------------------------------------------------------------------------------------------
    
    PCAdim = reductionParam.PCAdim;
    if reductionParam.PCAdim ~= 0,
        
        % Compute the transformation matrix
        reducedPCAMatrix = computeReducedPCAMatrix(data, PCAdim);
        % Apply the transformation matrix on features
        featureReduced.data = reducedPCAMatrix * data;
        featureReduced.nbDim = PCAdim;
        
    else
        
        reducedPCAMatrix = [];
        
    end
    

    % ----------------------------------------------------------------------------------------------
    % Reduce tokens' dimension by a Linear Discriminant Analysis (LDA)
    % ----------------------------------------------------------------------------------------------
    
    data = featureReduced.data;
    LDAdim = reductionParam.LDAdim;
    if reductionParam.LDAdim ~= 0,
        
        % Compute the transformation matrix
        reducedLDAMatrix = computeReducedLDAMatrix(data, LDAdim);
        % Apply the transformation matrix on features
        featureReduced.data = reducedLDAMatrix * data;
        featureReduced.nbDim = LDAdim;
        
    else
        
        reducedLDAMatrix = [];
        
    end
    
    
    % ----------------------------------------------------------------------------------------------
    % Transformation matrix are put in a cell to facilitated data manipulation
    % ----------------------------------------------------------------------------------------------
    
    modelParam.PCAMatrix = reducedPCAMatrix;
    modelParam.LDAMatrix = reducedLDAMatrix;
    modelParam.model     = model;

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
    
%     eigenValue = diag(eigenValue);
%     norm = diag(1./sqrt(eigenValue(end:-1:end-nbDimToKeep+1))); 
    norm = 1; % No normalization
    

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


% ----------------------------------- FUNCTION ----------------------------------------- %
% 
% Function : 
% 
% -------------------------------------------------------------------------------------- %

function [feature, modelParam] = featureNormalization(feature, modelParam)
    % This normalization is done by shifting the mean of each dimension of the feature 
    % matrix to 0 and to compress or dilate the standard deviation of each dimension of 
    % the feature matrix to 1. This normalization is done over all training signals all 
    % classes. 
    %               normFeature = (feature - meanForEachDim) ./ stdForEachDim;
    %
    % Note : std(f) = sqrt(1/N*sum((fi-m)^2), i=[1,N]); with m = mean(f);
    %        So, if mean(f)=0 => std(f) = sqrt(mean(f.^2))
    %        This implementation is twice fast than the original std.
    
    %%% Substract mean
    meanNorm = mean(feature, 2);
    featureM = bsxfun(@minus, feature, meanNorm);
    
    %%% Divide by std
    stdNorm = sqrt(mean(featureM.^2, 2));
    feature = bsxfun(@rdivide, featureM, stdNorm);
    
    
    modelParam.meanNorm = meanNorm;
    modelParam.stdNorm = stdNorm;
    
end %function





function plotgauss(mu, sigma)
A = inv(sigma);	% the inverse covariance matrix
% plot between +-2SDs along each dimension 
maxsd = max(diag(sigma)); 
x = mu(1)-2*maxsd:0.1:mu(1)+2*maxsd; % location of points at which x is calculated 
y = mu(2)-2*maxsd:0.1:mu(2)+2*maxsd; % location of points at which y is calculated
[X, Y] = meshgrid(x,y); % matrices used for plotting
% Compute value of Gaussian pdf at each point in the grid 
z = 1/(2*pi*sqrt(det(sigma))) * exp(-0.5 * (A(1,1)*(X-mu(1)).^2 + 2*A(1,2)*(X-mu(1)).*(Y-mu(2)) + A(2,2)*(Y-mu(2)).^2));
contour(x,y,z);

end









% --------------------------------- End of file ------------------------------------------
