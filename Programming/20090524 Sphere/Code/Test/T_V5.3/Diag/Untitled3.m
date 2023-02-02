close all;
clear all;
clc;

% --- Training ----------------------------

trFeature1 = mvnrnd([5,0], [1,0;0,1], 100)';
trFeature2 = mvnrnd([0,5], [1,0;0,1], 100)';
trFeature0 = [trFeature1, trFeature2];

plot(trFeature1(1,:), trFeature1(2,:), '.k'); hold on
plot(trFeature2(1,:), trFeature2(2,:), '+k');

% --- Normalize
%%% Substract mean
meanNorm = mean(trFeature0, 2);
trFeature0M = bsxfun(@minus, trFeature0, meanNorm);

%%% Divide by std
stdNorm = sqrt(mean(trFeature0M.^2, 2));
trFeature = bsxfun(@rdivide, trFeature0M, stdNorm);


% --- Build bayesian model
%%% Compute mean for each dimension of the feature
meanVect1 = mean(trFeature(:, 1:10), 2);
meanVect2 = mean(trFeature(:, 11:20), 2);

%%% Compute covariance matrix for each feature dimension
trFeature1N = bsxfun(@minus, trFeature(:, 1:10), meanVect1); % Mean shifted to 0
covMatrix1 = trFeature1N * trFeature1N' / (10-1);
trFeature2N = bsxfun(@minus, trFeature(:, 11:20), meanVect2); % Mean shifted to 0
covMatrix2 = trFeature2N * trFeature2N' / (10-1);


% --- Testing ----------------------------

teFeature1 = mvnrnd([5,0], [1,0,;0,1], 5)';
teFeature2 = mvnrnd([0,5], [1,0,;0,1], 5)';
teFeature = [teFeature1, teFeature2];
plot(teFeature1(1,:), teFeature1(2,:), 'r.');
plot(teFeature2(1,:), teFeature2(2,:), 'r+');

% --- Normalize
teFeature0M = bsxfun(@minus, teFeature, meanNorm);
teFeature = bsxfun(@rdivide, teFeature0M, stdNorm);


% --- Compute probability #1
teFeatureM = bsxfun(@minus, teFeature, meanVect1);
bayesDist1 = log(det(covMatrix1)) + diag(teFeatureM'*(covMatrix1\teFeatureM))';
teFeatureM = bsxfun(@minus, teFeature, meanVect2);
bayesDist2 = log(det(covMatrix2)) + diag(teFeatureM'*(covMatrix2\teFeatureM))';


[b, a] = min([bayesDist1; bayesDist2]);
disp(a);

for i = 1 : 10,
    teFeatureM = bsxfun(@minus, teFeature(:,i), meanVect1);
    bayesDist1(i) = log(det(covMatrix1)) + diag(teFeatureM'*(covMatrix1\teFeatureM))';
    teFeatureM = bsxfun(@minus, teFeature(:,i), meanVect2);
    bayesDist2(i) = log(det(covMatrix2)) + diag(teFeatureM'*(covMatrix2\teFeatureM))';
end

[b, a] = min([bayesDist1; bayesDist2]);
disp(a);








