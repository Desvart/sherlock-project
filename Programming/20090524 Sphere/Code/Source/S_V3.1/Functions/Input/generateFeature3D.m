function feature = generateFeature3D()


    %%% INPUT PARAMETERS
    nbClass         = 3;
    nbFilePerClass  = 1e3 * ones(1, nbClass);
    nbFile          = sum(nbFilePerClass);
    nbFeaturePerFile = 30 * ones(1, nbFile);
    nbFeaturePerClass = nbFeaturePerFile(1) * nbFilePerClass(1) * ones(1, nbClass);
    nbFeature       = sum(nbFeaturePerFile);
%     alpha           = ones(1, nbClass) / nbClass;
    mu              = [[0 0 0]' [9 0 0]' [0 0 9]'];
    sigma(:,:,1)    = [1 0 0;0 1 0;0 0 1];
    sigma(:,:,2)    = [1 0 0;0 1 0;0 0 1];
    sigma(:,:,3)    = [1 0 0;0 1 0;0 0 1];
    dim             = size(mu, 1);

 
    %%% TRAINING DATA
    data   = [];
    target = [];
    for i = 1 : nbClass,
        data    = [data mvnrnd(mu(:,i), sigma(:,:,i), nbFeaturePerClass(i))'];
        target  = [target i*ones(1, nbFeaturePerClass(i))];
    end

    feature.data        = data;
    feature.target      = target;
    feature.nbFeature   = nbFeature;
    feature.nbDim       = dim;
    feature.nbClass     = nbClass;
    feature.nbFeaturePerClass = nbFeaturePerClass;


    %%% PLOT
    global plotFlag;
    if plotFlag,
        figure;
        hold on;
        plot3(data(1,target==1), data(2,target==1), data(3,target==1), '.b');
        plot3(data(1,target==2), data(2,target==2), data(3,target==2), '.k');
        plot3(data(1,target==3), data(2,target==3), data(3,target==3), '.r');
        grid on;
    end
            
end
