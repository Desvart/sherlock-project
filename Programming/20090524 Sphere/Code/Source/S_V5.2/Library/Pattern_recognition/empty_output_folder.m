function empty_output_folder()
% EMPTY_OUTPUT_FOLDER     This function deletes all elements present in output folder.

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.02.25  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    if config_('shouldCleanOutputFolder'),
        
        fprintf('Ongoing process: cleaning output folder...\n');

        nFile = extract_folder_inventory(config_('outputPath')); % Determine number of log file to delete.
        
        % --- If there is no file to delete
        if nFile == 0,
               fprintf('There is no file to delete.\n\n');
               return;
        end

        % --- Ask for confirmation before to delete
        if config_('shouldAskForConfirmation'),
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
    
    % --- Display result of cleaning operation
    fprintf('Cleaning successful : %d files deleted.\n\n', nFile)
    
end


% EoF -------------------------------------------------------------------------------------------- %
