function isPow2 = is_pow2(val)
% IS_POW2  This function determine if input is a power of 2 or not.
%
% Inputs
% - val     [uint 1x1] value to test
%
% Outputs
% - isPow2  [bool 1x1] true if val is a power of 2, else false.


% Project name      : -
% File author       : Pitch Corp.
% Date of creation  : 2011.06.07
% Version           : 0.0.1 (released: 2011.06.07 - not peer reviewed)
% Copyright         : Copyleft
% ------------------------------------------------------------------------------------------------ %


    %%% Handle inputs

    error(nargchk(1, 1, nargin));
    error(nargchk(0, 1, nargout));

    if val == 0,
        error('Input cannot be 0 (2^-Inf -> 0)');
        
    end
    
    if val < 0,
        val = -val;
        warning('Input:wrong', 'Value cannot be negative. is_pow2 is done on abs(val).');
        
    end
    
    
    

    %%% Function core
    % Use binary reprensentation of val to determine if val is a power of 2. If it is only one bit
    % is set to 1 and all others are 0. We use this property to determine if val is a power of two
    % or not.

    if bitand(val, val-1),
        isPow2 = false;
        
    else
        isPow2 = true;
        
    end

end

% ------------------------------------------------------------------------------------------------ %

