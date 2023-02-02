function generate_raw_feature_from_math_model()
% GENERATE_RAW_FEATURE_FROM_MATH_MODEL  The purpose of this function is to create festures based on 
%       mathematical model. The utility of these features is that they are known and therefore they 
%       allow to test the recognition algorithms.
%       This function adjusts the parameters of the Sphere script so that, from the point of view of
%       the Sphere script, these features appear to be from a real database.
%       The mathematical model proposed here is a combination of Gaussians. The model parameters are
%       editable in the file "config_.m".
%
% Synopsis:     generate_raw_feature_from_math_model()

% Notes: 

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.04  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    fprintf('Ongoing process: generating features...\n');
    
    
    classMean         = config_('classMean');
    classCov          = config_('classCov');
    nFilePerClass     = config_('nFilePerClass');
    nFeaturePerFile   = config_('nFeaturePerFile');

    
    % --- Compute some "virtual database" properties and some feature properties

    [featureDim, nClass] = size(classMean);
    
    % If needed put scalar nbFileC input in array shape
    if isscalar(nFilePerClass),
        nFilePerClass = nFilePerClass(ones(1, nClass));
    elseif length(nFilePerClass) ~= nClass,
        error('Incorrect input: nFilePerClass should have nClass elements.');
    end
    
    % Compute total number of files
    nFile = sum(nFilePerClass);
    
    % If needed put scalar nbFeatF input in array shape
    if isscalar(nFeaturePerFile),
        nFeaturePerFile = nFeaturePerFile(ones(1, nFile));
    elseif length(nFeaturePerFile) ~= nFile,
        error('Incorrect input: nFeaturePerFile should have nFile elements.');
    end
    
    % Compute total number of features
    nFeature = sum(nFeaturePerFile);
    
    % Compute number of features per class
    nFeaturePerClass = zeros(1, nClass); % Preallocation
    stop = 0; % Initialization
    for iClass = 1:nClass,
        start = stop + 1;
        stop  = start + nFilePerClass(iClass) - 1;
        nFeaturePerClass(iClass) = sum(nFeaturePerFile(start:stop));
    end

    % Generate class names
    className = cell(1, nClass); % Preallocation
    for iClass = 1:nClass,
        className{iClass} = ['Class ', num2str(iClass)];
    end
    
    
    % --- Generate features

    feature      = zeros(nFeature, featureDim);
    featureLabel = zeros(1, nFeature);
    fileLabel    = zeros(1, nFile);
    stop  = 0; stop1 = 0;
    for iClass = 1:nClass,
        
        % Compute absolut feature positions
        start = stop + 1;
        stop = start + nFeaturePerClass(iClass) - 1;
        
        % Compute features for actual class and store them in trFeat array
        feature(start:stop, :) = mvnrnd(classMean(:, iClass)', classCov(:, :, iClass), nFeaturePerClass(iClass));
        
        % Determine feature labels
        featureLabel(start:stop)  = iClass(ones(1, nFeaturePerClass(iClass)));
        
        % Determine file labels
        start1 = stop1 + 1;
        stop1  = start1 + nFilePerClass(iClass) - 1;
        fileLabel(start1:stop1) = iClass(ones(1, nFilePerClass(iClass)));
         
    end
    feature = feature';
    
    
%     % -------------------------------------------------------------------------------------------- %
%     % Determine classes et files indexes with files and features indexes refrences
%     % -------------------------------------------------------------------------------------------- %
%     
%     % Preallocation
%     classFiId = zeros(1, nbClass);
%     classFeId = zeros(1, nbClass);
%     fileFeId  = zeros(1, nbFile);
%     
%     % This are the classes indexes from the file indexes and the feature indexes point of view
%     for cid = 1:nbClass,
%         classFiId(cid) = sum(nbFileC(1:cid-1)) + 1;
%         classFeId(cid) = sum(nbFeatC(1:cid-1)) + 1;
%     end
%     
%     %%% This are the files indexes from the feature indexes point of view
%     for fid = 1:nbFile,
%         fileFeId(fid) = sum(nbFeatF(1:fid-1)) + 1;
%     end

    % --- Save data for further computation
    
    config_('className', className);
    
    feature_('nClass', nClass);
    feature_('nFile', nFile);
    feature_('fileLabel', fileLabel);
    feature_('nFilePerClass', nFilePerClass);
    feature_('featureDim', featureDim);
    
    feature_('trainingFeature', feature);
    feature_('trainingFeatureLabel', featureLabel);
    feature_('nTrainingFeature', nFeature);
    feature_('nTrainingFeaturePerClass', nFeaturePerClass);
    feature_('nTrainingFeaturePerFile', nFeaturePerFile);
    
    feature_('testingFeature', feature);
    feature_('testingFeatureLabel', featureLabel);
    feature_('nTestingFeature', nFeature);
    feature_('nTestingFeaturePerClass', nFeaturePerClass);
    feature_('nTestingFeaturePerFile', nFeaturePerFile);
    
    
    fprintf('Features generated.\n\n');

end