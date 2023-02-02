function [trainingFeature, testingFeature] = generateFeature(input)
    global plotFlag;

    switch input.inputMode,
        
        
        case 2,
            
            %%% TRAINING DATA
            dataClass1 = mvnrnd([0,0], [4,0;0,1], 1000)';
            dataClass2 = mvnrnd([9,9], [1,0;0,1], 1000)';
            data       = [dataClass1,dataClass2];
            target     = [ones(1, 1e3),2*ones(1, 1e3)];
            
            trainingFeature.data        = data;
            trainingFeature.target      = target;
            [nbDim, nbFeature]          = size(data);
            trainingFeature.nbFeature   = nbFeature;
            trainingFeature.nbDim       = nbDim;
            trainingFeature.nbClass     = max(target);
            for i = 1 : trainingFeature.nbClass,
                trainingFeature.nbFeaturePerClass(i) = sum(target == i);
            end
            
            

            %%% TESTING DATA
            tdata  = [[0,0]',[-1,0]',[9,9]',[8,8]'];
            target = [1,1,2,2];
            
            testingFeature.data             = tdata;
            testingFeature.target           = target;
            testingFeature.nbClass          = max(testingFeature.target);
            testingFeature.nbFeature        = length(testingFeature.target);
            testingFeature.nbFile           = testingFeature.nbFeature;
            testingFeature.nbFeaturePerFile = ones(1, testingFeature.nbFile);
            for i = 1:testingFeature.nbClass,
                testingFeature.nbFilePerClass(i) = sum(testingFeature.target == i);
            end
            
            
            
            %%% PLOT
            if plotFlag,
                figure;
                hold on;
                plot(dataClass1(1,:), dataClass1(2,:), '.k');
                plot(dataClass2(1,:), dataClass2(2,:), '.b');
                plot(testingFeature.data(1,:), testingFeature.data(2,:), '+r');
                grid on;
            end
            
            
        case 3,
            dataClass1 = mvnrnd([0,0,0], [4,0,0;0,1,0;0,0,1], 1000)';
            dataClass2 = mvnrnd([9,9,9], [1,0,0;0,1,0;0,0,1], 1000)';

            trainingFeature.nbClass = 2;
            trainingFeature.nbFeaturePerClass = [1e3, 1e3];
            trainingFeature.data   = [dataClass1,dataClass2];
            trainingFeature.target = [ones(1, 1e3),2*ones(1, 1e3)];
            trainingFeature.nbDim = 3;
            trainingFeature.nbClass = 2;

            testingFeature.data = [[0,0,0]', [9,9,9]'];
            testingFeature.target = [1,2];
            testingFeature.nbClass = max(testingFeature.target);
            for i = 1:testingFeature.nbClass,
                testingFile.nbFilePerClass(i) = sum(testingFeature.target == i);
            end
            
            testingFeature.nbFeature = length(target);
            testingFeature.nbFile = testingFeature.nbFeature;
            testingFeature.nbFeaturePerFile = ones(1, testingFeature.nbFile);

            if plotFlag,
                figure;
                hold on;
                plot3(dataClass1(1,:), dataClass1(2,:), dataClass1(3,:), '.k');
                plot3(dataClass2(1,:), dataClass2(2,:), dataClass2(3,:), '.b');
                plot3(testingFeature.data(1,:), testingFeature.data(2,:), testingFeature.data(3,:), '+r');
                grid on;
            end
    end
    
end



function plotgauss(mu, sigma)

    xmu = mu(1);
    ymu = mu(2);


    A = inv(sigma);	% the inverse covariance matrix
    % plot between +-2SDs along each dimension 
    maxsd = max(diag(sigma)); 
    x = xmu-2*maxsd:0.1:xmu+2*maxsd; % location of points at which x is calculated 
    y = ymu-2*maxsd:0.1:ymu+2*maxsd; % location of points at which y is calculated
    [X, Y] = meshgrid(x,y); % matrices used for plotting
    % Compute value of Gaussian pdf at each point in the grid 
    z = 1/(2*pi*sqrt(det(sigma))) * exp(-0.5 * (A(1,1)*(X-xmu).^2 + 2*A(1,2)*(X-xmu).*(Y-ymu) + A(2,2)*(Y-ymu).^2));
    contour(x,y,z, 1);

end
