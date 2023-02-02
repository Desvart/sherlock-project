% ---------------------------------------- FUNCTION ------------------------------------------------
% 
% This function does the testing part of a sound recognition process. The probability density
% functions (PDF) of the features inputed are modelized by single gaussians (Bayes modeling).
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


function [membership, certainties] = ...
             testingBayes(testingFilePath, testingSNR, featureType, reductionMatrix, modelParameter)

    
    % ----------------------------------------------------------------------------------------------
    % Function initialization
    % ----------------------------------------------------------------------------------------------
    
    % First line of 'testingFile' contains the number of file per class used for training
    nbTestingFilePerClass = testingFilePath{1};
    nbClass               = length(nbTestingFilePerClass);
    nbTestingFile         = sum(nbTestingFilePerClass);
    
    
    % ----------------------------------------------------------------------------------------------
    % Features extraction
    % ----------------------------------------------------------------------------------------------
    
    [feature, ~, ~, nbTokenPerFile] = featureExtraction(testingFilePath, testingSNR, featureType);
    
    
    % ----------------------------------------------------------------------------------------------
    % Features normalization (mean = 0; std = 1)
    % ----------------------------------------------------------------------------------------------
    
    feature = featureNormalization(feature);
   
    
    % ----------------------------------------------------------------------------------------------
    % Features dimension reduction
    % ----------------------------------------------------------------------------------------------
    
    feature = reduceTokenDim(feature, reductionMatrix);
    
    
    % ----------------------------------------------------------------------------------------------
    % Bayes Classification
    % ----------------------------------------------------------------------------------------------
    
    membershipPerFrame = bayesClassification(feature, modelParameter);


    % ----------------------------------------------------------------------------------------------
    % Determine class membership for each sound
    % ----------------------------------------------------------------------------------------------
    
    [membership, certainties] = ...
                     fileClassification(membershipPerFrame, nbTestingFile, nbTokenPerFile, nbClass);

    
               
end %function




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
%                                  NESTED FUNCTION                                       %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %



% ----------------------------------- FUNCTION ----------------------------------------- %
% 
% Function : 
% 
% -------------------------------------------------------------------------------------- %

function feature = reduceTokenDim(feature, reductionMatrix)

    % ------------------------------------------------------------------------------------
    % Reduce tokens' dimension by a Principal Component Analysis (PCA)
    % ------------------------------------------------------------------------------------
    
    if ~isempty(reductionMatrix{1}),
        
        % Apply the transformation matrix on features
        feature = reductionMatrix{1} * feature;
        
    end
    
    
    % ------------------------------------------------------------------------------------
    % Reduce tokens' dimension by a Linear Discriminant Analysis (LDA)
    % ------------------------------------------------------------------------------------
    
    if ~isempty(reductionMatrix{2}),

        % Apply the transformation matrix on features
        feature = reductionMatrix{2} * feature;

    end
    
end



% ----------------------------------- FUNCTION ----------------------------------------- %
% 
% Function : 
% 
% -------------------------------------------------------------------------------------- %

function membershipPerFrame = bayesClassification(feature, modelParameter)

    %%% Compute Bayes distance 
    %   [AD Thesis pp. 67-69]
    nbClass = length(modelParameter{2});
    bayesDist = zeros(nbClass, size(feature, 2)); % Preallocation
    
    for i = 1 : nbClass,
        
        % Extract PDF parameters (mean and cov) for actual class
        meanVector = modelParameter{1}(:,i);
        covMatrix  = modelParameter{2}{i};
    
        % Substract actual class' mean from feature
        centeredFeature = bsxfun(@minus, feature, meanVector);
        
        % Compute Bayes distance.
        % (x-mu_i)'*C_i^-1*(x-mu_i) == D^-1/2*V'*(x-mu_i)
        % Cf. documentation
        [V, D] = eig(covMatrix);
        M = diag(1./sqrt(diag(D))) * V';
        d1 = M * centeredFeature;
        bayesDist(i,:) = sum(d1.^2) + log(det(covMatrix));
    end
    
%     [~, membershipPerFrame] = min([bayesDist; Inf*ones(1, totNbFrame)]); % A SUPPRIMER SI LA LIGNE SUIVANTE MARCHE.
    [~, membershipPerFrame] = min(bayesDist);

end



% ----------------------------------- FUNCTION ----------------------------------------- %
% 
% Function : 
% 
% -------------------------------------------------------------------------------------- %

function [membership, certainties] = ...
                      fileClassification(membershipPerFrame, nbTestingFile, nbTokenPerFile, nbClass)
    
    membership  = zeros(1, nbTestingFile);       % Preallocation
    certainties = zeros(nbTestingFile, nbClass); % Preallocation
    
    % Loop for each sound
    for i = 1 : nbTestingFile, 

        start = sum(nbTokenPerFile(1:i-1))+1; % Index of first frame of current sound
        stop  = sum(nbTokenPerFile(1:i));     % Index of last frame of current sound

        % Determine number of frames belonging to each class
        nbFrameBelongingToEachClass = zeros(1, nbClass); % Preallocation
        for j = 1 : nbClass,
            nbFrameBelongingToEachClass(j) = sum(membershipPerFrame(start:stop)==j);
        end

        % See which class is the winner
        [~, membership(i)] = max(nbFrameBelongingToEachClass);

        % Calculate certainties
        certainties(i,:) = nbFrameBelongingToEachClass / sum(nbFrameBelongingToEachClass);
    end
    
end


% --------------------------------- End of file -------------------------------------------------- %
