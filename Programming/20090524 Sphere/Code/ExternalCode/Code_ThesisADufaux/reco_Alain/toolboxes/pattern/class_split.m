function [mnew,cnew] = class_split(mold,cold,index)
%CLASS_SPLIT	Divide member of multi-class lists of statistics
%
%Usage: 	[M_NEW,C_NEW] = CLASS_SPLIT( M_OLD, C_OLD [,INDEX] )
%
%  	This function splits a statistical distribution into two parts.
%	The source distribution described by M_OLD and C_OLD, can either use
%	a single class statistics, or use entries from a multi-class
%	list with the splitable class specified by INDEX

%	(c) Copyright 1993-1995 by Dave Caughey.  All rights reserved.

if nargin < 2 | nargin > 3 | nargout ~= 2,
    help class_split
    return
elseif nargin == 2,
    index = 1;
end

[mold,cold] = class_multi( mold, cold );

[K,M] = size(mold);
[m,c] = class_extract( mold, cold, index );

[ev ed] = eig(c);
j = maxi(diag(ed));
mold(index,:) = m'-sqrt(ed(j,j))*ev(:,j)';
mold(K+1,:) = m'+sqrt(ed(j,j))*ev(:,j)';
ed(j,j)=ed(j,j)/sqrt(2);
cx = ev*ed*ev'; cx = (cx+cx')/2;    % make sure it is symmetric
cold(index,:) = cx(:)';
cold(K+1,:) = cx(:)';
mnew = mold;
cnew = cold;
