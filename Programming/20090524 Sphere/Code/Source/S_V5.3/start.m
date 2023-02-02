function start()
% START     Starting function for Sphere Project. The Sphere project goals is to implement a 
%           modular software plaform for statistical sound recognition algorithms.
%
% Synopsis: start()

% Notes: All default config parameters are defined in config_.m file.

% Todo: See todo.txt file

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.08.31  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % --- Workspace initialization
    close all; clear all; clc;
    [startTime, chrono] = init_script();
    
%     dbstop in start at 21
    % --- Define learning strategy
    define_learning_set(); 

    
    % --- Load raw features
    load_raw_feature();

    
    % --- Display some feature statistics
    %(plotFeat, plotSTDFT, dist interclass, intraclass, covmat, eigenvect and eigval of each class)
%     raw_feature_analysis(); 
    

    % --- Training and testing loop
    learningLog = learning_loop();

    
    % --- Analyse learning statistics
%     learningResult = loop_result_analysis(learningLog);

    dbstop in start at 42
    % --- Log management, back-up results and cleaning process
	learningLog = 0; learningResult = 0;
    closing_process(startTime, chrono, learningLog, learningResult);
    
%     dbstop in start at 40
end %%% End of main function




function [startTime, startChrono] = init_script()
% INIT_SCRIPT   Project initialization.
%
% Synopsis: init_script()
%
% Output:   mainTic     =   [int 1x1] Tic reference to compute project execution time.

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.08.31  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % --- Launch global chronometer
    startChrono = tic;
    
    
    % --- Display script header
    display('                                                                                    ');
    display('% -------------------------------------------------------------------------------- %');
    display('                    STATISTICAL SOUND RECOGNITION TOOLBOX                           ');
    display('                            Alpha 0.5.3 - 2009-2011                                 ');
    display('% -------------------------------------------------------------------------------- %');
    display('                                                                                    ');
    
    
    % --- Add Statistical Sound Recognition Toolbox path to "Matlab search path"
    if exist(config_('libPath'), 'dir'),
        addpath(genpath(config_('libPath')));
    else
        error('ERROR while loading lib path : ''%s'' folder does not exist.\n\n', config_('libPath'));
    end
    
    
    % --- Store the start time of the process
    startTime = now_string();
    
    
	% --- Display process status
    process_status();
    
%     dbstop in start at 92
    % --- Load config if needed
    config_();
    
    
    % --- Extract database param
    database_();
    
    if config_('isDebug'),
        config = config_();
        disp(config);
        db = database_();
        disp(db);
    end
    
    
    % --- Check user inputs
    check_user_input();
    
    
    % --- Display process status
    process_status(toc(startChrono));
    
    
end %%% End of sub-function


% EoF -------------------------------------------------------------------------------------------- %
