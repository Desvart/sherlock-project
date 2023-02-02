% This script extracts the signal length (in samples) of each mat-file signal that is present in 'dirPath' and
% which name start by 'startNameStr'. 'varName' contains the name of the variable that host the
% signal.

% Author : Pitch
% Date   : 2013.05.03 - 2013.05.06


%%

clc;
close all;
clear all;



%%

projectRootPath     = '.\\Ongoing\Sherlock Holmes ABP011\';
databasePath        = [projectRootPath, 'Database\ML\Raw\'];
dirPath             = [databasePath, '20121129\Exports\'];

% startNameStr        = 'P08_M';
startNameStr        = 'ML1';

varName             = 'Data1_AI_7';



%%

dirStruct           = dir(dirPath);
dirElemNameArray    = {dirStruct(:).name}';

nDirElem            = length(dirElemNameArray);



%%
% Ugly way to do it because I don't compute the number of file that really interests me. So I have
% to check each file and then select the right ones with a "if" and by looking to their start name
% string. Ugly but it works.

lengthArray = []; % init

for iElem = 1 : nDirElem,
    
   dirElemName = dirElemNameArray{iElem};
   
   if strncmp(dirElemName, startNameStr, length(startNameStr)),
       
       matObj       = matfile([dirPath, dirElemName]);
       elemSize     = size(matObj, varName);
       lengthArray  = [lengthArray; elemSize(1)];
       
   end
   
end



%%

str = sprintf('Number of file processed : %d\n', length(lengthArray));
disp(str);
disp(lengthArray);


%eof
