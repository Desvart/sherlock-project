function dm = mahalanobis( x, m, c )
%MAHALANOBIS	Calculate Mahalanobis distances
%
%Usage:		Y = MAHALANOBIS( X [,M,CX] )
%
%	This function takes a matrix of column vectors, and calculates the
%	Mahalanobis distances for each vector, based on calculated mean
%	and covariances.  The covariance matrix of X must be invertable.
%
%	If the covariance matrix CX is specified, then it is used instead.
%	Note that CX = EYE(SIZE(X,1)) will give Euclidean distance.
%
%	See also DBAYES

%	(c) Copyright 1993-1994 by Dave Caughey.  All rights reserved.
if ( nargin ~= 1 & nargin ~= 3 ),
    help mahalanobis;
else
    M = size(x,1);
    N = size(x,2);
    if ( nargin == 1 ),
	m = mean(x');
	c = reshape(cov(x'),1,M^2);
    else
	[m,c] = class_multi( m, c );
    end;
    K = size(m,1);
    dm = zeros(K,N);
    for i = 1:K,
	y = x-m(i,:)'*ones(1,N);
	cx = inv(reshape(c(i,:),M,M));
	for j = 1:N,
	    dm(i,j) = y(:,j)'*cx*y(:,j);
	end;
    end;
end;
