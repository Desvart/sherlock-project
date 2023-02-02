function dispv(str, varargin)
% DISPV display a string dependant of last input value. If last input is true, display the string.
% Else do nothing.
%
%   DISPV(STR, INPUT1, INPUT2, ..., INPUTN, VERBOSE) displays the formated string STR with INPUT1-N
%   variables only if VERBOSE is true. Else do nothing.
%
%   Example : 
%   dispv('%s : John is the number %d.', date(), 1, true);
%
%   See also FPRINTF.

% 2012.11.08 - 2012.11.08 (Vers. 0.1.0)
% Pitch


    if varargin{end} == true,
       
        fprintf(str, varargin{1:end-1});
        
    end

end