function [mnew,cnew] = class_add( mold, cold, madd, cadd, index );
%CLASS_ADD	Add class statistics to multi-class lists of statistics
%
%Usage:		[M_NEW,C_NEW] = CLASS_ADD( M_OLD, C_OLD, M_ADD, C_ADD [,INDEX] )
%
%	This function inserts single-class stats (or multi-class list)
%	defined by mean M_ADD and covariance C_ADD to an existing list
%	(M_OLD,C_OLD).
%
%	The default action is to append the new class(es), but if INDEX
%	is specified then the class(es) is(are) inserted.
%

%	(c) Copyright 1993-1995 by Dave Caughey.  All rights reserved.
if nargin < 4 | nargin > 5 | nargout ~= 2,
    help class_add
    return;
end

[mold,cold] = class_multi( mold, cold );
[madd,cadd] = class_multi( madd, cadd );

[Kold,Mold] = size(mold);
[Kadd,Madd] = size(madd);

if nargin == 4,
    index = size(mold,1)+1;
end;

if index < 1 | index > Kold,
    fprintf( 'class_add: index out-of-range (%d of %d)\n', index, Kold );
    mnew = mold;
    cnew = cold;
elseif index == 1,
    mnew = [madd;mold];
    cnew = [cadd;cold];
elseif index == Kold+1,
    mnew = [mold;madd];
    cnew = [cold;cadd];
else
    mnew = [mold(1:index-1,:);madd;mold(index:Kold,:)];
    cnew = [cold(1:index-1,:);cadd;cold(index:Kold,:)];
end;
