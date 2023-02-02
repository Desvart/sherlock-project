function [alpha, mu, sigma] = EM_GMM_init(data, nbGMM, niter)

    if nargin == 2,
        niter = 1000;
    end

    [dim, nbData] = size(data);
    C = NaN*ones(nbGMM, dim); % Preallocation
    while sum(isnan(C)) > 0,
        % Ci(nx1) - cluster indices;
        % C(k,d)  - cluster centroid (i.e. mean)
        [Ci, C] = kmeans(data', nbGMM, ...
                         'Start',       'cluster', ...
                         'Maxiter',     niter, ...
                         'EmptyAction', 'drop', ...
                         'Display',     'off');
    end

    mu = C';

    alpha = zeros(1, nbGMM); % Preallocation
    sigma = zeros(dim, dim, nbGMM); % Preallocation
    for i = 1 : nbGMM,

        % Alpha is initialized as the number of data assigned to each Gaussian (sum(Ci==i)) divided by
        % the total number of data (nbData).
        alpha(i) = sum(Ci==i)/nbData;

        % Covariance of data set belonging to each gaussian
        sigma(:,:,i) = cov(data(:,Ci==i)');
    end
    
end
