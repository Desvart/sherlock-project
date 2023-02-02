function feature = generateFeature2D()

    %%% INPUT PARAMETERS
    nbClass         = 3;
    nbFilePerClass  = 20 * ones(1, nbClass);
    nbFile          = sum(nbFilePerClass);
    nbFeaturePerFile = 30 * ones(1, nbFile);
    nbFeaturePerClass = nbFeaturePerFile(1) * nbFilePerClass(1) * ones(1, nbClass);
    nbFeature       = sum(nbFeaturePerFile);
%     alpha           = ones(1, nbClass) / nbClass;
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
    
%     data = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 1 71 81 920 21 22 23;...
%             0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 1 71 81 920 21 22 23];
%     data = bsxfun(@plus, data, [100;200]);
%     target = [ones(1,12), 2*ones(1,12)];

    feature.data        = data;
    feature.target      = target;
    feature.nbFeature   = nbFeature;
    feature.nbFile      = nbFile;
    feature.nbFilePerClass = nbFilePerClass;
    feature.nbDim       = dim;
    feature.nbClass     = nbClass;
    feature.nbFeaturePerClass = nbFeaturePerClass;
    feature.nbFeaturePerFile = nbFeaturePerFile;
    feature.className   = 0;


    %%% PLOT
    global plotFlag;
    if plotFlag,
        figure;
        hold on;
        plot(data(1,target==1), data(2,target==1), '.b');
        plot(data(1,target==2), data(2,target==2), '.k');
        plot(data(1,target==3), data(2,target==3), '.r');
        grid on;
    end
    
end

