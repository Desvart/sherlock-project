close all; clear all; clc;

nbDim = 3;

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
    sigma(:,:,1)    = [100 0;0 1];
    sigma(:,:,2)    = [100 0;0 1];
    sigma(:,:,3)    = [100 0;0 1];
 
    %%% Generate features
    data  = [];
    label = [];
    classFId = zeros(1, nbClass);
    for cid = 1:nbClass,
        data  = [data,mvnrnd(mu(:,cid), sigma(:,:,cid), nbTrFeatC(cid))'];  %#ok<AGROW>
        label = [label,cid*ones(1, nbTrFeatC(cid))];                        %#ok<AGROW>
        classFId(cid) = sum(nbFileC(1:cid-1)) + 1;
    end

% data = [1 0 2; ...
%         1 3 5];   
% PCAmapping = pca(data);
nbData = size(data, 2);
dataMean = mean(data, 2);

data = bsxfun(@minus, data, dataMean);
% dataStd = sqrt(sum(dataC.^2, 2)/(nbData-1));
% 
% dataCC = bsxfun(@rdivide, dataC, dataStd);
% 
% % Compute covariance matrix
% covMatrix = (dataCC*dataCC')/nbData;
covMatrix = (data*data')/nbData;
	
% Perform eigen decomposition of covMatrix
[eigVect,eigVal] = eig(covMatrix);

%%% Sort eigen values and vectors in descending order
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

% PCA normalization
% PCAmapping = diag(1./sqrt(eigVal))*PCAmapping;

% Apply mapping
dataM = PCAmapping * data;


figure;
hold on;
plot(data(1,:), data(2,:), '*k');
% plot(dataCC(1,:), dataCC(2,:), '.r');
plot(dataM(1,:), dataM(2,:), '.b');
% plot([0,eigVal(1)*eigVect(1,1)],[0,eigVal(1)*eigVect(2,1)], 'y')
% plot([0,eigVal(1)*eigVect(1,2)],[0,eigVal(1)*eigVect(2,2)], 'y')

plot([0,eigVect(1,1)],[0,eigVect(2,1)], 'y')
plot([0,eigVect(1,2)],[0,eigVect(2,2)], 'y')
axis tight;

mean(dataM, 2)
std(dataM, 0, 2)
