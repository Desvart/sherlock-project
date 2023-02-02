clear ;

dirStruct = dir('.\\Ongoing\Sherlock Holmes ABP011\Database\ML\Raw\20111103\');
dirElemNameArray = {dirStruct(:).name}';

nDirElem = length(dirElemNameArray);

lengthArray = [];

for iElem = 1 : nDirElem,
   dirElemName = dirElemNameArray{iElem};
   if strncmp(dirElemName, 'P08_M', 5),
       matObj = matfile(['.\\Ongoing\Sherlock Holmes ABP011\Database\ML\Raw\20111103\', dirElemName]);
       elemSize = size(matObj, 'Data1_AI_7');
       lengthArray = [lengthArray; elemSize(1)];
   end
end