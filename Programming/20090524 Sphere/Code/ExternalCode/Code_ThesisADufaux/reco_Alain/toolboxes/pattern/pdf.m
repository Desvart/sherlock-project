function pxwi = pdf( x, m, c )
%PDF		Calculate values of p.d.f. for Gaussian distributions
%
%Usage:		P = PDF( X, M, C )
%
% 	This function returns the probability density function
%
%	   p(x|wi)=exp(-0.5*(X-M)'*inv(C)*(X-M))/sqrt((2*pi)^N*det(C))
%
%	where the M and C are extracted from the multi-class list of
%	stats M and C.  Note, all classes are considered equally likely.
%	To generate a likelihood function, generate p(wi)*p(x|wi).
%
%	See also DBAYES, LIKELIHOOD

%	(c) Copyright 1995 by Dave Caughey.  All rights reserved.

pxwi = exp( -dbayes(x,m,c,ones(1,size(m,1)))-log(2*pi)*size(m,1)/2 );
