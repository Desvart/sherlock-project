function [map,imap] = class_map( mem, mem_true )
%CLASS_MAP	Generate a map relating two membership lists
%
%Usage:		[MAP,IMAP] = CLASS_MAP( MEMBER, TRUE_MEMBER )
%
%	This function defines the mapping between two membership lists.
%	Thus, if a clustering algorithm has re-assigned the class numbers,
%	this function will find the closest fit.
%
%	The two return arrays can be used as following:
%
%		M_TRUE <- M(IMAP,:);
%		C_TRUE <- C(IMAP,:)
%		MEMBER_TRUE <- MAP(MEMBER)
%
%	or conversely,
%
%		M <- M_TRUE(MAP,:);
%		C <- C_TRUE(MAP,:)
%		MEMBER <- IMAP(MEMBER_TRUE)
%
%See Also:	SCORE

%	(c) Copyright 1996 by Dave Caughey.  All rights reserved.

if nargin ~= 2,
    help class_map
    return
end

m = score(mem,mem_true);
map = maxi(m);
if nargout == 2,
    imap = maxi(m');
end;
