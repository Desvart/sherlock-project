% function [trainingFeature, testingFeature] = generateFeature2D()
    clear all;
    clc

    %%% INPUT PARAMETERS
    nbClass         = 3;
    nbFilePerClass  = 1e3 * ones(1, nbClass);
    nbFile          = sum(nbFilePerClass);
    nbFeaturePerFile = 30 * ones(1, nbFile);
    nbFeaturePerClass = nbFeaturePerFile(1) * nbFilePerClass(1) * ones(1, nbClass);
    nbFeature       = sum(nbFeaturePerFile);
    alpha           = ones(1, nbClass) / nbClass;
    mu              = [[0 0]' [9 0]' [0 9]'];
    sigma(:,:,1)    = [1 0;0 1];
    sigma(:,:,2)    = [1 0;0 1];
    sigma(:,:,3)    = [1 0;0 1];
    dim             = size(mu, 1);

 
    %%% TRAINING DATA
    data   = [];
    target = [];
    for i = 1 : nbClass,
        data    = [data mvnrnd(mu(:,i), sigma(:,:,i), nbFeaturePerClass(i))'];
        target  = [target i*ones(1, nbFeaturePerClass(i))];
    end

    trainingFeature.data        = data;
    trainingFeature.target      = target;
    trainingFeature.nbFeature   = nbFeature;
    trainingFeature.nbDim       = dim;
    trainingFeature.nbClass     = nbClass;
    trainingFeature.nbFeaturePerClass = nbFeaturePerClass;
% 
%     
%     %%% TESTING DATA
%     tdata  = [[0,0]',[-1,0]',[9,9]',[8,8]'];
%     target = [1,1,2,2];
% 
%     testingFeature.data             = tdata;
%     testingFeature.target           = target;
%     testingFeature.nbClass          = max(testingFeature.target);
%     testingFeature.nbFeature        = length(testingFeature.target);
%     testingFeature.nbFile           = testingFeature.nbFeature;
%     testingFeature.nbFeaturePerFile = ones(1, testingFeature.nbFile);
%     for i = 1:testingFeature.nbClass,
%         testingFeature.nbFilePerClass(i) = sum(testingFeature.target == i);
%     end
% 
% 
% 
    %%% PLOT
%     global plotFlag;
%     if plotFlag,
        figure;
        hold on;
        plot(data(1,target==1), data(2,target==1), '.b');
        plot(data(1,target==2), data(2,target==2), '.k');
        plot(data(1,target==3), data(2,target==3), '.r');
        grid on;
%     end
%     
% end
% 
% 
% 
% function plotgauss(mu, sigma)
% 
%     xmu = mu(1);
%     ymu = mu(2);
% 
% 
%     A = inv(sigma);	% the inverse covariance matrix
%     % plot between +-2SDs along each dimension 
%     maxsd = max(diag(sigma)); 
%     x = xmu-2*maxsd:0.1:xmu+2*maxsd; % location of points at which x is calculated 
%     y = ymu-2*maxsd:0.1:ymu+2*maxsd; % location of points at which y is calculated
%     [X, Y] = meshgrid(x,y); % matrices used for plotting
%     % Compute value of Gaussian pdf at each point in the grid 
%     z = 1/(2*pi*sqrt(det(sigma))) * exp(-0.5 * (A(1,1)*(X-xmu).^2 + 2*A(1,2)*(X-xmu).*(Y-ymu) + A(2,2)*(Y-ymu).^2));
%     contour(x,y,z, 1);
% 
% end
