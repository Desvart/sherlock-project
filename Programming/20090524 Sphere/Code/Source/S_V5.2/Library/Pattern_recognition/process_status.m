function process_status(chrono)

    % ---
    persistent processId;
    if isempty(processId),
        processId = 1;
        
    end
    
    
    % ---
    allProcess = {'script initialization',...
               'features extraction',...
               'features generation'};
           
    % --- Select appropriate processes for this execution
    process = allProcess;
    
    
    % ---
    nProcess = length(process);
    str = ['Ongoing process (', num2str(processId), '/', num2str(nProcess), ') : ', process{processId}, '...'];
    
    % ---
    if nargin == 0,
        fprintf([str, '\n']);
        
    else
        fprintf([str, ' done in %4.2f ms!\n'], chrono);
        processId = processId + 1;
    
    end
end
