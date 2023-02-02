% *************************************************************************
% File to build a filename matrix holding the list of files in a same class
% *************************************************************************

function [filenames] = f(name, indexes);

% The files are assumed to have format 'nameXXX.wav', where:
% 'name' is the core of the name (always the same, no length constraint) 
% 'XXX' is a 3 digit number, which values are listed in the vector 'indexes'.
% The returned matrix 'filenames' holds one name per line.

% Initialization
name = [name '000.wav'];
l = length(name);
filenames = repmat(name, length(indexes), 1);

% Loop to build each line in the matrix
for i=1:length(indexes),
   index = int2str(indexes(i));
   s = size(index);
   filenames(i,l-4-s(2)+1:l-4) = index;
end;
