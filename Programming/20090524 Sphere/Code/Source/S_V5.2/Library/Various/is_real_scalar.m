function isRealScalar = is_real_scalar(input)
% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.14  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    isRealScalar = false;
    
    if ~iscell(input),
        if isscalar(input),
            if ~ischar(input),
                if isreal(input),
                    isRealScalar = true;
                            
                end
            end
        end
    end
end