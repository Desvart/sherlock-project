function f = score( member, member_true, m, c, m_true, c_true )
%SCORE		Compare calculated versus a priori classifications
%
%Usage:		SC=SCORE( MEMBER, TRUE_MEMBER )
%
%	This function compares the MEMBER results of the CLASSIFY
%	function against the a priori known TRUE_MEMBER list.

%	(c) Copyright 1993-1994 by Dave Caughey.  All rights reserved.
K = max(max([member_true;member]));

for i = 1:K,
    for j = 1:K,
	f(i,j) = length(find(member==j&member_true==i));
    end;
end;

%fprintf( '\nClassification Matrix (%.1f%% correct) = \n\n', ...
%    100*sum(diag(f))/length(member_true));
%disp(f);
