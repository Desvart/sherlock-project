function chrono = raw_feature_analysis()
% RAW_FEATURE_ANALYSIS      Performs analysis of raw features. This analysis is intended to help 
%                           user be aware of the features' structure in the features' space in order
%                           to choose the best features' mapping and model. This function is only 
%                           useful in the development phase of recognition algorithms.
%
% Synopsis:     load_raw_feature()
%
% Inputs:   []
%
% Output:   chrono  = execution time of the function (s).

% Notes: 

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.04  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % --- Launch function chronometer
    chronoTic = tic;
    
    switch feature_('featureDim'),
        case 1,
            plot_1d_raw_feature();
            
        case 2,
            plot_2d_raw_feature();
            
        case 3,
            plot_3d_raw_feature();
            
        case 4,
            plot_4d_raw_feature();
            
        otherwise
            disp('Raw feature dimension is higher than 4 and so on, we cannot plot them.');
    end
    
    % --- Store execution time of this function
    chrono = toc(chronoTic);
    
end





function plot_1d_raw_feature()
% PLOT_1D_RAW_FEATURE   Plot 1D raw feature
%
% Synopsis: plot_1d_raw_feature()
%
% Input :   []
%
% Output:   []

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.04  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    trainingFeature = feature_('trainingFeature');
    trainingFeatureLabel = feature_('trainingFeatureLabel');
    nTrainingFeaturePerClass = feature_('nTrainingFeaturePerClass');
    nClass = feature_('nClass');
    
    
    figure('color', 'white'); hold on;
    colorMap = 'brkgypm';
    
    for iClass = 1:nClass,
        featureForThisClass = trainingFeature(:, trainingFeatureLabel==iClass);
        plot(featureForThisClass, iClass * ones(1, nTrainingFeaturePerClass(iClass)), ['x', colorMap(iClass)]);
    end
    
    xlabel('Dim 1');
    title('Feature space [1D]');
    legend(config_('className'));
   
end %%% End of sub-function


function plot_2d_raw_feature()
% PLOT_2D_RAW_FEATURE   Plot 2D raw feature
%
% Synopsis: plot_2d_raw_feature()
%
% Input :   []
%
% Output:   []

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.04  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    trainingFeature = feature_('trainingFeature');
    trainingFeatureLabel = feature_('trainingFeatureLabel');
    nClass = feature_('nClass');
    
    
    figure('color', 'white'); hold on;
    colorMap = 'brkgypm';
    
    for iClass = 1:nClass,
        featureForThisClass = trainingFeature(:, trainingFeatureLabel==iClass);
        plot(featureForThisClass(1, :), featureForThisClass(2, :), ['.', colorMap(iClass)]);
    end
    
    xlabel('Dim 1');
    ylabel('Dim 2');
    title('Feature space [2D]');
    legend(config_('className'));

end %%% End of sub-function


function plot_3d_raw_feature()
% PLOT_3D_RAW_FEATURE   Plot 3D raw feature
%
% Synopsis: plot_3d_raw_feature()
%
% Input :   []
%
% Output:   []

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.04  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    trainingFeature = feature_('trainingFeature');
    trainingFeatureLabel = feature_('trainingFeatureLabel');
    nClass = feature_('nClass');
    
    
    hf1 = figure('color', 'white'); hold on;
    hf2 = figure('color', 'white'); hold on;
    colorMap = 'brkgypm';
    
    for iClass = 1:nClass,
        featureForThisClass = trainingFeature(:, trainingFeatureLabel==iClass);
        
        figure(hf1);
        plot3(featureForThisClass(1, :), featureForThisClass(2, :), featureForThisClass(3, :), ['.', colorMap(iClass)]);
        
        figure(hf2);
        ha1 = subplot(223); hold on;
        plot(featureForThisClass(1, :), featureForThisClass(2, :), ['.', colorMap(iClass)]);
        ha2 = subplot(221); hold on;
        plot(featureForThisClass(1, :), featureForThisClass(3, :), ['.', colorMap(iClass)]);
        ha3 = subplot(222); hold on;
        plot(featureForThisClass(2, :), featureForThisClass(3, :), ['.', colorMap(iClass)]);
        
    end
    
    figure(hf1);
    view(3); %3D view
    xlabel('Dim 1');
    ylabel('Dim 2');
    zlabel('Dim 3');
    title('Feature space [3D]');
    legend(config_('className'));
    
    xlabel(ha1, 'Dim 1');
    ylabel(ha1, 'Dim 2');
    set(ha1, 'YDir', 'reverse');
    xlabel(ha2, 'Dim 1');
    ylabel(ha2, 'Dim 3');
    xlabel(ha3, 'Dim 2');
    ylabel(ha3, 'Dim 3');
    
    
    

end %%% End of sub-function


function plot_4d_raw_feature()
% PLOT_4D_RAW_FEATURE   Plot 4D raw feature
%
% Synopsis: plot_4d_raw_feature()
%
% Input :   []
%
% Output:   []

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.04  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    trainingFeature = feature_('trainingFeature');
    trainingFeatureLabel = feature_('trainingFeatureLabel');
    nClass = feature_('nClass');
    
    
    figure('color', 'white'); hold on;
    colorMap = 'brkgypm';
    
    for iClass = 1:nClass,
        featureForThisClass = trainingFeature(:, trainingFeatureLabel==iClass);
        icolor = ceil((featureForThisClass(4, :)/max(featureForThisClass(4, :)))*256);
        scatter3(featureForThisClass(1, :), featureForThisClass(2, :), featureForThisClass(3, :), 10, featureForThisClass(4, :), 'filled');
    end
    
    view(3); %3D view
    xlabel('Dim 1');
    ylabel('Dim 2');
    zlabel('Dim 3');
    title('Feature space [3D]');
    legend(config_('className'));

end %%% End of sub-function


% EoF -------------------------------------------------------------------------------------------- %


























