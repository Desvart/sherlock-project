function [mnew,cnew] = class_extract( mold, cold, index );
%CLASS_EXTRACT	Extract class statistics from multi-class lists of statistics
%
%Usage:		[M_NEW,C_NEW] = CLASS_EXTRACT( M_OLD, C_OLD, INDEX )
%
%	This function extracts a class defined by INDEX from an 
%	existing list (M_OLD,C_OLD).
%
%	If INDEX is a array, multi-class lists are returned, otherwise
%	single-class statistics are returned

%	(c) Copyright 1993-1995 by Dave Caughey.  All rights reserved.
if nargin ~= 3 | nargout ~= 2,
    help class_extract
    return
end

[K,M] = size(mold);
if index < 1 | index > K
    fprintf( 'class_extract: index out-of-range (%d of %d)\n', index, K );
    mnew = [];
    cnew = [];
elseif length( index ) == 1,
    mnew = mold(index,:)';
    cnew = reshape(cold(index,:),M,M);
else
    mnew = mold(index,:);
    cnew = cold(index,:);
end;
