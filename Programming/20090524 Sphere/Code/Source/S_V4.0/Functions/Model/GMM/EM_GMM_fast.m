% data : dim x nbData
% init : init.alpha : 1 x nbGMM
%        init.mu    : dim x nbGMM
%        init.sigma : dim x dim x nbGMM
% maxiter : OPT
%
% alpha : 1 x nbGMM
% mu    : dim x nbGMM
% sigma : dim x dim x nbGMM

function [alpha, mu, sigma] = EM_GMM_fast(data, nbGMM, tol, init, maxiter)

    if nargin == 4,
        maxiter = 1000;
    end
    alpha = init.alpha;
    mu    = init.mu;
    sigma = init.sigma;
    
    %%% Init EM loop variables
    niter = 1;
    delta = tol;
    
    %%% Start EM loop
    while delta >= tol && niter <= maxiter,
        
        %%% Back up param previous iteration       
        alpha_old = alpha;
        mu_old = mu;
        sigma_old = sigma;
        
        %%% E-step
        try
            E = expectation(data, nbGMM, alpha, mu, sigma);
        catch exception
            throw(exception);
        end
        
        %%% M-step
        [alpha, mu, sigma] = maximization(data, nbGMM, E);

        %%% Convergence condition
        delta = sum(abs(alpha_old - alpha)) + ...
                sum(sum(abs(mu_old - mu))) + ...
                sum(sum(sum(abs(sigma_old - sigma))));

        %%% Increment loop index
        niter = niter + 1;

    end

end


function E = expectation(data, nbGMM, alpha, mu, sigma)
    

    nbData = size(data, 2);
    pxw = zeros(nbGMM, nbData); % Preallocation
    for i = 1 : nbGMM,
        pxw(i,:) = alpha(i)*mvnpdf(data', mu(:,i)', sigma(:,:,i))'; % P(x|w)
    end
    E = bsxfun(@rdivide, pxw, sum(pxw, 1));
    
end


function [alpha, mu, sigma] = maximization(data, nbGMM, E)

    [dim,nbData] = size(data);
    sigma = zeros(dim, dim, nbGMM); % Preallocation
    sigma0 = eye(dim)*1e-6; % Regularizazion factor for covariance matrix
    alpha = sum(E, 2)';
    mu    = bsxfun(@rdivide, data*E', alpha);
    for i = 1 : nbGMM,
        dataMu = bsxfun(@minus, data, mu(:,i));
        sigma(:,:,i) = (bsxfun(@times, dataMu, E(i,:)) * dataMu' + sigma0) / alpha(i);
    end
    alpha = alpha/nbData;

end
