function isInt = is_int(val)
% IS_INT  This function determines if val is an integer value or a floating value.
%
% Inputs
% - val     [dbl 1x1] Value to test
%
% Outputs
% - isInt   [bool 1x1] true if val is an integer value, else false.


% Project name      : -
% File author       : Pitch Corp.
% Date of creation  : 2011.06.07
% Version           : 0.0.1 (released: 2011.06.07 - not peer reviewed)
% Copyright         : Copyleft
% ------------------------------------------------------------------------------------------------ %


    %%% Handle inputs

    error(nargchk(1, 1, nargin));
    error(nargchk(0, 1, nargout));

    if ~isnumeric(val),
        error('Val input should be numeric.');
        
    elseif ~isreal(val),
        error('Val input should be a real value, not a complex one.');
        
    elseif ~isscalar(val),
        error('Val input should be a scalar value, not an array.');
        
    end
   
    
   
    %%% Function core

    if round(val) == val,
        isInt = true;
        
    else
        isInt = false;
    
    end

end

% ------------------------------------------------------------------------------------------------ %

