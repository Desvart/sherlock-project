function [xreduc,A] = reduce( x, v, d, n, balance );
%REDUCE		Reduce dimensionality of data set
%
%Usage:		XREDUC = REDUCE( X, V, D, N, [BALANCE] )
%
%	This function reduces the dimensionality of a vector space X
%	to N using the eigenvalues D and vectors V.
%
%	This routine assumes values and vectors have been sorted in
%	descending order.
%
%	If BALANCE=1 (default), then the eigenvectors are scaled by the
%	inverse square root of the eigenvalues, yielding an XREDUC which
%	has a spherical distribution with unit variance.

%	(c) Copyright 1993-1994 by Dave Caughey.  All rights reserved.

if nargin == 4,
    balance = 1;
end;
if balance,
    A = (diag(1./sqrt(d(1:n)))*v(:,1:n)');
else
    A = v(:,1:n)';
end;
xreduc = A*x;
