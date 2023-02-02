function J = divergence( m1, c1, m2, c2 )
%DIVERGENCE	Calculate the divergence between Gaussian classes
%
%Usage:		J = DIVERGENCE( M, C )
%		J = DIVERGENCE( M1, C1, M2, C2 )
%
%	This function returns the divergence of two distributions described
%	by their means M and covariances C.
%
%	See Tou&Gonazeles, Pattern Recognition Principles, Eq 7.8-10

%	(c) Copyright 1993-1994 by Dave Caughey.  All rights reserved.
M = size(m1,2);
if nargin == 2,
    [m2,c2] = class_extract( m1, c1, 2 );
    [m1,c1] = class_extract( m1, c1, 1 );
end;
d = m1-m2;
ic2 = inv(c2);
ic1 = inv(c1);
J = 0.5*trace( (c1 - c2)*(ic2 - ic1) ) + 0.5*trace( (ic1 + ic2)*d*d' );
