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
    
    mu              = [[0 -9]' [5 9]' [9 0]'] + 10;
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
% function LDAmapping = lda(feat, label, nbDim)
    
    [dim,nbFeat] = size(feat);
    nbClass = max(label);
    
    % Preallocation (Within-class scatter matrix)
    Sw = zeros(dim, dim);
    
    % Compute mixture scatter matrix
    Sm = cov_(feat);
    
    % Sum over classes
    for i = 1:nbClass,
        curFeat = feat(:,label==i);
        p = size(curFeat, 2)/(nbFeat-1);
        Sw = Sw + p*cov_(curFeat);
    end
    
    % Compute between class scatter matrix
    Sb = Sm - Sw;
    
    % make sure not to embed in too high dimension
    if nbClass <= nbDim,
        nbDim = nbClass - 1;
        warning(['Target dimensionality reduced to ',num2str(nbDim),'.']); %#ok<WNTAG>
    end
    
    % Perform eigen decomposition of inv(Sw)*Sb
    [eigVect,eigVal] = eig(Sb, Sw);
    eigVal(isnan(eigVal)) = 0;
    
    % Sort eigenvalues and eigenvectors in descending order
    [~,id] = sort(diag(eigVal), 'descend');
    LDAmapping = eigVect(:,id(1:min(nbDim, size(eigVect, 2))));
    
% end
    
    mfeat = LDAmapping * feat;




figure('color', 'w');
hold on;
plot(feat(1,:), feat(2,:), '.');
plot(mfeat(1,:), mfeat(2,:), 'r.');
% plot(mfeat, zeros(1,nbTrFeat), 'k.');

    
    
