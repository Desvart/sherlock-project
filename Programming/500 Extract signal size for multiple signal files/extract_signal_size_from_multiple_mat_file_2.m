clear ;

dirStruct = dir('.\\Ongoing\Sherlock Holmes ABP011\Database\ML\Raw\20120509\Exports\');
dirElemNameArray = {dirStruct(:).name}';

nDirElem = length(dirElemNameArray);

lengthArray = [];

for iElem = 1 : nDirElem,
   dirElemName = dirElemNameArray{iElem};
   if strncmp(dirElemName, 'ML0', 3),
       matObj = matfile(['.\\Ongoing\Sherlock Holmes ABP011\Database\ML\Raw\20120509\Exports\', dirElemName]);
       elemSize = size(matObj, 'Data1_AI_7');
       lengthArray = [lengthArray; elemSize(1)];
   end
end