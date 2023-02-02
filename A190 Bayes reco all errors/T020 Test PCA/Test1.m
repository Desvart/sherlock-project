close all;
clear all;
clc;

nObs = 50;



%% Create observations

obsC1Vec    = repmat([18,  5], [nObs, 1]) + randn(nObs, 2)*chol([ 1, 0.5; 0.5, 20]);
obsC2Vec    = repmat([15, -2], [nObs, 1]) + randn(nObs, 2)*chol([10, 0  ; 0,   5]);
allObsArr   = cat(1, obsC1Vec, obsC2Vec);



%% Norm obs

obsNormMeanVec  = mean(allObsArr);
allObsNorm1Arr  = bsxfun(@minus, allObsArr, obsNormMeanVec);

obsNormStdVec   = std(allObsArr);
allObsNormArr   = bsxfun(@rdivide, allObsNorm1Arr, obsNormStdVec);



%% Check norm bsxfun validity

allObsNorm1Arr2 = nan(nObs*2, 2);
allObsNormArr2  = nan(nObs*2, 2);

for iObs = 1 : nObs*2,
    allObsNorm1Arr2(iObs, :) = allObsArr(iObs, :) - obsNormMeanVec;
    allObsNormArr2(iObs, :)  = allObsNorm1Arr2(iObs, :) ./ obsNormStdVec;
end

checkAllallObsNorm1Arr = (allObsNorm1Arr == allObsNorm1Arr2);
checkAllallObsNormArr  = (allObsNormArr  == allObsNormArr2);
if ~all(all(checkAllallObsNorm1Arr)) || ~all(all(checkAllallObsNormArr)),
    error('Normalization has failed.');
end



%% PCA observation

[pcaMappingMat, allObsNormMapArr]   = pca(allObsNormArr);
% allObsNormMapRedArr                 = allObsNormMapArr(:, 1:nFeats);



%% Check PCA validity

covMat = allObsNormArr'*allObsNormArr/(nObs*2-1); % Compute covariance matrix of the feature matrix
[eigenVec, eigenVal] = eig(covMat);  % Eigen analysis of feature covariance matrix
eigenVal = diag(eigenVal);
norm = diag(1./sqrt(eigenVal(end : -1 : 1))); % Normalize basis matrix
%     norm = 1; % No normalization
pcaMappingMat = norm*eigenVec(:, end : -1 : 1)'; % Compute basis matrix

allObsNormMapArr = allObsNormArr * pcaMappingMat'; % Feature projection on new basis




%% Plot observations

screenSize = get(0, 'ScreenSize');
outerPosition = [screenSize(3), 1, screenSize(3:4)];
figure('Color', 'White', 'OuterPosition', outerPosition);

subplot(2, 2, 1);
hold on;

plot(obsC1Vec(:,1), obsC1Vec(:,2), '*b');
plot(obsC2Vec(:,1), obsC2Vec(:,2), '*r');

title('Feature space');



%% Plot normalized observations

subplot(2, 2, 2);
hold on;

plot(allObsNormArr(1:nObs,     1), allObsNormArr(1:nObs,     2), '*b');
plot(allObsNormArr(nObs+1:end, 1), allObsNormArr(nObs+1:end, 2), '*r');

title('Normalized feature space');



%% Plot mapped observations

subplot(2, 2, 3);
hold on;

plot(allObsNormMapArr(1:nObs,     1), allObsNormMapArr(1:nObs,     2), '*b');
plot(allObsNormMapArr(nObs+1:end, 1), allObsNormMapArr(nObs+1:end, 2), '*r');

title('Normalized feature space');



%% Plot PCA transform obs by obs

subplot(2, 2, 4);
hold on;

title('Normalized feature space');

obsStopIdx = 0;

for iObs = 1 : nObs/10*2,
    
    cla;
    
    obsStartIdx = obsStopIdx + 1;
    obsStopIdx  = obsStartIdx + 10 - 1;
    obsArr      = allObsArr(obsStartIdx:obsStopIdx, :);
    
    obsNorm1Arr = bsxfun(@minus, obsArr, obsNormMeanVec);
    obsNormArr  = bsxfun(@rdivide, obsNorm1Arr, obsNormStdVec);
    
    
    obsNormMapArr   = obsNormArr * pcaMappingMat' ;

    plot(obsNormMapArr(:, 1), obsNormMapArr(:, 2), 'og');
    
    if obsStopIdx < nObs + 1,
        colorVal = 'b';
    else
        colorVal = 'r';
    end
    
    
    plot(allObsNormMapArr(1:nObs,     1), allObsNormMapArr(1:nObs,     2), '*b');
    plot(allObsNormMapArr(nObs+1:end, 1), allObsNormMapArr(nObs+1:end, 2), '*r');
    
    plot(allObsNormMapArr(obsStartIdx:obsStopIdx, 1), allObsNormMapArr(obsStartIdx:obsStopIdx, 2), '+g');
    
%     pause();
    
end










% eof
