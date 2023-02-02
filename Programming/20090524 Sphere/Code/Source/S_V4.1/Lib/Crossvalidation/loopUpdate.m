% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% This function updates crossvalidation index, waitbar values and display crossvalidation header.
%
% Input
%   - h         [int 1x1] waitbar handle
%   - cvalId    [int 1x1] crossvalidation index
%   - nbCval    [int 1x1] total number of crossvalidation to do
%
% Ouput
%   - cvalId    [int 1x1] crossvalidation index
%
%
% Authors   : Pitch Corp.
% Date      : 2010.11.10
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

function cvalId = loopUpdate(h, cvalId, nbCval)

    % Increment loop index
    cvalId = cvalId + 1;
    
    % Update waitbar
    waitbarUpdate(h, cvalId, nbCval);
    
    %%% Display loop header
    display(' ');
    display(['Iteration #', num2str(cvalId)]);
    display('------------------------------');
    
end


% FUNCTION --------------------------------------------------------------------------------------- %
% Compute ETA and update waitbar
% ------------------------------------------------------------------------------------------------ %

function waitbarUpdate(h, cvalId, nbCval)
    
    %%% Init : ETA computing
    persistent tocHistoric;
    if isempty(tocHistoric),
        tocHistoric = zeros(nbCval, 1);
    end
    
    %%% Compute median time of execution of a crossvalidation loop
    tocHistoric(cvalId) = toc;   % Update toc historic
    tic;                         % Reset chrono
    nbCval2do = nbCval - cvalId; % Number of crossvalidation remaining
    medTime   = median(tocHistoric(tocHistoric~=0)); % Median time execution for crossvalidation loop
    
    %%% Compute Estimate Time of Arrival (ETA) and convert it in format hour:min:sec.
    ETAhour = nbCval2do * medTime / 3600;
    ETAmin  = (ETAhour - floor(ETAhour))*60;
    ETAsec  = (ETAmin - floor(ETAmin))*60;
    
    %%% Display current iteration and ETA on the waitbar
    waitbarLabel1 = sprintf('Iteration : %d/%d  --  ', cvalId, nbCval);
    waitbarLabel2 = sprintf('ETA : %d : %d : %d', floor(ETAhour), floor(ETAmin), round(ETAsec));
    waitbar(cvalId/nbCval, h, [waitbarLabel1,waitbarLabel2]);
    
end


% EoF -------------------------------------------------------------------------------------------- %
