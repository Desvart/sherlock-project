% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Update waitbar informations
%
% Input
%   - h       [hdl 1x1] Waitbar handel
%   - i       [int 1x1] Current iteration index
%   - nbIt    [int 1x1] Number of crossvalidation
%   - tocHist [dbl 1xi] Stock of crossvalidation execution time
%
% Output
%   -
%
%
% Author    : Pitch Corp.
% Date      : 2011.01.09
% Version   : 0.5.0
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

function waitbarUpdate(h, i, nbIt, tocHist)
    
    %%% Compute median time of execution of a crossvalidation loop
    tocHist(nbIt) = toc; % Update toc historic
    tic;                 % Reset chrono
    meanTime = mean(tocHist(tocHist~=0)); % Mean time execution for crossvalidation loop
    
    ETAsec = (nbIt-i)*meanTime;
    ETAstr = relTime2str(ETAsec);
    
    %%% Display current iteration and ETA on the waitbar
    waitbarLabel1 = sprintf('Iteration : %d/%d  --  ', min(i+1, nbIt), nbIt);
    waitbarLabel2 = sprintf('ETA : %s', ETAstr);
    waitbar(i/nbIt, h, [waitbarLabel1,waitbarLabel2]);

end


% EoF -------------------------------------------------------------------------------------------- %
