% *************************************************************************
% File to build a matrix holding successive overlapped blocks of signal
% *************************************************************************

function [xblocks, nblocks, addedsamples] = build_blocks(x, blocksize, overlap)
 
% This routine re-arrange the input vector x in a matrix.
% Every column holds one block of signal. Blocks can be overlapped
% 'blocksize' mus be an integer number of times 'overlap'.
% Typical values: blocksize = 2048, overlap = 128

% x is converted to a column vector if necessary
s = size(x);
if (s(2)~= 1) x = x'; end;

% Calculate the total number of blocks, taking overlap into account
nblocks = ceil(length(x)/(blocksize-overlap));

% Zero-padding by 'addedsamples' zeros to complete the matrix
addedsamples = blocksize - (length(x)-(nblocks-1)*(blocksize-overlap));
x = [x; zeros(addedsamples,1)];

% Reserve memory for the matrix
xblocks = zeros(blocksize,nblocks);

% Loop to fill in the matrix
for i = 1:nblocks, 
   xblocks(:,i) = x(1+(i-1)*(blocksize-overlap):i*blocksize-(i-1)*overlap);
end;
