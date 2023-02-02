% -------------------------------------------------------------------------------------- %
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% -------------------------------------------------------------------------------------- %


function modelParameter = featurePDFModeling_Bayes(trainingFeature, modelParameter)
    
    data              = trainingFeature.data;
    nbClass           = trainingFeature.nbClass;
    target            = trainingFeature.target;
    nbFeaturePerClass = trainingFeature.nbFeaturePerClass;
    featureDim        = trainingFeature.nbDim;
    
    
    muPerClass      = zeros(featureDim, nbClass); % Preallocation
    sigmaPerClass   = cell(nbClass, 1);           % Preallocation
    for i = 1 : nbClass,
       
        %%% Extract features linked to the actual class
        classFeature = data(:,target==i);
        
        %%% Compute mean for each dimension of the feature
        muPerClass(:,i) = mean(classFeature, 2);
        
        %%% Compute covariance matrix for each feature dimension
        normClassFeature = bsxfun(@minus, classFeature, muPerClass(:,i)); % Mean shifted to 0
        sigmaPerClass{i} = normClassFeature * normClassFeature' / (nbFeaturePerClass(i)-1); % Compute covariance matrix
        
    end
    
    
    % Model parameters are put in a cell to facilitated data manipulation
    modelParameter.mu    = muPerClass;
    modelParameter.sigma = sigmaPerClass;
    
end

% --------------------------------- End of file ------------------------------------------
