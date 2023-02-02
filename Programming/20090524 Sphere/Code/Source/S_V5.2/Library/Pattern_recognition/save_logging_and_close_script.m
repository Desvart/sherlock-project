function save_logging_and_close_script(chrono, learningLog)
% FILE DESCRIPTION
% This function saves all relevant data computed during learning process in a mat file and write the
% main one in text file under a human readable format. At the end, the config structure is saved.
%
% Input
%   - ????????? 
%
% Output
%   - 
%
%
% Author    : Pitch Corp.
% Date      : 2011.08.14
% Version   : 0.5.2
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %
    
%     if config_('shouldSaveLogging'),
% 
%         % Launch chrono for saving time
%         tic;
% 
%         %%% Extract some relevant values
%         nbIt     = learningParam.nbIt;
%         globPerf = loopLog(nbIt).globPerf;
%         loopToc  = loopLog(nbIt).toc;
% 
%         % Signal beginning of the log file saving to command window
%         fprintf('Ongoing process: saving log files...\n');
% 
%         %%% Build file name based on date and hour of the saving process
%         [nowStr, dateNow] = now_string();
%         fileName = sprintf('%s_%4.0f_log', nowStr, globPerf*100);
%         filePath = ['./Logging/',fileName,'.txt'];
% 
%         % Open file
%         fid = fopen(filePath, 'w');
% 
%         %%% Write log into file     
%         fprintf(fid, load_log_template(), datestr(dateNow, 'HH:MM:SS dd/mm/yyyy'),...
%                                         relTime2str(feat.toc), ...
%                                         relTime2str(loopToc), ...
%                                         relTime2str(loopToc/nbIt), ...
%                                         relTime2str(stat.toc), ...
%                                         43.4);
% 
%         % Close file
%         fclose(fid);
% 
%         % Save learning data into a mat file
%     %     save([fileName,'.mat'], 'dbProp', 'featParam', 'learningParam', 'modelParam', 'feat', 'loopLog');
% 
%         % Add saving time to log file
%         last_saving(filePath, toc(h_tic), toc, feat.toc, loopToc, stat.toc, dbProp);
% 
%         % Signal end of the log file saving into command window
%         fprintf('Log files saved (<a href = "%s">%s.txt</a>).\n\n', filePath, fileName);
%     
%     else
%         
%         dateStr = '';
%         
%     end % if config('shouldSaveLogging')
%     
%     % --- Save config structure
%     if config_('shouldSaveConfig'),
%         config_('save', savingDate);
%     end
    
    
    % --- Remove library path from Matlab search path
    rmpath(genpath(config_('libPath')));
    
    
end


% SUB FUNCTION ----------------------------------------------------------------------------------- %
% This function contains the log file template
% ------------------------------------------------------------------------------------------------ %

function logTemplate = load_log_template()

    logTemplate = ['STATISTICAL PATTERN RECOGNITION TOOLBOX\n', ...
           'Log file saved at %s\n', ...
           '\n', ...
           'Time for features extraction\t\t: %s\n', ...
           'Time for crossvalidation loop\t\t: %s (~%s / loop)\n', ...
           'Time for computing learning statistics\t: %s\n', ...
           'Time for saving learning log\t\t: 00:00:00\n', ...
           'Time for various operations\t\t: 00:00:00\n', ...
           '\t\t\t  --------\n', ...
           'Total time of execution\t\t: 00:00:00\n', ...
           '\n', ...
           '%f', ...
           ...
           ];
       
end


% SUB FUNCTION ----------------------------------------------------------------------------------- %
% Add saving time to log file
% ------------------------------------------------------------------------------------------------ %

function last_saving(filePath, totalTime, savingTime, featTime, loopTime, statTime, dbProp)

    fid = fopen(filePath, 'r+');
    
    if isempty(dbProp),
        str = 'generation';
        fseek(fid, 97, 'bof');
        fprintf(fid, '%s', str);
    end
    
    fseek(fid, 263, 'bof');
    fprintf(fid, '%s', relTime2str(savingTime));
    
    fseek(fid, 32, 'cof');
    deltaTime = totalTime - featTime - savingTime - loopTime - statTime;
    fprintf(fid, '%s', relTime2str(deltaTime));
    
    fseek(fid, 42, 'cof');
    fprintf(fid, '%s', relTime2str(totalTime));
    
    
    fclose(fid);
       
end


% EoF -------------------------------------------------------------------------------------------- %
