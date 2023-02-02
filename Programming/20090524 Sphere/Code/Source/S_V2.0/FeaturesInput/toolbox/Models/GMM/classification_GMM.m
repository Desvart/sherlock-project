% ----------------------------------- FUNCTION ----------------------------------------- %
% 
% Function : 
% 
% -------------------------------------------------------------------------------------- %

function membershipPerFrame = classification_GMM(feature, modelParameter)

    nbClass = length(modelParameter{1});
    nbToken = size(feature, 2);
%     likelihood = zeros(nbClass, nbToken);
    pwx = zeros(nbClass, nbToken);
    
    for i = 1 : nbClass,
        alpha = modelParameter{1}{i};
        mu    = modelParameter{2}{i};
        sigma = modelParameter{3}{i};
%         nbGMM = length(alpha);
%         likelihood(i,:) = logLikelihood(feature, nbGMM, alpha, mu, sigma);
        pwx(i,:) = posterioriProba(feature, alpha, mu, sigma);
    end
    
    [~,membershipPerFrame] = max(pwx);

end


function L = logLikelihood(data, nbGMM, alpha, mu, sigma)

    dim = size(data, 1);
    L = 0;
    for i = 1 : nbGMM,
        dataMu = bsxfun(@minus, data, mu(:,i));
        [D, V] = eig(sigma(:,:,i));
        L = sum((diag(1./sqrt(diag(D)))*V'*dataMu).^2);
        L = log(alpha(i)) - 0.5*(dim*log(2*pi) + log(abs(det(sigma(:,:,i)))) - L);
%         L = L + sum(tmp);
    end
    
end


function pwx = posterioriProba(data, alpha, mu, sigma)

    [dim, nbData] = size(data);
    nbGMM = length(alpha);
    pwx = 0;
%     for i = 1 : nbData,
        for i = 1 : nbGMM,
            dataMu = bsxfun(@minus, data, mu(:,i));
            [D, V] = eig(sigma(:,:,i));
            pwx = pwx + alpha(i)/sqrt(2*pi*det(sigma(:,:,i)))*exp(sum((diag(1./sqrt(diag(D)))*V'*dataMu).^2));
%             L = log(alpha(i)) - 0.5*(dim*log(2*pi) + log(abs(det(sigma(:,:,i)))) - L);
        end
%     end
    
end
