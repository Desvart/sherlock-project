% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% This script displays script header and add needed toolboxes to "Matlab search path".
%
%
% Author    : Pitch Corp.
% Date      : 2011.01.02
% Version   : 0.5.0
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function libPath = initWorkspace(libPath)


    % -------------------------------------------------------------------------------------------- %
    % Display script header
    % -------------------------------------------------------------------------------------------- %

    display('                                                                                    ');
    display('% -------------------------------------------------------------------------------- %');
    display('                    STATISTICAL SOUND RECOGNITION TOOLBOX                           ');
    display('                                 Beta 0.5.0                                         ');
    display('% -------------------------------------------------------------------------------- %');
    display('                                                                                    ');


    % -------------------------------------------------------------------------------------------- %
    % Add Statistical Sound Recognition Toolbox path to "Matlab search path"
    % -------------------------------------------------------------------------------------------- %

    addpath(genpath(libPath));
    
end


% EoF -------------------------------------------------------------------------------------------- %
