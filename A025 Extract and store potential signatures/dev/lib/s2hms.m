function timeStr = s2hms(timeInSecs, strFormat)
% S2HMS  converts a time in seconds to a string giving the time in hours, minutes and second
%
% Inputs :
% - timeInSecs      [int 1x1] number of second to convert
% - strFormat       [bool 1x1] if true, output is in HH:MM:SS.FFF format. Else it is in 
%                   ..h ..m ..s ...ms (all msb which are zero are not displayed).
%                   Default : false.
%
% Output :
% - trimStr         [str 1xs] Time string

% 2012.11.08 - 2012.11.08 (Vers. 0.1.0)
% Pitch



    %% Initialization

    
    if nargin == 1, strFormat = false; end

    timeStr = '';
    nHours  = 0;
    nMins   = 0;
    str     = '%d';
    
    
    
    %% Start function core
    
    
    %%% Handle hours
    if timeInSecs >= 3600,
        nHours  = floor(timeInSecs/3600);
        unitStr = 'h ';
        if strFormat, 
            str     = '%2.2d'; 
            unitStr = ':'; 
        end
        timeStr = [timeStr, sprintf(str, nHours), unitStr];
    end
    
    
    %%% Handle minutes
    if timeInSecs >= 60,
        nMins   = floor((timeInSecs - 3600*nHours)/60);
        unitStr = 'm ';
        if strFormat, 
            str     = '%2.2d'; 
            unitStr = ':'; 
        end
        timeStr = [timeStr, sprintf(str, nMins), unitStr];
    end
    
    
    %%% Handle seconds
    nSecs   = floor(timeInSecs - 3600*nHours - 60*nMins);
    unitStr = 's ';
    if strFormat, 
        str     = '%2.2d'; 
        unitStr = '.'; 
    end
    timeStr = [timeStr, sprintf(str, nSecs), unitStr];
    
    
    %%% Handle milliseconds
    nMSecs  = floor((timeInSecs - 3600*nHours - 60*nMins - 1*nSecs) * 1000);
    unitStr = 'ms';
    if strFormat, 
        unitStr = ''; 
    end
    timeStr = [timeStr, sprintf('%3.3d', nMSecs), unitStr];
    
    
    
    %% End of function core
    
end
%eof