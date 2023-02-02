function pwpxwi = likelihood( x, m, c, pw )
%LIKELIHOOD	Calculate likelihoods for Gaussian distributions
%
%Usage:		P = LIKELIHOOD( X, M, C, PW )
%
% 	This function returns the likelihood p(wi)*p(x|wi) where
%
%	   p(x|wi)=exp(-0.5*(X-M)'*inv(C)*(X-M))/sqrt((2*pi)^N*det(C))
%
%	and where the M and C are extracted from the multi-class list of
%	stats M and C.  Note, the class probabilities must be specified.
%
%	See also DBAYES, PDF

%	(c) Copyright 1995 by Dave Caughey.  All rights reserved.

M = prod(size(c))/prod(size(m));
pwpxwi = exp( -dbayes(x,m,c,pw)-log(2*pi)*M/2 );
