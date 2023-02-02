function output = feature_(varargin) 
% FEATURE_	This structure contains all values related to features computed during process. This is
%           a convenient way to access this data without declaring a global variable for the all 
%           project. 
%
% Synopsis:     feature_()
%               feature_(input1)
%               feature_(input1, input2)
%
% Inputs:   input1  = (optional) This is a string that indicate wich structure field is selected by
%                     the function. String should have the same name as structure fields. If only
%                     this featureeter is define, then output function is the value in the field
%                     defined by input1. Function is "get mode".
%                     Ex.: libraryPath = config('libraryPath');
%           input2  = (optional) If a second input is present, the value of input2 will replace the
%                     field defined by input1. Function is a "set mode".
%                     Ex.: config('isRealData', false);
%
% Output:   output  = Strongly depend on how many input are present.
%                     No input : output gives the entire structure.
%                     1 input  : output gives the values store in the field designated by the input.
%                     2 inputs : There is no output available.

% Notes: 

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.11  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    persistent feature 
    if isempty(feature), % Default values
        
        feature.featureDim                = 0;    % dimension of features
        
        feature.trainingFeature           = 0;    % training feature data
        feature.trainingFeatureLabel      = 0;    % label for each training feature
        feature.nTrainingFeature          = 0;    % number of training feature in all database
        feature.nTrainingFeaturePerClass  = 0;    % number of training feature per class
        feature.nTrainingFeaturePerFile   = 0;    % number of training feature per file

        feature.testingFeature            = 0;    % testing feature data
        feature.testingFeatureLabel       = 0;    % label for each testing feature
        feature.nTestingFeature           = 0;    % number of testing feature in all database
        feature.nTestingFeaturePerClass   = 0;    % number of testing feature per class
        feature.nTestingFeaturePerFile    = 0;    % number of testing feature per file
    end
    
    
    
    switch nargin,
        
        % --- Get functions
        case 0,                             % Get entire structure
            output = feature; 
        case 1,                             % Get requested field        
            output = feature.(varargin{1}); 
    
        % --- Set functions
        case 2,
            if strcmp(varargin{1}, 'load'), % Set the entire structure
                load(varargin{2});
                feature = savedfeature;
            else                            % Set requested field
                feature.(varargin{1}) = varargin{2};
            end
        
        otherwise,
            error('There is too many inputs arguments in ''feature'' function.');
    end
    
end

% EoF -------------------------------------------------------------------------------------------- %
