function save_logging(startTime, chrono, learningLog, learningResult)


% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.09.01  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %
    
    % --- Display process status and launch function chronometer
    chronoTic = tic;
    process_status();
    
    
    if config_('shouldSaveProcess'),
%         [nowStr, dateNow] = now_string();
        str0 = process_status();
    end
    
    
    % --- Save data    
    if config_('shouldSaveProcess') == 2,
        filePath = database_('save', startTime);
        fprintf([str0, 'database successfully saved : %s\n'], filePath);
        
        filePath = feature_('save', startTime);
        fprintf([str0, 'feature successfully saved : %s\n'], filePath);
        
        filePath = [config_('outputPath'), startTime, '_savedLearningLog.mat'];
        savedLearningLog = learningLog; %#ok<NASGU>
        save(filePath, 'savedLearningLog');
        fprintf([str0, 'learningLog successfully saved : %s\n'], filePath);
        
        filePath = [config_('outputPath'), startTime, '_savedLearningResult.mat'];
        savedLearningResult = learningResult; %#ok<NASGU>
        save(filePath, 'savedLearningResult');
        fprintf([str0, 'learningResult successfully saved : %s\n'], filePath);
        
    end
    

    % --- Save config
    if config_('shouldSaveProcess'),
        filePath = config_('save', startTime);
        fprintf([str0, 'config successfully saved : %s\n'], filePath);
    end

    
    % --- Save logging
    if config_('shouldSaveProcess'),

        %%% Extract some relevant values
%         nTraining = config_('nTraining');
%         globPerf  = learningLog(nbIt).globPerf;
%         loopToc   = learningLog(nbIt).toc;

        %%% Build file name based on date and hour of the saving process
        globPerf = 99.67;
        fileName = sprintf('%s_%4.0f_log', startTime, globPerf*100);
        filePath = [config_('outputPath'), fileName,'.txt'];

        % Open file
        fId = fopen(filePath, 'a');

        %%% Write log into file   
        write_logging(fId, startTime);

        % Close file
        fclose(fId);

        % Save learning data into a mat file
    %     save([fileName,'.mat'], 'dbProp', 'featParam', 'learningParam', 'modelParam', 'feat', 'loopLog');

        % Add total execution time to log file
        fId = fopen(filePath, 'r+');
        fseek(fId, 78, 'bof');
        fprintf(fId, '%s', s_to_hhmmss(toc(chrono)));
        fclose(fId);

        % Signal end of the log file saving into command window
        fprintf([str0, 'log files saved (<a href = "%s">%s.txt</a>).\n'], filePath, fileName);
    
    end % if config('shouldSaveLogging')
    
%    dbstop in save_logging at 82
    % --- Display process status 
    process_status(toc(chronoTic));
    
end



function write_logging(fId, dateNow)


% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.08.31  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    fprintf(fId, 'STATISTICAL PATTERN RECOGNITION TOOLBOX\n');
%     fprintf(fId, '%s\n', datestr(dateNow, 'HH:MM:SS, dd/mm/yyyy'));
    fprintf(fId, [dateNow(10:11), ':', dateNow(12:13), ':', dateNow(14:15), ', ', dateNow(7:8), '/', dateNow(5:6), '/', dateNow(1:4), '\n']);
    fprintf(fId, 'Execution time : 00:00:00\n\n');
    
    fprintf(fId, '------- CONFIGURATION -------\n\n');
    
    if ~isempty(config_('databaseName')),
        fprintf(fId, 'Database used : \t\t\t%s\n', config_('databaseName'));
        fprintf(fId, 'SNR used (training - testing) : \t%d - %d\n', config_('trainingSnr'), config_('testingSnr'));
        fprintf(fId, 'Feature type extracted : \t\t%s (N = %d, S = %f) (see ''config.mat'' for details)\n', config_('extractionType'), length(config_('stdftWindow')), config_('stdftShift'));
    else
        fprintf(fId, 'Database used:  \t\t\tMathematical features (see ''config.mat'' for details)\n');
    end
    
    fprintf(fId, '\nFeature reduction : \t\t\tPCA : %d, LDA : %d\n', config_('nDimPca'), config_('nDimLda'));
    
    if strcmp(config_('modelType'), 'gmm'),
        fprintf(fId, '\nModel used : \t\t\t\tGMM (nGaussian : %d, EMTol : %f)\n', config_('gmmNGmm'), config_('gmmEmTolerance'));
    
    end
    
    if strcmp(config_('modelType'), 'hmm'),
        fprintf(fId, '\nModel used : \t\t\t\tHMM (nState = %d, nGaussian = %d, EMTol = %f)\n', config_('gmmNHmm'), config_('gmmNGmm'), config_('gmmEmTolerance'));
    
    end
    
    nTraining = config_('nTraining');
    fprintf(fId, '\nStrategy used : \t\t\t%1.2f (nTraining : %d, random : %d)\n\n', config_('learningStrategy'), nTraining, config_('isRandom'));
    
    fprintf(fId, '------- LEARNING RESULTS -------\n\n');
    
    
    testingFileId = database_('testingFileId');
    testingFileLabel = database_('testingFileLabel');
    nTestingFile = database_('nTestingFile');
    for iTraining = 1 : nTraining,
        fprintf(fId, '--- Training %d\n', iTraining);
        fprintf(fId, '#    FileId ClassId Membership Certainties Result\n');
        
        for iFile = 1 : nTestingFile,
            fileId    = testingFileId(iTraining, iFile);
            fileLabel = testingFileLabel(iTraining, iFile);
            if 0 == fileLabel,
                resultStr = 'true';
            else
                resultStr = 'false';
            end
            fprintf(fId, '#%3.0d: %3.0d \t %d \t %d \t %3.2f \t %s\n', iFile, fileId, fileLabel, 0, 0, resultStr);
        end
    end

       
end

