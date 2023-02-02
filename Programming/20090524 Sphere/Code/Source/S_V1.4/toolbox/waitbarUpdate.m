% ----------------------------------------------------------------------------------------
% Function : waitbarUpdate.m
% 
% Purpose  : 
%           
% 
% Input:
%   -
%
%   -
%
%   -
%
%   -
%
% 
% Outputs:
%   - 
%
% 
% Author    : Pitch Corp.
% Date      : 18.07.2010
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------

function waitbarUpdate(h, crossValIndex, nbCrossvalidation, lastLoopExecutionTime)
    
    % Initialization for ETA computing
    persistent timeExecutionTable;
    if isempty(timeExecutionTable),
        timeExecutionTable = zeros(nbCrossvalidation, 1);
    end
    
    % Compute Estimate Time of Arrival (ETA) and convert it in format hour:min:sec.
    timeExecutionTable(crossValIndex) = lastLoopExecutionTime;
    nbCrossvalidationRemaining = nbCrossvalidation - crossValIndex;
    medianExecutionTime = median(timeExecutionTable(timeExecutionTable~=0));
    ETAhour = nbCrossvalidationRemaining * medianExecutionTime / 3600;
    ETAmin  = (ETAhour - floor(ETAhour))*60;
    ETAsec  = (ETAmin - floor(ETAmin))*60;
    
    % Display current iteration and ETA on the waitbar
    waitbarLabel1 = sprintf('Iteration : %d/%d  --  ', crossValIndex, nbCrossvalidation);
    waitbarLabel2 = sprintf('ETA : %d : %d : %d',floor(ETAhour),floor(ETAmin),round(ETAsec)); 
    waitbar(crossValIndex/nbCrossvalidation, h, [waitbarLabel1, waitbarLabel2]);
    
end

% --------------------------------- End of file ------------------------------------------
