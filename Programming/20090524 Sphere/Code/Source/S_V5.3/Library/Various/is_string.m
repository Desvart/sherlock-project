function isString = is_string(input)
% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.14  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    isString = false;
    
    if ~iscell(input),
        if ~isscalar(input),
            if ischar(input),
                if size(input, 1) == 1,
                    isString = true;
                end
            end
        end
    end
end