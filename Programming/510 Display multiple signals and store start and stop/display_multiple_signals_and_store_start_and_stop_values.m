clc;
clear all;
close all;

dirStruct = dir('.\\Ongoing\Sherlock Holmes ABP011\Database\ML\Raw\20111103\');
dirElemNameArray = {dirStruct(:).name}';

nDirElem = length(dirElemNameArray);

lengthArray = [];
figure;
dcm_obj = datacursormode(gcf); 

tagArray = zeros(nDirElem, 2); % Prealloc
for iElem = 1 : nDirElem,
   dirElemName = dirElemNameArray{iElem};
   if strncmp(dirElemName, 'P08_M', 5),
       matObj = matfile(['.\\Ongoing\Sherlock Holmes ABP011\Database\ML\Raw\20111103\', dirElemName]);
       
       elemSize = size(matObj, 'Data1_AI_7');
       
       signal = double(matObj.Data1_AI_7);
       fs = double(matObj.Sample_rate);
       
       plot(signal([1:fs/4, elemSize(1)-fs/4:end]));
       
       
       nDetectedTag = 0; % init
        while nDetectedTag ~= 2,

            pause();

            % Extract data cursor position
            info_struct = getCursorInfo(dcm_obj);
            if ~isempty(info_struct),
                tagPosition = [info_struct.Position];
                tagXPosition = tagPosition(end-1:-2:1);

                % If not enough or too much tag are detected, try again
                nDetectedTag = length(tagXPosition);
                
                if nDetectedTag == 1,
                    result = input('Start (1) or Stop (2) ?');
                    if result == 1,
                        tagXPosition = [tagXPosition, elemSize(1)];
                        nDetectedTag = 2;
                    end
                    if result == 2,
                        tagXPosition = [0, tagXPosition-fs/4+elemSize(1)-fs/4];
                        nDetectedTag = 2;
                    end
                end
                
                if nDetectedTag == 2,
                         tagXPosition = [tagXPosition(1), tagXPosition(2)-fs/4+elemSize(1)-fs/4];
                end
                
                if nDetectedTag > 2,
                    tmpString = 'Wrong number of tags (%d detected, should be %d).\n'; 
                    fprintf(tmpString, nDetectedTag, 2);
                end
            else
                tagXPosition = [0, elemSize(1)];
                nDetectedTag = 2;
            end
        end
    
        % Sort and save detected tags
        tagXPosition = sort(tagXPosition)';
        tagArray(iElem, :) = tagXPosition;
   end
end