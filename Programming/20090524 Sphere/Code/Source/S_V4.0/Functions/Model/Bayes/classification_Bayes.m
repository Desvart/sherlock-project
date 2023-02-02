% ----------------------------------- FUNCTION ----------------------------------------- %
% 
% Function : 
% 
% -------------------------------------------------------------------------------------- %

function membershipPerFrame = classification_Bayes(feature, modelParameter)

    %%% Compute Bayes distance 
    %   [AD Thesis pp. 67-69]
    nbClass = feature.nbClass;
    bayesDist = zeros(nbClass, feature.nbFeature); % Preallocation
    
    for i = 1 : nbClass,
        
        % Extract PDF parameters (mean and cov) for actual class
        meanVector = modelParameter.mu(:,i);
        covMatrix  = modelParameter.sigma{i};
    
        % Substract actual class' mean from feature
        centeredFeature = bsxfun(@minus, feature.data, meanVector);
        
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
