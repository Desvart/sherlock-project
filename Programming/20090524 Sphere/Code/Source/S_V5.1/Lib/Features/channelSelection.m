% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% This function give select a type of frequency decomposition and give its limites.
%
% Input
%   - channelType [str 1xm] Channel type
%
% Output
%   - channel [dbl 1xn] Channel bands
%
%
% Author    : Pitch Corp.
% Date      : 2011.01.04
% Version   : 0.5.0
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function channel = channelSelection(channelType)

    switch channelType,
        
        case 'None',
            channel = 0;
        
        case 'Bark', % Bark channels
            channel = [0, 100, 200, 300, 400, 510, 630, 770, 920, 1080, 1270, 1480, 1720, ...
                          2000, 2320, 2700, 3150, 3700, 4400, 5300, 6400, 7700, 9500, 12000, ...
                          15500, 21000];
        
        case 'Uniform', % 32 uniform bands up to 16000 hz
            channel = 0 : 500 : 16000; 
        
    end

end

