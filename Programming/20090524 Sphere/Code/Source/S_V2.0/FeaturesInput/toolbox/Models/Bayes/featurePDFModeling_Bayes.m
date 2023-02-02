% ----------------------------------- FUNCTION -------------------------------------------
% 
% Estimate features' means and covariances from supervised labelling.
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


function modelParameter = featurePDFModeling_Bayes(feature, target, nbTokenPerClass)
    
    nbClass         = max(target);
    tokenDim        = size(feature, 1);
    muPerClass      = zeros(tokenDim, nbClass); % Preallocation
    sigmaPerClass   = cell(nbClass, 1);         % Preallocation
    

    for i = 1 : nbClass,
       
        %%% Extract features linked to the actual class
        classFeature = feature(:,target==i);
        
        %%% Compute mean for each dimension of the feature
        muPerClass(:,i) = mean(classFeature, 2);
        
        %%% Compute covariance matrix for each feature dimension
        normClassFeature = bsxfun(@minus, classFeature, muPerClass(:,i)); % Mean shifted to 0
        sigmaPerClass{i} = normClassFeature * normClassFeature' / (nbTokenPerClass(i)-1); % Compute covariance matrix
        
    end
    
    
    % Model parameters are put in a cell to facilitated data manipulation
    modelParameter{1} = muPerClass;
    modelParameter{2} = sigmaPerClass;
    
end

% --------------------------------- End of file ------------------------------------------
