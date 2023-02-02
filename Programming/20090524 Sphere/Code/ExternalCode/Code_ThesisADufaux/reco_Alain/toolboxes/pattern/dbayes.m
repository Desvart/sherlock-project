function dg = dbayes( x, m, c, pw )
%DBAYES		Calculate distance of points to Gaussian clusters
%
%Usage:		D = DBAYES( X, MEANS, COVS [, PW] )
%
% 	This function returns the squared bayesian distances for each point 
%	in X from the MEANS of Gaussian distributions, described
%	by their COVS.  Similarity transforms are used to normalize
%	units of comparison.
%
%	The distance D is defined such that
%	   p(wi)*p(x|wi) = exp(-D)*(2*pi)^(-M/2)
%	which yields
%	   D = -log((2*pi)^(M/2)*p(wi)*p(x|wi))
%	where p(x|wi) is defined as
%	   p(x|wi)=exp(-0.5*(x-m)'*inv(c)*(x-m))/sqrt((2*pi)^M*det(c))
%
%	If PW (the probability of class i) is not specified, the values
%	are assume uniform.
%
%	See also MAHALANOBIS

%	(c) Copyright 1993-1994 by Dave Caughey.  All rights reserved.
[M,N] = size( x );
[m,c] = class_multi(m,c);
K = size(c,1);
if nargin == 3,
    pw = ones(K,1)/K;
end;
pw = log(pw);
for i = 1:K,
    [mx,cx] = class_extract( m, c, i );
    yx = x-mx*ones(1,N);
    [v d] = eig(cx);
    yy = diag(1./sqrt(diag(d)))*v'*yx;
    if M > 1,
	dg(i,:) = -pw(i) + log(det(cx))/2 + (sum(yy.^2))/2;
    else
	dg(i,:) = -pw(i) + log(cx)/2 + (yy.^2)/2;
    end
end;
