% ----------------------------------------------------------------------------------------
% Function : genereateFileList.m
% 
% Purpose  : This function builds a list of file path sort by the list of index given in
%            input. The files are assumed to have format 'nameXXX.wav, where : 
%            name is the core of the name (always the same, no length constraint)
%            XXX is a N digit number, wich values are listed in the vector 'index'. The N
%            size is 'fileExtension_Size-4'.
 %           The returned matrix 'filenames' holds one name per line.
%
% Inputs :  
%       fileRootPath    [string] Root path of the files belonging to the class. Ex.:
%                       './small_database/cris/scream'
%
%       index           [vector] list of indexes to extract
%
%       fileExtension_Size [scalar] Size of files extension (000.wav = 7; 0000.wav = 8)
%       
%
% Outputs : 
%       fileList        [cell matrix] List of file path, one per row.
%       
%
%
% Author    : Pitch Corp.
% Date      : 6.06.2010
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------


function [fileList] = genereateFileList(fileRootPath, index, fileExtension_Size)
    
    nbFile = length(index);
    fileList = cell(nbFile, 1); % Preallocation
    for i = 1 : nbFile,
        indexShortStr   = int2str(index(i));
        indexSize       = length(indexShortStr);
        zeroPadding     = int2str(10^(fileExtension_Size-4-indexSize));
        indexStr        = [zeroPadding(2:end), indexShortStr, '.wav'];
        fileList{i}     = [fileRootPath, indexStr];
    end
    
end %function


% --------------------------------- End of file ------------------------------------------
