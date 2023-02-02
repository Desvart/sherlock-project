function stat = learninganalysis(learningLog)

    % --- Launch function chronometer
    statTic = tic;
    
    % --- Compute statistics for the all learning process based on log data of the process
    stat = computelearningstatistic(learningLog);
    
    % --- Display some statistics of the learning process
    if config('isVerbose'),
        displaylearningstatistic(stat);
    end
    
    % --- Store execution time of this function
    stat.toc = toc(statTic);

end