function closing_process(startTime, chrono, learningLog, learningResult)
% FILE DESCRIPTION
% This function saves all relevant data computed during learning process in a mat file and write the
% main one in text file under a human readable format. At the end, the config structure is saved.
%
% Input
%   - ????????? 
%
% Output
%   - 


% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.09.01  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %
    
    % ---
    empty_output_folder();
    
    
    % --- 
    save_logging(startTime, chrono, learningLog, learningResult);
    
    
    % --- Remove library path from Matlab search path
    if ~config_('isDebug'),
        rmpath(genpath(config_('libPath')));
    end

    
end




% EoF -------------------------------------------------------------------------------------------- %
