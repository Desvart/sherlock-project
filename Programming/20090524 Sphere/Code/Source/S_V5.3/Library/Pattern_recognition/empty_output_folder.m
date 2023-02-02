function empty_output_folder()
% EMPTY_OUTPUT_FOLDER     This function deletes all elements present in output folder.

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.02.31  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    if config_('shouldErasePreviousData'),
        
        % --- Display process status and launch function chronometer
        chronoTic = tic;
        process_status();

        nFile = extract_folder_inventory(config_('outputPath')); % Determine number of log file to delete.
        
        % --- If there is no file to delete
        str0 = process_status();
        if nFile == 0,
           fprintf([str0, 'there is no file to delete.\n']);
           process_status(toc(chronoTic));
           return;
        end

        % --- Ask for confirmation before to delete
        if config_('shouldErasePreviousData') == 2,
            qstr = sprintf('Are you sure you want to empty output folder (%d files)?', nFile);
            answer = questdlg(qstr, 'Confirmation box', 'Yes', 'No', 'No');
            if strcmp(answer, 'No'),
                return;
            end
        end

    else
        return;
    end
    
    % --- Delete all file in Logging folder
    delete([config_('outputPath'), '*']);
    
    % --- Store execution time of this function and display process status 
    
    fprintf([str0, 'data successfully removed : %d file(s) deleted.\n'], nFile);
    process_status(toc(chronoTic));
    
%     dbstop in empty_output_folder at 38
end


% EoF -------------------------------------------------------------------------------------------- %
