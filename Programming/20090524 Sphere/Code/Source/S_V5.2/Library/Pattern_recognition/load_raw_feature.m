function chrono = load_raw_feature()
% LOAD_RAW_FEATURE      Generate or extract raw features that will be used for the learning process.
%                       The choise of generating model based raw features or extracting "real" raw
%                       features from an sound database is defined in config_.m file.
%
% Synopsis:     load_raw_feature()
%
% Inputs:   []
%
% Output:   chrono  = execution time of the function (s).

% Notes: 

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.11  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % --- Display process status and launch function chronometer
    chronoTic = tic;
    process_status();

    
    % --- Extract or build raw features
    if isempty(config_('databaseName')), 
        % Generate raw features created from gaussian models
        generate_raw_feature_from_math_model(); 

    else
        % Extract raw features from sound files coming from database
        extract_raw_feature_from_database0(); 

    end
            
    
    % --- Store execution time of this function and display process status 
    chrono = toc(chronoTic);
    process_status(chrono);
    
end


% EoF -------------------------------------------------------------------------------------------- %
