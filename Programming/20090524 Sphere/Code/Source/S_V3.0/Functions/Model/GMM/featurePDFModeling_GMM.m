% -------------------------------------------------------------------------------------- %
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% -------------------------------------------------------------------------------------- %


function modelParameter = featurePDFModeling_GMM(trainingFeature, modelParameter)
    
    data            = trainingFeature.data;
    nbClass         = trainingFeature.nbClass;
    target          = trainingFeature.target;
    nbGMM           = modelParameter.model.nbGMM;
    
    alphaPerClass   = cell(nbClass, 1); % Preallocation
    muPerClass      = cell(nbClass, 1); % Preallocation
    sigmaPerClass   = cell(nbClass, 1); % Preallocation

    
    %%% For each class
    for i = 1 : nbClass,
       
        %%% Extract features linked to the actual class
        classFeature = data(:,target==i);
        
        %%% Init EM algo
        [Init.alpha, Init.mu, Init.sigma] = EM_GMM_init(classFeature, nbGMM);
        
        %%% EM algo
        [alphaPerClass{i}, muPerClass{i}, sigmaPerClass{i}] = EM_GMM_fast(classFeature, nbGMM, 0.001, Init);
        
    end
    
   
    %%% Model parameters are put in a cell to facilitated data manipulation
    modelParameter.alpha = alphaPerClass;
    modelParameter.mu    = muPerClass;
    modelParameter.sigma = sigmaPerClass;
    
end

% --------------------------------- End of file ------------------------------------------
