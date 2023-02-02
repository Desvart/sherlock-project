% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% This function initialize Matlab workspace. All Matlab windows are closed and the Command Window is 
% cleared. All paths needed for the program execution are added to the "Matlab search path". Finally
% the program header is displayed in the Command Window.
%
% Input
%   - libPath [string]  Path of the library
%
% Output
%   - libPath [string]  Path of the library (same as input)
%
%
% Author    : Pitch Corp.
% Date      : 2010.11.10
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

function libPath = initWorkspace(libPath)

    % Check inputs
    error(nargchk(1, 1, nargin));
    
    %%% Clear workspace
    close all;
    clc;

    % Add library path to "Matlab search path"
    addpath(genpath(libPath));
    
    %%% Display program header
    display('                                                                                    ');
    display('% -------------------------------------------------------------------------------- %');
    display('                           SOUND RECOGNITION TOOLBOX                                ');
    display('                                                                                    ');
    display('% -------------------------------------------------------------------------------- %');
    display('                                                                                    ');

end

% EoF -------------------------------------------------------------------------------------------- %
