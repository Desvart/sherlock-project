function [mnew,cnew] = class_join(mold,cold,index)
%CLASS_JOIN	Join members of multi-class lists of statistics
%
%Usage:		[M_NEW,C_NEW] = CLASS_JOIN( M_OLD, C_OLD [,INDICES] )
%
%  	This function joins a two statistical distributions.
%
%	If the source distribution, described by M_OLD and C_OLD, contains
%	more than two classes, the joining classes must be specified
%	by INDEX.

%	(c) Copyright 1993-1995 by Dave Caughey.  All rights reserved.

if nargin < 2 | nargin > 3 | nargout ~= 2,
    help class_join
    return
elseif nargin == 2,
    index = [1 2];
end

[m1,c1] = class_extract(mold,cold,index(1));
[m2,c2] = class_extract(mold,cold,index(2));
[v1,d1] = eig(c1); d1 = diag(d1);
[v2,d2] = eig(c2); d2 = diag(d2);
[y1,i1] = sort(-d1); v1 = v1(:,i1); d1 = diag(d1(i1));
[y2,i2] = sort(-d2); v2 = v2(:,i2); d2 = diag(d2(i2));
if size(mold,2) == 2,
    a1 = atan2(v1(2,1),v1(1,1));
    a2 = atan2(v2(2,1),v2(1,1));
    aj = (a1+a2)/2;
    vj = [cos(aj) -sin(aj); sin(aj) cos(aj)];
    dj = (d1+d2)/2;
    cj = vj*dj*vj';
else
    cj = (c1+c2)/2;
end;

mold(index(1),:) = mean([m1 m2]');
cold(index(1),:) = cj(:)';
[mnew,cnew]=class_delete(mold,cold,index(2));
