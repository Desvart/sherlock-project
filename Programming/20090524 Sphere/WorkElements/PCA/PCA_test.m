clear all; close all; clc;

%%% Define database properties
    nbClass      = 3;
    nbFilec      = 5;
    nbFeatf      = 500;

    nbFileC   = nbFilec * ones(1, nbClass);
    nbFile    = sum(nbFileC);
    
    nbTrFeatF = nbFeatf * ones(1, nbFile);
    nbTrFeatC = nbTrFeatF(1) * nbFileC(1) * ones(1, nbClass);
    nbTrFeat  = sum(nbTrFeatF);
    
    mu              = [[0 1]' [0 2]' [0 3]'];
    sigma(:,:,1)    = [100 0;0 .01];
    sigma(:,:,2)    = [100 0;0 .01];
    sigma(:,:,3)    = [100 0;0 .01];
 
    %%% Generate features
    feat  = [];
    label = [];
    classFId = zeros(1, nbClass);
    for cid = 1:nbClass,
        feat  = [feat,mvnrnd(mu(:,cid), sigma(:,:,cid), nbTrFeatC(cid))'];  %#ok<AGROW>
        label = [label,cid*ones(1, nbTrFeatC(cid))];                        %#ok<AGROW>
        classFId(cid) = sum(nbFileC(1:cid-1)) + 1;
    end

    nbDim = 2;
% function PCAmapping = pca(feat, nbDim)
    
    % Compute feature covariance matrix
    covF = cov_(feat);
    
    %%% Eigen analysis of feature covariance matrix
    [eigVect,eigVal] = eig(covF);
    eigVal(isnan(eigVal)) = 0;
    
    %%% Sort eigenvalues and eigenvectors in descending order
    [eigVal,id] = sort(diag(eigVal), 'descend');
    eigVect = eigVect(:,id(1:min(nbDim, size(eigVect, 2))))';
    
    %%% Normalize basis matrix
    eigVal = diag(eigVal(1:min(nbDim, size(eigVect, 2))));
    norm = diag(1./sqrt(eigVal)); 
    
    % Compute reduced PCA transformation matrix
    PCAmapping = norm*eigVect;

% end
mfeat2 = PCAmapping * feat;

    
nbDim = 1;
% function PCAmapping = pca(feat, nbDim)
    
    % Compute feature covariance matrix
    covF = cov_(feat);
    
    %%% Eigen analysis of feature covariance matrix
    [eigVect,eigVal] = eig(covF);
    eigVal(isnan(eigVal)) = 0;
    
    %%% Sort eigenvalues and eigenvectors in descending order
    [eigVal,id] = sort(diag(eigVal), 'descend');
    eigVect = eigVect(:,id(1:min(nbDim, size(eigVect, 2))))';
    
    %%% Normalize basis matrix
    eigVal = diag(eigVal(1:min(nbDim, size(eigVect, 2))));
    norm = diag(1./sqrt(eigVal)); 
    
    % Compute reduced PCA transformation matrix
    PCAmapping = norm*eigVect;

% end
mfeat = PCAmapping * feat;




figure('color', 'w');
hold on;
plot(feat(1,:), feat(2,:), '.');
plot(mfeat2(1,:), mfeat2(2,:), 'r.');
plot(mfeat, zeros(1,nbTrFeat), 'k.');


