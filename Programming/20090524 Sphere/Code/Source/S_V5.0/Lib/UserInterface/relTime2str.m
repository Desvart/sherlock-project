% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Convert a number of seconds in a formated string 00:00:00 (HH:MM:SS)
%
% Input
%   - t [dbl 1x1] number of second to convert
%
% Output
%   - str [str 1x8] formated string HH:MM:SS
%
%
% Author    : Pitch Corp.
% Date      : 2011.01.09
% Version   : 0.5.0
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

function str = relTime2str(t)

    % Build a reference date id
    refDate = datenum('01-Jan-2011 00:00:00');
    
    % Add time to convert to refDate id
    newDate = addtodate(refDate, round(t), 'second');
    
    % Convert newDate id to string
    str = datestr(newDate, 'HH:MM:SS');

end


% EoF -------------------------------------------------------------------------------------------- %
