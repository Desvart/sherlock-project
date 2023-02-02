function tocHist = waitbar_update(h, iTraining, nTraining, tocHist)
    
% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.09.05  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    %%% Compute median time of execution of a crossvalidation loop
    tocHist(nTraining) = toc; % Update toc historic
    tic;                 % Reset chrono
    meanTime = mean(tocHist(tocHist~=0)); % Mean time execution for crossvalidation loop
    
    ETAsec = (nTraining-iTraining) * meanTime;
    ETAstr = s_to_hhmmss(ETAsec);
    
    %%% Display current iteration and ETA on the waitbar
    waitbarLabel1 = sprintf('Iteration : %d/%d  --  ', min(iTraining+1, nTraining), nTraining);
    waitbarLabel2 = sprintf('ETA : %s', ETAstr);
    waitbar(iTraining/nTraining, h, [waitbarLabel1, waitbarLabel2]);

end