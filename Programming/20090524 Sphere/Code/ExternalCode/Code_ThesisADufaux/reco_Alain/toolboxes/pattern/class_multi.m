function [mnew,cnew] = class_multi( mold, cold );
%CLASS_MULTI	Force class statistics into multi-class lists of statistics
%
%Usage:		[M_NEW,C_NEW] = CLASS_MULTI( M_OLD, C_OLD )
%
%	This function eliminates ambiguity over the dimensionality and
%	number of classes that can exist when examining only either the
%	means or covariances alone.
%
%	Multi-class lists of statistics are returned.  If M_OLD and C_OLD
%	are already multi-class lists, nothing is done.

%	(c) Copyright 1993-1995 by Dave Caughey.  All rights reserved.

if nargin ~= 2 | nargout ~= 2,
    help class_multi
    return
end

msize = prod(size(mold));
csize = prod(size(cold));
M = csize/msize;
K = msize/M;

if all( size(mold) == [K M] ) & all( size(cold) == [K M^2] ),
    mnew = mold;
    cnew = cold;
elseif length(mold(:)) == M & all( size(cold) == [M M] ),
    mnew = mold(:)';
    cnew = cold(:)';
else
    mnew = [];
    cnew = [];
    fprintf( 'class_multi: incorrect statistics specifications\n' );
end;
