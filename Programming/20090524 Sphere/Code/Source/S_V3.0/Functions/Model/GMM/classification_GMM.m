% ----------------------------------- FUNCTION ----------------------------------------- %
% 
% Function : 
% 
% -------------------------------------------------------------------------------------- %

function membershipPerFrame = classification_GMM(feature, modelParam)

    nbClass = feature.nbClass;
    pwx = zeros(nbClass, feature.nbFeature);
    
    for i = 1 : nbClass,
        pwx(i,:) = posterioriProba(feature.data, modelParam.alpha{i}, modelParam.mu{i}, modelParam.sigma{i});
    end
    
    [~,membershipPerFrame] = max(pwx);

end

function pwx = posterioriProba(data, alpha, mu, sigma)
% le calcul de la probabilité a priori est faite de manière vectorielle (=> calcul des vecteurs et valeurs propres.)
% Le calcul se base sur le fait que arg{max ln sum pxw} = arg{max sum ln pxw} !! A prouver !!

    nbGMM = length(alpha);
    nbData = size(data, 2);
    pwx = zeros(1, nbData);
    
    for i = 1 : nbGMM,
        dataM = bsxfun(@minus, data, mu(:,i));
        [V, D] = eig(sigma(:,:,i));
        M = diag(1./sqrt(diag(D))) * V' * dataM;
        pwx = pwx + log(alpha(i)^2 / det(sigma(:,:,i))) - sum(M.^2);
    end
    
end
