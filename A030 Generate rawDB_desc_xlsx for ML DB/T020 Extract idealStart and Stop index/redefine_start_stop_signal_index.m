% This script extracts the signal length (in samples) of each mat-file signal that is present in 'dirPath' and
% which name start by 'startNameStr'. 'varName' contains the name of the variable that host the
% signal.
% Be careful : it is simpler to import final data in excel file by opening the variable GUI of
% matlab by double clicking in the variable tagArray and to copy data from there than to copy data
% from Command Window.

% Author : Pitch
% Date   : 2013.05.03 - 2013.05.06



%%

clc;
clear all;
close all;



%%

projectRootPath     = '.\\Ongoing\Sherlock Holmes ABP011\';
databasePath        = [projectRootPath, 'Database\ML\Raw\'];
dirPath             = [databasePath, '20121129\Exports\'];

% startNameStr        = 'P08_M';
startNameStr        = 'ML1';

varName1            = 'Data1_AI_7';
varName2            = 'Sample_rate';

dispSize            = 1/4;



%%

dirStruct = dir(dirPath);
dirElemNameArray = {dirStruct(:).name}';

nDirElem = length(dirElemNameArray);



%%

screenSize = get(0, 'ScreenSize');
figH = figure('color', 'white');
set(figH, 'Position', [screenSize(3), 0, screenSize([3, 4])]);

% Create dataCursor object (needed to retrieve dataCursor values)
dcmObj = datacursormode(gcf); 



%%
% Ugly way to do it since I don't compute the number of effective signal file. Due to that, I cannot
% do a proper preallocation for each variable. To workaround this situation I flip through all
% elements in the folder and if their name match I treat them. So, in the final variable, 'tagArray'
% line containing only zeros should not be taken in account.

tagArray = zeros(nDirElem, 2); % Prealloc

for iElem = 1 : nDirElem,
    
   dirElemName = dirElemNameArray{iElem};
   
   if strncmp(dirElemName, startNameStr, length(startNameStr)),
       
        % Extract variables from mat-file
        matObj      = matfile([dirPath, dirElemName]);
        signal      = eval(sprintf('double(matObj.%s)', varName1));
        fs          = eval(sprintf('double(matObj.%s)', varName2));

        % Truncate signal so to only keep beginning and ending part of the signal. Size to keep on 
        % each side are fs*dispSize.
        sSignal         = length(signal);
        samplesToKeep   = [1 : (fs*dispSize), (sSignal-fs*dispSize) : sSignal];
        truncateSignal  = signal(samplesToKeep);
        
        % Plot truncate signal
        clf;
        stem([fs/4, fs/4+1], [max(truncateSignal), min(truncateSignal)], 'Color', 'red');
        hold on;
        plot(truncateSignal);
        axis tight;
        
        
        
        
        %% This while loop check how many data cursor have been created and then, depending on that 
        % value can procced to different action, from build correct index to asking to define again 
        % data cursor because there is more than two that have been defined.
        
        nDetectedTags = 0; % init while loop
        while nDetectedTags ~= 2,

            % Stop script to allow user to check the signal and, if needed, to place data cursors.
            disp('Are you done with signal ?')
            pause();

            % Extract all data cursor information 
            infoStruct = getCursorInfo(dcmObj);
            
            % If no data cursor have been set.
            if isempty(infoStruct),
                
                tagXPosition = [1, sSignal];
                
            % If at least one data cursor has been set.
            else
                
                % Extract data cursors position
                tagPosition = [infoStruct.Position];
                tagXPosition = tagPosition(end-1:-2:1);
                
                % Extracted number of detected data cursors
                nDetectedTags = length(tagXPosition);

                % If not enough or too much tag are detected, try again
                switch nDetectedTags,
                    
                    % If only one data cursor has been set, script verify tagXPosition to know if
                    % this is a starting tag or an ending tag.
                    case 1,
                        
                        % If redefining only starting signal
                        if tagXPosition < fs*dispSize,
                            tagXPosition = [tagXPosition, sSignal];
                            
                        % If redefining only ending signal
                        else
                            tagXAbsolutePosition = tagXPosition(1) - 2*fs*dispSize + sSignal;
                            tagXPosition = [1, tagXAbsolutePosition];
                        end
                        
                    case 2,
                        
                        % Redefine starting and ending signal
                        tagXAbsolutePosition = tagXPosition(2) - 2*fs*dispSize + sSignal;
                        tagXPosition = [tagXPosition(1), tagXAbsolutePosition];
                        
                    otherwise, % Equivalent to "> 2"
                        
                        tmpString = 'Wrong number of tags (%d detected, should be %d).\n'; 
                        fprintf(tmpString, nDetectedTags, 2);
                        
                end
                
            end
            
            % Update variable 'number of detected data cursor'
            nDetectedTags = length(tagXPosition);
            
        end
    
        % Sort and save detected tags
        tagXPosition = sort(tagXPosition)';
        tagArray(iElem, :) = tagXPosition;
       
   end
   
end

close(figH);



%% Clean final results and display

tagArray(tagArray(:,1)==0 & tagArray(:,2)==0, :) = [];

str = sprintf('Number of processed signals : %d\n', size(tagArray, 1));
disp(str);
disp(tagArray);



% eof