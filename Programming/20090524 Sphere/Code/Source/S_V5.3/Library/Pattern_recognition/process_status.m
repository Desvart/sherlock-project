function str0 = process_status(chrono)
% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.08.31  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %
    % ---
    persistent processId;
    if isempty(processId),
        processId = 1;
        
    end
    
    
    % ---
    process = {'script initialization',...
               'learning sets definition', ...
               'features extraction',...
               'features generation', ...
               'raw feature analysis', ...
               'learning loop' ...
               'loop post processing', ...
               'output folder dumping', ...
               'saving logging'};
           
           process = {'script initialization',...
               'learning sets definition', ...
               'features extraction',...
               'features generation', ...
               'learning loop' ...
               'removing data from previous learning', ...
               'saving logging'};
           
           
    % --- Select appropriate processes for this execution
    if isempty(config_('databaseName')),
        process(3) = [];
    else
        process(4) = [];    
    end
    
    if config_('shouldErasePreviousData') == false,
        process(8) = [];
    end
    
    
    % ---
    nProcess = length(process);
    str0 = ['Ongoing process (', num2str(processId), '/', num2str(nProcess), ') : '];
    str  = [str0, process{processId}, '...'];
    
    
    % ---
    if nargout == 0,
        if nargin == 0,
            fprintf([str, '\n']);

        else
            fprintf([str, ' done in %4.2f s!\n\n'], chrono);
            processId = processId + 1;
        end
    end
        
end
