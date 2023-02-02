% data : dim x nbData
% init : init.alpha : 1 x nbGMM
%        init.mu    : dim x nbGMM
%        init.sigma : dim x dim x nbGMM
% maxiter : OPT
%
% alpha : 1 x nbGMM
% mu    : dim x nbGMM
% sigma : dim x dim x nbGMM

function [alpha, mu, sigma, L] = EM_GMM2(data, nbGMM, tol, init, maxiter)

    if nargin == 4,
        maxiter = 1000;
    end
    alpha = init.alpha;
    mu    = init.mu;
    sigma = init.sigma;
    
    %%% Init EM loop variables
    niter = 1;
    converged = false;
    L = -inf(1, maxiter);
    L(niter) = logLikelihood(data, nbGMM, alpha, mu, sigma);
    
    %%% Start EM loop
    while ~converged && niter <= maxiter,
        
        %%% Increment loop index
        niter = niter + 1;
        
        %%% E-step
        E = expectation(data, nbGMM, alpha, mu, sigma);

        %%% M-step
        [alpha, mu, sigma] = maximization(data, nbGMM, E);

        %%% Convergence condition
        L(niter) = logLikelihood(data, nbGMM, alpha, mu, sigma);
        converged = abs(L(niter-1) - L(niter)) < tol*abs(L(niter));

    end
    L = L(1:niter);

end


function E = expectation(data, nbGMM, alpha, mu, sigma)
    % If there is some ill-conditionning problems try to replace last line by this code :
    % total = sum(pxw, 1);
    % total(total==0) = eps; 
    % E = bsxfun(@rdivide, pxw, total);
    
    nbData = size(data, 2);
    pxw = zeros(nbGMM, nbData); % Preallocation
    for i = 1 : nbGMM,
        pxw(i,:) = alpha(i)*mvnpdf(data', mu(:,i)', sigma(:,:,i))'; % P(x|w)
    end

%     E = bsxfun(@rdivide, pxw, sum(pxw));
    total = sum(pxw, 1);
    total(total==0) = eps; 
    E = bsxfun(@rdivide, pxw, total);
    
end


function [alpha, mu, sigma] = maximization(data, nbGMM, E)

    [dim,nbData] = size(data);
    sigma = zeros(dim, dim, nbGMM); % Preallocation
    sigma0 = eye(dim) * 1e-6;
    alpha = sum(E, 2)';
    mu    = bsxfun(@rdivide, data*E', alpha);
    for i = 1 : nbGMM,
        dataMu = bsxfun(@minus, data, mu(:,i));
        sigma(:,:,i) = (bsxfun(@times, dataMu, E(i,:)) * dataMu' + sigma0) / alpha(i);
    end
    alpha = alpha/nbData;

end


function L = logLikelihood(data, nbGMM, alpha, mu, sigma)

    dim = size(data, 1);
    L = 0;
    for i = 1 : nbGMM,
        dataMu = bsxfun(@minus, data, mu(:,i));
        [D, V] = eig(sigma(:,:,i));
        tmp = sum((diag(1./sqrt(diag(D)))*V'*dataMu).^2);
        tmp = log(alpha(i)) -0.5*(dim*log(2*pi) + log(abs(det(sigma(:,:,i)))) - tmp);
        L = L + sum(tmp);
    end
    
end
