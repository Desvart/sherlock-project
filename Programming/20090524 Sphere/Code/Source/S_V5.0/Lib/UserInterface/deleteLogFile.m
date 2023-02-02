% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% This function deletes all previously saved log file (.txt and .mat) in Logging folder.
%
% Input
%   - boolDel [bool 1x1] If true, delete all files.
%   - boolChk [bool 1x1] If true, ask for confirmation before deleting
%
% Output
%   - 
%
%
% Author    : Pitch Corp.
% Date      : 2011.01.09
% Version   : 0.5.0
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function deleteLogFile(boolDel, boolChk)

    if boolDel == true,
        
        % Signal beginning of the log file deleting into command window
        fprintf('Ongoing process: deleting previous log files...\n');
        
        % Determine number of log file to delete.
        nbFile = folderInventory('./Logging/');
        
        %%% If there is no file to delete
        if nbFile == 0,
               fprintf('There is no file to delete.\n\n');
               return;
        end

        %%% Ask for confirmation before deleting
        if boolChk == true,
            qstr = sprintf('Are you sure you want to delete all previously saved log files (%d files)?', nbFile);
            answer = questdlg(qstr, 'Confirmation box', 'Yes', 'No', 'No');
            if strcmp(answer, 'No'),
                return;
            end
        end

    else
        return;
    end
    
    % Delete all file in Logging folder
    delete('./Logging/*');
    
    %%% Signal end of the log file deleting into command window
    if nbFile == 1,
        fprintf('1 log file deleted.\n\n');
    else
        fprintf('%d log files deleted.\n\n', nbFile);
    end
    
end


% EoF -------------------------------------------------------------------------------------------- %
