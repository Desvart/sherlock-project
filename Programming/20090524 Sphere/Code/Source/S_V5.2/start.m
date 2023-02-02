function start()
% START     Starting function for Sphere Project. The Sphere project goals is to implement a 
%           modular software plaform for statistical sound recognition algorithms.
%
% Synopsis: start()

% Notes: All default config parameters are defined in config_.m file.

% Todo: See todo.txt file

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.03  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % --- Workspace initialization
    close all; clear all; clc;
    chrono.main = init_script();

    % --- Load raw features
    chrono.loadRawFeature = load_raw_feature();    
    
    % --- Display some feature statistics
    %(plotFeat, plotSTDFT, dist interclass, intraclass, covmat, eigenvect and eigval of each class)
%     chrono.rawFeatureAnalysis = raw_feature_analysis(); 
    
    % --- Define learning strategy
%     chrono.defineLearningSet = define_learning_set();
    
    % --- Training and testing loop
%     [learningLog, chrono.learningLoop] = learning_loop();

    % --- Analyse learning statistics
%     [stat, chrono.stat] = loop_result_analysis(learningLog);
  
    % --- Log management
%     empty_output_folder();
%     learningLog = 0;
%     save_logging_and_close_script(chrono, learningLog);
 
% a = feature_();
% b = config_();
    
end %%% End of main function




function mainTic = init_script()
% INIT_SCRIPT   Project initialization.
%
% Synopsis: init_script()
%
% Output:   mainTic     =   [int 1x1] Tic reference to compute project execution time.

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.11  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % --- Launch global chronometer
    mainTic = tic;
        
    
    % --- Display script header
    display('                                                                                    ');
    display('% -------------------------------------------------------------------------------- %');
    display('                    STATISTICAL SOUND RECOGNITION TOOLBOX                           ');
    display('                            Alpha 0.5.2 - 2009-2011                                 ');
    display('% -------------------------------------------------------------------------------- %');
    display('                                                                                    ');
    
    
    % --- Add Statistical Sound Recognition Toolbox path to "Matlab search path"
    if exist(config_('libPath'), 'dir'),
        addpath(genpath(config_('libPath')));
    else
        error('ERROR while loading lib path : ''%s'' folder does not exist.\n\n', config_('libPath'));
    end
    
    
	% --- Display process status
    process_status();
    
    
    % --- Load config if needed
    config_();
    
    
    % --- Extract database param
    database_();
    
    if config_('isVerbose'),
        config = config_()
        db = database_()
        dbstop in start at 89
    end
    
    
    % --- Check user inputs
    check_user_input();
    
    
    % --- Display process status
    process_status(toc(mainTic));
    
    
end %%% End of sub-function


% EoF -------------------------------------------------------------------------------------------- %
