function [mnew,cnew] = class_delete( mold, cold, index );
%CLASS_DELETE	Delete class statistics from multi-class lists of statistics
%
%Usage:		[M_NEW,C_NEW] = CLASS_DELETE( M_OLD, C_OLD, INDEX )
%
%	This function deletes the class(es) defined by INDEX from an 
%	existing list (M_OLD,C_OLD).
%

%	(c) Copyright 1993-1995 by Dave Caughey.  All rights reserved.
if nargin ~= 3 | nargout ~= 2,
    help class_delete
    return;
end

[K,M] = size(mold);
if index < 1 | index > K
    fprintf( 'class_delete: index out-of-range (%d of %d)\n', index, K );
    mnew = mold;
    cnew = cold;
else 
    mask = ones(1,K);
    mask(index) = zeros(size(index));
    mnew = mold(logical(mask),:);
    cnew = cold(logical(mask),:);
end;
