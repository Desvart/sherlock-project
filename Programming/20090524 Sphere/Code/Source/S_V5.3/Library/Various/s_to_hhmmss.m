function str = s_to_hhmmss(s)
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

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.08.31  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % Build a reference date id
    refDate = datenum('01-Jan-2011 00:00:00');
    
    % Add time to convert to refDate id
    newDate = addtodate(refDate, round(s), 'second');
    
    % Convert newDate id to string
    str = datestr(newDate, 'HH:MM:SS');

end


% EoF -------------------------------------------------------------------------------------------- %
