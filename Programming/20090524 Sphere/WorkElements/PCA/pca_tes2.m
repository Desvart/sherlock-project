clear all; close all; clc;

%%% Define database properties
%     nbClass      = 3;
%     nbFilec      = 5;
%     nbFeatf      = 500;
% 
%     nbFileC   = nbFilec * ones(1, nbClass);
%     nbFile    = sum(nbFileC);
%     
%     nbTrFeatF = nbFeatf * ones(1, nbFile);
%     nbTrFeatC = nbTrFeatF(1) * nbFileC(1) * ones(1, nbClass);
%     nbTrFeat  = sum(nbTrFeatF);
%     
%     mu              = [[0 -9]' [5 9]' [9 0]'] + 10;
%     sigma(:,:,1)    = [100 0;0 .01];
%     sigma(:,:,2)    = [100 0;0 .01];
%     sigma(:,:,3)    = [100 0;0 .01];
%  
%     %%% Generate features
%     data  = [];
%     label = [];
%     classFId = zeros(1, nbClass);
%     for cid = 1:nbClass,
%         data  = [data,mvnrnd(mu(:,cid), sigma(:,:,cid), nbTrFeatC(cid))'];  %#ok<AGROW>
%         label = [label,cid*ones(1, nbTrFeatC(cid))];                        %#ok<AGROW>
%         classFId(cid) = sum(nbFileC(1:cid-1)) + 1;
%     end

data = [1 2 1; ...
        1 2 5];


    nbDim = 2;
% function PCAmapping = pca(data, nbDim)

    % Evaluate data dimensions
%     [dim,nbData] = size(data);

    dataC = bsxfun(@minus, data, mean(data, 2));
    dataC = bsxfun(@rdivide, dataC, std(dataC, 0, 2));

	% Compute covariance matrix
    covMatrix = cov_(dataC);
	
	% Perform eigendecomposition of covMatrix
    [eigVect,eigVal] = eig(covMatrix);
    
    %%% Sort eigenvectors in descending order
    [eigVal,id] = sort(diag(eigVal), 'descend');
    eigVect = eigVect(:,id);
    
    %%% Reduce dimension if needed
    maxDim = size(eigVect, 2);
    if nbDim > maxDim,
        nbDim = maxDim;
        warning(['Target dimensionality reduced to ',num2str(nbDim),'.']); %#ok<WNTAG>
    end
	PCAmapping = eigVect(:,1:nbDim);
    eigVal     = eigVal(1:nbDim);
	
    % Normalize in order to get eigenvectors of covariance matrix
%     if dim >= nbData,
%         PCAmapping = bsxfun(@times, data'*PCAmapping, (1./sqrt(nbData.*eigVal))');     
%     end
    PCAmapping = diag(1./sqrt(eigVal))*PCAmapping
    
    mfeat = PCAmapping * dataC;




figure('color', 'w');
hold on;
plot(data(1,:), data(2,:), '*');
plot(dataC(1,:), dataC(2,:), 'ko');
plot(mfeat(1,:), mfeat(2,:), 'r.');
% plot(mfeat, zeros(1,nbTrFeat), 'k.');

    
    
