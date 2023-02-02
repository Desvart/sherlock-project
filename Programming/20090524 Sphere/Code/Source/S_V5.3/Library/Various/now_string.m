function [nowStr, dateNow] = now_string()
% NOW_STRING    Give actual date in 'yyyymmdd_HHMMSS' format under string format.
%
% Synopsis: now_string()
%
% Outputs:  nowStr [str 1xs] String date.
%           dateNow [int 1x1] Date under Matlab format.

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.02.25  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    dateNow  = now;
	nowStr   = datestr(dateNow, 'yyyymmdd_HHMMSS');
    
end

% EoF -------------------------------------------------------------------------------------------- %
